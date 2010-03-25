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
        transitions :to => :counting, :from => [:black_request_counting], :guard => :current_user_is_white?,
                    :on_transition => :create_counting
        transitions :to => :counting, :from => [:white_request_counting], :guard => :current_user_is_black?,
                    :on_transition => :create_counting

        transitions :to => :black_request_counting, :from => [:playing, :black_request_counting],
                    :guard => :current_user_is_black?, :on_transition => :undo_guess_moves
        transitions :to => :white_request_counting, :from => [:playing, :white_request_counting],
                    :guard => :current_user_is_white?, :on_transition => :undo_guess_moves
      end

      aasm_event :reject_counting_request do
        transitions :to => :playing, :from => [:black_request_counting, :white_request_counting]
      end

      aasm_event :accept_counting do
        transitions :to => :black_accept_counting, :from => [:counting], :guard => :current_user_is_black?,
                    :on_transition => :count
        transitions :to => :white_accept_counting, :from => [:counting], :guard => :current_user_is_white?,
                    :on_transition => :count

        transitions :to => :finish, :from => [:black_accept_counting], :guard => :current_user_is_white?
        transitions :to => :finish, :from => [:white_accept_counting], :guard => :current_user_is_black?
      end

      aasm_event :reject_counting do
        transitions :to => :counting, :from => [:black_accept_counting, :white_accept_counting]
      end

      aasm_event :resume do
        transitions :to => :playing, :on_transition => :delete_counting,
                    :from => [:black_request_counting, :white_request_counting,
                              :counting, :black_accept_counting, :white_accept_counting]
      end

      def finished?
        state == :finished
      end

      def count
        if result.blank?
          self.result = "W+1/4(pending)"
        end
      end

      def create_counting
        undo_guess_moves
        if detail.last_move.move_on_board?
          move = GameMove.create!(:game_detail_id => detail.id, :move_no => detail.last_move.move_no,
                                  :color => Game::NONE, :x => -1, :y => -1, :played_at => Time.now,
                                  :parent_id => detail.last_move_id)
          detail.last_move_id = move.id
          detail.save!
        end
      end

      def delete_counting
        last_move = detail.last_move
        unless last_move.parent_id and last_move.move_on_board?
          detail.last_move_id = last_move.parent_id
          detail.save!
          last_move.delete
        end
      end
    end
  end
end

Game.send :include, GameStateMachine
