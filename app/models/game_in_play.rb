module GameInPlay
  OP_SUCCESS = 0
  OP_FAILURE = 1

  def current_user_is_player?
#    raise current_user.inspect
    return unless logged_in?

    [black_id, white_id].include?(current_player.id)
  end

  def play params
    code = OP_SUCCESS
    message = ''

    move = params[:move].to_i
    x = params[:x].to_i
    y = params[:y].to_i

    if moves.to_i != move - 1
      return OP_FAILURE, I18n.t('incorrect_move_number').sub('MOVE_NUMBER', move)
    end

    if x < 0 or x > 18 or y < 0 or y > 18
      return OP_FAILURE, I18n.t('incorrect_move').sub('MOVE', "#{x}, #{y}")
    end

    self.moves = move
    self.save!
    detail.add_move x, y
    detail.save!

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
end
