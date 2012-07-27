module SGF
  module More
    class StmDotConverter
      
      STATE_PROPERTIES = {
        SGF::SGFStateMachine::STATE_BEGIN => {
          :shape => 'circle', :fillcolor => '#44ff44', :style => 'filled'
        },
        SGF::SGFStateMachine::STATE_GAME_BEGIN => {
        },
        SGF::SGFStateMachine::STATE_VAR_BEGIN => {
        },
        SGF::SGFStateMachine::STATE_VAR_END => {
        },
        SGF::SGFStateMachine::STATE_GAME_END => {
          :label => 'end', :shape => 'doublecircle', :fillcolor => '#44ff44', :style => 'filled'
        },
        SGF::SGFStateMachine::STATE_INVALID => {
          :label => 'error', :shape => 'octagon', :fillcolor => '#ff4444', :style => 'filled'
        },
      }
      
      EDGE_PROPERTIES = {
        "begin:game_begin" => {
          :weight => 100
        },
        "game_begin:game_node" => {
          :weight => 100
        },
        "game_node:prop_name_begin" => {
          :weight => 100
        },
        "prop_name_begin:prop_name" => {
          :weight => 100
        },
        "prop_name:value_begin" => {
          :weight => 100
        },
        "value_begin:value" => {
          :weight => 100
        },
        "value:value_end" => {
          :weight => 100
        },
        "value_end:var_end" => {
          :weight => 100
        },
        "var_end:game_node" => {
          :weight => 100
        },
        "var_end:game_end" => {
          :weight => 100
        },
      }
      
      def process stm
        s = "digraph SGF_STATE_MACHINE{"
        s << graph_attributes
        s << create_node_for_state(stm.start_state)

        stm.transitions.each do |start_state, transitions|
          transitions.each do |transition|
            s << create_edge_for_transition(start_state, transition)
          end
        end

        s << "}\n"
        s
      end
      
      private
      
      def graph_attributes
        '
        {rank = same; begin;}
        {rank = same; game_begin;}
        {rank = same; var_begin game_node;}
        {rank = same; prop_name_begin;}
        {rank = same; prop_name;}
        {rank = same; value_begin;}
        {rank = same; value value_escape;}
        {rank = same; value_end;}
        {rank = same; var_end;}
        {rank = same; game_end invalid;}
        '
      end
      
      def create_node_for_state state
        @processed_states ||= []
        return "" if @processed_states.include?(state)
        
        @processed_states << state

        s = state.to_s + "["
        properties = STATE_PROPERTIES[state]
        if properties
          prop_arr = []
          properties.each do |key, value|
            prop_arr << "#{key} = #{value.inspect}"
          end
          s << prop_arr.join(',')
        end
        s << "];\n"
      end
      
      def create_edge_for_transition start_state, transition
        s = ""
        s << create_node_for_state(start_state)

        end_state = transition.after_state || start_state
        s << create_node_for_state(end_state)

        s << start_state.to_s << " -> " << end_state.to_s << "["
        if end_state == SGFStateMachine::STATE_INVALID
          s << "color=\"#FFBBBB\", weight=-100"
        else
          s << "label=\"" << (transition.description || pattern_to_label(transition.event_pattern)) << "\"" 
        end
        
        edge_properties = EDGE_PROPERTIES["#{start_state}:#{end_state}"]
        if edge_properties
          edge_properties.each do |key, value|
            s << ", #{key}=#{value.inspect}"
          end
        end
        
        s << "];\n"
      end
      
      def pattern_to_label pattern
        if pattern.nil?
          "EOS"
        else
          pattern.inspect[1..-2].gsub("\\", "\\\\")
        end
      end
    end
  end
end