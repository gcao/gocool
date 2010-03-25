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
                    :on_transition => :do_counting
        transitions :to => :white_accept_counting, :from => [:counting], :guard => :current_user_is_white?,
                    :on_transition => :do_counting

        transitions :to => :finished, :from => [:black_accept_counting], :guard => :current_user_is_white?
        transitions :to => :finished, :from => [:white_accept_counting], :guard => :current_user_is_black?
      end

      aasm_event :reject_counting do
        transitions :to => :counting, :from => [:black_accept_counting, :white_accept_counting],
                    :on_transition => lambda {|game|
                      game.delete_counting
                      game.create_counting
                    }
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
          black_total, white_total = detail.last_move.board.count(detail.whose_turn)
          Rails.logger.info "#{id} result:   #{black_total} : #{white_total}"
          if handicap.to_i == 0
            black_won = black_total - 180.5 - 3.75
          else
            # TODO
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
          self.result = nil
          detail.last_move_id = last_move.parent_id
          detail.save!
          last_move.delete
        end
      end
    end
  end
end

Game.send :include, GameStateMachine
