module CoolGames
  module GameInPlay
    OP_SUCCESS    = 0
    OP_FAILURE    = 1
    OP_JAVASCRIPT = 2

    def current_user_is_player?
      logged_in? and [black_id, white_id].include?(current_player.id)
    end

    def current_user_is_black?
      logged_in? and current_player.id == black_id
    end

    def current_user_is_white?
      logged_in? and current_player.id == white_id
    end

    def play params
      code = OP_SUCCESS
      message = ''

      parent_move_id = params[:parent_move_id]
      x = params[:x].to_i
      y = params[:y].to_i

      # color is optional and used for validation purpose only
      color = translate_color params[:color]
      if color and color != whose_turn
        message_key = color == Game::WHITE ? 'games.black_to_play_next' : 'games.white_to_play_next'
        return OP_FAILURE, I18n.t(message_key)
      end

      if x < 0 or x > board_size - 1 or y < 0 or y > board_size - 1
        return OP_FAILURE, I18n.t('games.incorrect_move').sub('MOVE', "#{x}, #{y}")
      end

      parent_move = parent_move_id.blank? ? last_move : find_move(parent_move_id)

      unless move = parent_move.child_that_matches(x, y)
        if guess_move?(parent_move.color, current_player.id)
          # This is a counter move, should replace previous counter move
          parent_move.children.each(&:destroy)
        end

        move = parent_move.children.build
        move.move_no = parent_move.move_no + 1
        if move.move_no == 1
          move.color = start_side
        else
          move.color = parent_move.color == Game::BLACK ? Game::WHITE : Game::BLACK
        end
        move.x = x
        move.y = y
        move.parent = parent_move
        move.guess_player = current_player

        case move.process
          when GameMove::OCCUPIED then return OP_FAILURE, I18n.t('games.occupied')
          when GameMove::SUICIDE then return OP_FAILURE, I18n.t('games.suicide')
          when GameMove::BAD_KO then return OP_FAILURE, I18n.t('games.bad_ko')
        end
      end

      if last_move.id == parent_move.id and my_turn?
        self.moves += 1
        move.player = current_player
        change_turn
        #self.formatted_moves += CoolGames::Sgf::NodeRenderer.new(:with_name => true).render(move)
      end

      move.played_at = Time.now
      move.save!
      parent_move.save!
      save!

      process_guess_moves

      return code, message
    end

    def resign
      unless logged_in?
        raise OP_FAILURE, I18n.t('games.not_logged_in')
      end

      code = OP_SUCCESS
      message = ''

      if current_player.id == black_id
        self.state  = 'finished'
        self.winner = Game::WHITE
        self.result = "W+R"
        send_resign_message current_player.user, white_player.user, Game::BLACK
      elsif current_player.id == white_id
        self.state  = 'finished'
        self.winner = Game::BLACK
        self.result = "B+R"
        send_resign_message current_player.user, black_player.user, Game::WHITE
      else
        code    = OP_FAILURE
        message = I18n.t('games.not_a_player_in_game').sub('GAME_ID', self.id).sub('USERNAME', current_player.name)
      end

      save!
      return code, message
    end

    def undo_guess_moves
      return unless logged_in?

      GameMove.moves_after(last_move).each do |move|
        move.delete if move.player_id.nil? and move.guess_player_id == current_player.id
      end

      undo_last_move
    end

    def undo_last_move
      move = last_move
      return if move.player_id != current_player.id

      change_turn

      #last_move_start = formatted_moves.rindex(";") - 1
      #self.formatted_moves = formatted_moves[0..last_move_start] if last_move_start >= 0

      move.delete
    end

    def mark_dead x, y
      move = last_move
      orig_dead = move.dead.nil? ? [] : move.dead.clone
      if group = move.board.get_dead_group_for_marking(x, y)
        move.dead = (orig_dead + group).uniq
        move.save!
      end
    end

    def my_color
      if current_player.id == black_id
        Game::BLACK
      elsif current_player.id == white_id
        Game::WHITE
      end
    end

    def my_turn?
      (current_player.id == black_id and whose_turn == Game::BLACK) or
      (current_player.id == white_id and whose_turn == Game::WHITE)
    end

    def guess_move? move_color, player_id
      (move_color == Game::WHITE and player_id == black_id) or
              (move_color == Game::BLACK and player_id == white_id)
    end

    private

    def translate_color color_str
      return unless color_str

      color_str.downcase!

      if color_str == 'black' || color_str == Game::BLACK.to_s
        Game::BLACK
      elsif color_str == 'white' || color_str == Game::WHITE.to_s
        Game::WHITE
      end
    end

    def process_guess_moves
      return unless logged_in?

      guess_move = guess_moves.detect do |move|
        my_color and my_color != move.color and current_player != move.guess_player
      end

      return unless guess_move

      guess_move.player    = guess_move.guess_player
      guess_move.played_at = Time.now
      guess_move.save!

      change_turn
      #self.formatted_moves += CoolGames::Sgf::NodeRenderer.new(:with_name => true).render(guess_move)
      self.moves += 1
      self.save!

      process_guess_moves
    end

    def send_resign_message from, to, loser_color
      #color_str = loser_color == Game::BLACK ? I18n.t('games_widget.black_player') : I18n.t('games_widget.white_player')

      #subject = ""
      #body = I18n.t('games.resign_body').sub('PLAYER_COLOR', color_str).sub('PLAYER', from.username).
      #            sub('GAME_URL', "#{ENV['BASE_URL']}/app/games/#{id}")

      #Discuz::PrivateMessage.send_message from, to, subject, body
    end
  end
end
