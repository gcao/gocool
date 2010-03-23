module GameStateMachine
  def self.included(klass)
    klass.instance_eval do
      include AASM

      aasm_column :state

      aasm_initial_state :new

      aasm_state :new
      aasm_state :playing
      aasm_state :black_request_counting
      aasm_state :white_request_counting
      aasm_state :counting
      aasm_state :black_accept_counting
      aasm_state :white_accept_counting
      aasm_state :finished

      aasm_event :start do
        transitions :to => :playing, :from => [:new]
      end

      aasm_event :black_resign do
        transitions :to => :finished
      end

      aasm_event :white_resign do
        transitions :to => :finished
      end

      aasm_event :request_counting do
        transitions :to => :counting, :from => [:black_request_counting], :guard => :current_user_is_white?
        transitions :to => :counting, :from => [:white_request_counting], :guard => :current_user_is_black?

        transitions :to => :black_request_counting, :from => [:playing, :black_request_counting], :guard => :current_user_is_black?
        transitions :to => :white_request_counting, :from => [:playing, :white_request_counting], :guard => :current_user_is_white?
      end

      aasm_event :reject_counting_request do
        transitions :to => :playing, :from => [:black_request_counting, :white_request_counting]
      end

      aasm_event :accept_counting do
        transitions :to => :black_accept_counting, :from => [:counting], :guard => :current_user_is_black?
        transitions :to => :white_accept_counting, :from => [:counting], :guard => :current_user_is_white?

        transitions :to => :finish, :from => [:black_accept_counting], :guard => :current_user_is_white?
        transitions :to => :finish, :from => [:white_accept_counting], :guard => :current_user_is_black?
      end

      aasm_event :reject_counting do
        transitions :to => :counting, :from => [:black_accept_counting, :white_accept_counting]
      end

      aasm_event :resume do
        transitions :to => :playing, :from => [:black_request_counting, :white_request_counting,
                                               :counting, :black_accept_counting, :white_accept_counting]
      end

      def finished?
        state == :finished
      end
    end
  end
end

Game.send :include, GameStateMachine
