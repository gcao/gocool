module GameStateMachine
  def self.included(klass)
    klass.class_eval do
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
                    :on_transition => :do_counting
        transitions :to => :white_accept_counting, :from => [:counting], :guard => :current_user_is_white?,
                    :on_transition => :do_counting

        transitions :to => :finished, :from => [:black_accept_counting], :guard => :current_user_is_white?
        transitions :to => :finished, :from => [:white_accept_counting], :guard => :current_user_is_black?
      end

      aasm_event :reject_counting do
        transitions :to => :counting, :from => [:black_accept_counting, :white_accept_counting],
                    :on_transition => :recreate_counting
      end

      aasm_event :resume do
        transitions :to => :playing, :on_transition => :delete_counting,
                    :from => [:black_request_counting, :white_request_counting,
                              :counting, :black_accept_counting, :white_accept_counting]
      end

      def finished?
        state == :finished
      end

      def do_counting
        if result.blank?
          board = detail.last_move.board
          detail.last_move.dead.each do |x, y|
            board[x][y] = 0
          end

          black_total, white_total = board.count(detail.whose_turn)
          Rails.logger.info "#{id} result:   #{black_total} : #{white_total}"

          black_won = black_total - 180.5
          if handicap.to_i == 0
            black_won -= 3.75
          elsif handicap.to_i > 1
            black_won -= handicap.to_i/2.0
          end

          if black_won > 0
            self.result = I18n.t('games.black_won')
          else
            self.result = I18n.t('games.white_won')
          end
          black_won = black_won.abs
          int_part = black_won.to_i
          float_part = black_won - int_part
          float_part_translated = case float_part
            when 0.25 then " 1/4"
            when 0.5  then " 1/2"
            when 0.75 then " 3/4"
          end
          self.result.sub!('POINTS_WON', "#{int_part}#{float_part_translated}")

          detail.last_move.serialized_board = board.dump
          detail.last_move.save!
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
        if last_move.parent_id and not last_move.move_on_board?
          self.result = nil
          detail.last_move_id = last_move.parent_id
          detail.save!
          last_move.delete
        end
      end

      def recreate_counting
        delete_counting
        create_counting
      end
    end
  end
end

Game.send :include, GameStateMachine
