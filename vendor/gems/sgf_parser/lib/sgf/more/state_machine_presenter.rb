# This class is created for illustrative purpose only. It should not be used as 
# the base class for state machine visualizer

module SGF
  module More
    class StateMachinePresenter
      def nodes
        nodes_hash.values
      end

      def edges
        @edges ||= []
      end

      def process state_machine
        nodes_hash[state_machine.start_state.to_s] = create_node(state_machine.start_state.to_s)
        state_machine.transitions.each do |from_state, transitions|
          transitions.each do |transition|
            from_node = nodes_hash[from_state.to_s] ||= create_node(from_state.to_s)
            to_state = transition.after_state || from_state
            to_node = nodes_hash[to_state.to_s] ||= create_node(to_state.to_s)
            transition_desc = transition.description || transition.event_pattern.inspect
            edges << create_edge(from_node, to_node, transition_desc)
          end
        end
      end

      private

      def nodes_hash
        @nodes ||= {}
      end

      def create_node name
        name
      end

      def create_edge from_node, to_node, description
        [from_node, to_node, description]
      end
    end
  end
end