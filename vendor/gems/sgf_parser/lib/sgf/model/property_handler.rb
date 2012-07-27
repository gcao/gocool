module SGF
  module Model
    class PropertyHandler
      def initialize method_mappings, misc_properties
        @method_mappings = method_mappings
        @misc_properties = misc_properties
      end
      
      def handle model, name, value
        if @method_mappings.include?(name)
          model.send(@method_mappings[name], value)
          
          true
        elsif @misc_properties.include?(name)
          if model.misc_properties[name]
            model.misc_properties[name] = [model.misc_properties[name], value].flatten
          else
            model.misc_properties[name] = value
          end

          true
        end
      end
    end
      
    # See http://www.red-bean.com/sgf/properties.html for property definitions
    GAME_PROPERTY_MAPPINGS = {
      'GM' => :game_type=, 'GN' => :name=, 'RU' => :rule=, 'SZ' => :board_size=, 'HA' => :handicap=, 'KM' => :komi=,
      'PW' => :white_player=, 'BR' => :black_rank=, 'PB' => :black_player=, 'WR' => :white_rank=,
      'BT' => :black_team=, 'WT' => :white_team=,
      'DT' => :played_on=, 'TM' => :time_rule=, 'OT' => :overtime_rule=,
      'SY' => :program=, 'RE' => :result=, 'AP' => :program=, 'PC' => :place=, 'EV' => :event=, 'RO' => :round=,
      'SO' => :source=, 'AN' => :annotation=, 'GC' => :comment=
    }

    GAME_MISC_PROPERTIES = %w(FF US CA ST)

    NODE_PROPERTY_MAPPINGS = {
      "B" => :sgf_play_black, "W" => :sgf_play_white, "C" => :comment=,
      "AB" => :sgf_setup_black, "AW" => :sgf_setup_white, "AE" => :sgf_setup_clear, "LB" => :sgf_label,
      "PL" => :whose_turn=
    }
  
    NODE_MARK_PROPERTIES = %w(AR CR DD LB LN MA SL SQ TR)
    NODE_TIME_PROPERTIES = %w(BL WL OB OW TB TW)
    NODE_MISC_PROPERTIES = %w(N GW GB DM UC TE BM DO IT MN) + NODE_MARK_PROPERTIES + NODE_TIME_PROPERTIES    
    
    GAME_PROPERTY_HANDLER = PropertyHandler.new(GAME_PROPERTY_MAPPINGS, GAME_MISC_PROPERTIES)
    NODE_PROPERTY_HANDLER = PropertyHandler.new(NODE_PROPERTY_MAPPINGS, NODE_MISC_PROPERTIES)
  end
end
