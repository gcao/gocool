module CoolGames
  module ParseErrorHelper
    def convert_parse_error_to_html e
      if e.is_a? SGF::ParseError
        good = ""
        if e.position > 0
          if e.position <= 1000
            start_position = 0
            good << ""
          else
            start_position = e.position - 1000
            good << "..."
          end
          good << e.input[start_position..e.position - 1]
        end
        bad = e.input[e.position,1]
        rest = e.input[e.position + 1, 20]
        s = ""
        s << "<span class='sgf_good'>#{good}</span>" unless good.blank?
        s << "<span class='sgf_bad'>#{bad}</span>"
        s << "<span class='sgf_rest'>#{rest}</span>" unless rest.blank?
      else
        e.to_s
      end
    end
  end
end
