module GameInPlay
  OP_SUCCESS = 0
  OP_FAILURE = 1

  def current_user_is_player?
    return unless logged_in?

    [black_id, white_id].include?(current_player.id)
  end

  def play params
    code = OP_SUCCESS
    message = ''

    parent_move_id = params[:parent_move_id]
    x = params[:x].to_i
    y = params[:y].to_i

    if x < 0 or x > 18 or y < 0 or y > 18
      return OP_FAILURE, I18n.t('incorrect_move').sub('MOVE', "#{x}, #{y}")
    end

    if moves > 0 and parent_move_id.blank?
      return OP_FAILURE, I18n.t('parent_move_required')
    end

    my_turn = current_player.id == black_id and detail.whose_turn == Game::BLACK or
              current_player.id == white_id and detail.whose_turn == Game::WHITE

    parent_move = GameMove.find parent_move_id unless parent_move_id.blank?

    if parent_move # not first move
      unless move = parent_move.child_that_matches(x, y)
        move = GameMove.new
        move.game_detail_id = detail.id
        move.move_no = parent_move.move_no + 1
        move.color = parent_move.color == Game::BLACK ? Game::WHITE : Game::BLACK
        move.x = x
        move.y = y
        move.parent_id = parent_move.id
        if guess_move?(move.color, current_player.id)
          move.guess_player_id = current_player.id
        end
        move.save!
      end

      if detail.last_move_id == parent_move.id and my_turn
        self.moves += 1
        move.player_id = current_player.id
        detail.change_turn
        detail.last_move_id = move.id
      end
    else # first move
      move = GameMove.new
      move.game_detail_id = detail.id
      move.move_no = 1
      move.color = detail.whose_turn
      move.x = x
      move.y = y
      move.save!

      if my_turn
        self.moves = 1
        move.player_id = current_player.id
        detail.change_turn
        detail.first_move_id = move.id
        detail.last_move_id = move.id
      else
        move.guess_player_id = current_player.id
      end
    end

    move.save!
    detail.save!
    save!

    return code, message
  end

  def resign
    unless logged_in?
      raise OP_FAILURE, I18n.t('not_logged_in')
    end

    code = OP_SUCCESS
    message = ''

    if current_player.id == black_id
      black_resign
      self.winner = Game::WHITE
      self.result = "W+R"
    elsif current_player.id == white_id
      white_resign
      self.winner = Game::BLACK
      self.result = "B+R"
    else
      code = OP_FAILURE
      message = I18n.t('not_a_player_in_game').sub('GAME_ID', self.id).sub('USERNAME', current_player.name)
    end

    save!
    return code, message
  end

  def guess_move? move_color, player_id
    (move_color == Game::WHITE and player_id == black_id) or (move_color == Game::BLACK and player_id == white_id)
  end
end
