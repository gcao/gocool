class SgfRenderer
  def initialize game
    @game = game
  end

  def render
    sgf = "(;"
    sgf << render_property("GM", "1")
    sgf << render_property("FF", "4")
    sgf << render_property("CA", "UTF-8")
    sgf << render_property("SZ", @game.board_size || 19)
    sgf << render_property("PW", @game.white_player.name)
    sgf << render_property("WR", @game.white_player.rank)
    sgf << render_property("PB", @game.black_player.name)
    sgf << render_property("BR", @game.black_player.rank)
    sgf << render_property("DT", @game.created_at)
    sgf << render_property("PC", @game.place)
    sgf << render_property("RU", @game.rule_str)
    sgf << render_property("KM", @game.komi)
    sgf << render_property("HA", @game.handicap)
    sgf << render_property("RE", @game.result)
    sgf << @game.detail.nil_or.handicaps.to_s
    sgf << "N[#{@game.detail.nil_or.first_move_id}]"
    sgf << @game.detail.nil_or.moves_to_sgf.to_s
    sgf << ")"
  end

  def render_property prop_name, value
    "#{prop_name}[#{value}]"
  end
end
