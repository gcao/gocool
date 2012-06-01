module CoolGames
  module GameInPlay
    OP_SUCCESS    = 0
    OP_FAILURE    = 1
    OP_JAVASCRIPT = 2

    def current_user_is_player?
      logged_in? and [black_id, white_id].include?(current_user.player.id)
    end

    def current_user_is_black?
      logged_in? and current_user.player.id == black_id
    end

    def current_user_is_white?
      logged_in? and current_user.player.id == white_id
    end

    def play params
      code = OP_SUCCESS
      message = ''

      parent_move_id = params[:parent_move_id]
      x = params[:x].to_i
      y = params[:y].to_i

      if x < 0 or x > board_size - 1 or y < 0 or y > board_size - 1
        return OP_FAILURE, I18n.t('games.incorrect_move').sub('MOVE', "#{x}, #{y}")
      end

      if parent_move_id.blank?
        return OP_FAILURE, I18n.t('games.parent_move_required')
      end

      if parent_move_id.to_i < detail.last_move_id
        return OP_FAILURE, I18n.t('games.not_last_move_or_after')
      end

      parent_move = GameMove.find parent_move_id

      unless move = parent_move.child_that_matches(x, y)
        if guess_move?(parent_move.color, current_user.player.id)
          # This is a counter move, should replace previous counter move
          parent_move.children.each(&:destroy)
        end

        move = GameMove.new
        move.game_detail_id = detail.id
        move.move_no = parent_move.move_no + 1
        if move.move_no == 1
          move.color = start_side
        else
          move.color = parent_move.color == Game::BLACK ? Game::WHITE : Game::BLACK
        end
        move.x = x
        move.y = y
        move.parent_id = parent_move.id
        move.guess_player_id = current_user.player.id

        case move.process
          when GameMove::OCCUPIED then return OP_FAILURE, I18n.t('games.occupied')
          when GameMove::SUICIDE then return OP_FAILURE, I18n.t('games.suicide')
          when GameMove::BAD_KO then return OP_FAILURE, I18n.t('games.bad_ko')
        end

        move.save!
      end

      if detail.last_move_id == parent_move.id and my_turn?
        self.moves += 1
        move.player_id = current_user.player.id
        detail.last_move_time = Time.now
        detail.change_turn
        detail.last_move_id = move.id
        detail.formatted_moves += CoolGames::Sgf::NodeRenderer.new(:with_name => true).render(move)
      end

      move.played_at = Time.now
      move.save!
      detail.save!
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

      if current_user.player.id == black_id
        undo_guess_moves
        self.state = 'finished'
        self.winner = Game::WHITE
        self.result = "W+R"
        send_resign_message current_user.player.user, white_player.user, Game::BLACK
      elsif current_user.player.id == white_id
        undo_guess_moves
        self.state = 'finished'
        self.winner = Game::BLACK
        self.result = "B+R"
        send_resign_message current_user.player.user, black_player.user, Game::WHITE
      else
        code = OP_FAILURE
        message = I18n.t('games.not_a_player_in_game').sub('GAME_ID', self.id).sub('USERNAME', current_user.player.name)
      end

      save!
      return code, message
    end

    def undo_guess_moves
      return unless logged_in?

      GameMove.moves_after(detail.last_move).each do |move|
        move.delete if move.player_id.nil? and move.guess_player_id == current_user.player.id
      end

      undo_last_move
    end

    def undo_last_move
      move = detail.last_move
      return if move.player_id != current_user.player.id

      parent_move = move.parent
      detail.last_move_id = parent_move.id

      if parent_move
        detail.last_move_time = parent_move.created_at
      else
        detail.last_move_time = detail.created_at
      end
      detail.change_turn

      last_move_start = detail.formatted_moves.rindex(";") - 1
      detail.formatted_moves = detail.formatted_moves[0..last_move_start] if last_move_start >= 0

      detail.save!
      move.delete
    end

    def mark_dead x, y
      move = detail.last_move
      orig_dead = move.dead.nil? ? [] : move.dead.clone
      if group = move.board.get_dead_group_for_marking(x, y)
        move.dead = (orig_dead + group).uniq
        move.save!
      end
    end

    def my_color
      if current_user.player.id == black_id
        Game::BLACK
      elsif current_user.player.id == white_id
        Game::WHITE
      end
    end

    def my_turn?
      (current_user.player.id == black_id and detail.whose_turn == Game::BLACK) or
              (current_user.player.id == white_id and detail.whose_turn == Game::WHITE)
    end

    def guess_move? move_color, player_id
      (move_color == Game::WHITE and player_id == black_id) or
              (move_color == Game::BLACK and player_id == white_id)
    end

    private

    def process_guess_moves
      return unless logged_in?

      guess_move = detail.guess_moves.detect do |move|
        my_color and my_color != move.color and current_user.player.id != move.guess_player_id
      end

      return unless guess_move

      guess_move.player_id = guess_move.guess_player_id
      guess_move.played_at = Time.now
      guess_move.save!

      detail.last_move = guess_move
      detail.last_move_time = Time.now
      detail.change_turn
      detail.formatted_moves += CoolGames::Sgf::NodeRenderer.new(:with_name => true).render(guess_move)
      detail.save!

      self.moves += 1
      self.save!

      process_guess_moves
    end

    def send_resign_message from, to, loser_color
      color_str = loser_color == Game::BLACK ? I18n.t('games_widget.black_player') : I18n.t('games_widget.white_player')

      subject = ""
      body = I18n.t('games.resign_body').sub('PLAYER_COLOR', color_str).sub('PLAYER', from.username).
              sub('GAME_URL', "#{ENV['BASE_URL']}/app/games/#{id}")

      Discuz::PrivateMessage.send_message from, to, subject, body
    end
  end
end
