module GameStateMachine
  def self.included(klass)
    klass.instance_eval do
      include AASM

      aasm_column :state

      aasm_initial_state :new

      aasm_state :new
      aasm_state :black_to_play
      aasm_state :white_to_play
      aasm_state :finished

      aasm_event :start do
        transitions :to => :black_to_play, :from => [:new, :finished], :guard => :black_plays_first?
        transitions :to => :white_to_play, :from => [:new, :finished], :guard => :white_plays_first?
      end

      aasm_event :stone_played do
        transitions :to => :white_to_play, :from => [:black_to_play]
        transitions :to => :black_to_play, :from => [:white_to_play]
      end

      aasm_event :black_resign do
        transitions :to => :finished, :from => [:black_to_play, :white_to_play]
      end

      aasm_event :white_resign do
        transitions :to => :finished, :from => [:black_to_play, :white_to_play]
      end

      def finished?
        state == :finished
      end
    end
  end
end

Game.send :include, GameStateMachine
