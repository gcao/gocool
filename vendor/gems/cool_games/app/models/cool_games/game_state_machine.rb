module CoolGames
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
        aasm_state :counting_preparation
        aasm_state :counting
        aasm_state :black_accept_counting
        aasm_state :white_accept_counting
        aasm_state :finished

        aasm_event :start, :before => :before_start do
          transitions :to => :playing, :from => [:new]
        end

        aasm_event :request_counting, :before => :before_request_counting do
          transitions :to => :counting_preparation, :from => [:black_request_counting], :guard => :current_user_is_white?,
                      :on_transition => :create_counting
          transitions :to => :counting_preparation, :from => [:white_request_counting], :guard => :current_user_is_black?,
                      :on_transition => :create_counting

          transitions :to => :black_request_counting, :from => [:playing, :black_request_counting],
                      :guard => :current_user_is_black?, :on_transition => :undo_guess_moves
          transitions :to => :white_request_counting, :from => [:playing, :white_request_counting],
                      :guard => :current_user_is_white?, :on_transition => :undo_guess_moves
        end

        aasm_event :reject_counting_request, :before => :before_reject_counting_request do
          transitions :to => :playing, :from => [:black_request_counting, :white_request_counting]
        end

        aasm_event :do_counting, :before => :before_do_counting do
          transitions :to => :counting, :from => [:counting_preparation, :counting], :guard => :current_user_is_player?,
                      :on_transition => :count
        end

        aasm_event :accept_counting, :before => :before_accept_counting do
          transitions :to => :black_accept_counting, :from => [:counting], :guard => :current_user_is_black?
          transitions :to => :white_accept_counting, :from => [:counting], :guard => :current_user_is_white?

          transitions :to => :finished, :from => [:black_accept_counting], :guard => :current_user_is_white?
          transitions :to => :finished, :from => [:white_accept_counting], :guard => :current_user_is_black?
        end

        aasm_event :reject_counting, :before => :before_reject_counting do
          transitions :to => :counting_preparation, :from => [:counting, :black_accept_counting, :white_accept_counting],
                      :on_transition => :recreate_counting
        end

        aasm_event :resume, :before => :before_resume do
          transitions :to => :playing,
                      :from => [:black_request_counting, :white_request_counting,
                                :counting_preparation, :counting,
                                :black_accept_counting, :white_accept_counting],
                      :on_transition => :delete_counting
        end

        def finished?
          state == :finished
        end

        def count
          return unless result.blank?

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
            self.winner = Game::BLACK
          else
            self.result = I18n.t('games.white_won')
            self.winner = Game::WHITE
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
            self.winner = nil
            detail.last_move_id = last_move.parent_id
            detail.save!
            last_move.delete
          end
        end

        def recreate_counting
          delete_counting
          create_counting
        end

        def before_start
          message = I18n.t('games.messages.start_game') if state == 'new'

          Message.create!(:receiver_id => id, :content => message.sub('PLAYER', current_player_str)) if message
        end

        def before_request_counting
          message = case state
            when 'playing'
                I18n.t('games.messages.request_counting')
            when 'black_request_counting'
              if current_user_is_white?
                I18n.t('games.messages.accept_counting')
              end
            when 'white_request_counting'
              if current_user_is_black?
                I18n.t('games.messages.accept_counting')
              end
          end

          Message.create!(:receiver_id => id, :content => message.sub('PLAYER', current_player_str)) if message
        end

        def before_reject_counting_request
          message = case state
            when 'black_request_counting'
              if current_user_is_white?
                I18n.t('games.messages.reject_counting_request')
              end
            when 'white_request_counting'
              if current_user_is_black?
                I18n.t('games.messages.reject_counting_request')
              end
          end

          Message.create!(:receiver_id => id, :content => message.sub('PLAYER', current_player_str)) if message
        end

        def before_do_counting
          message = case state
            when 'black_request_counting'
              if current_user_is_white?
                I18n.t('games.messages.do_counting')
              end
            when 'white_request_counting'
              if current_user_is_black?
                I18n.t('games.messages.do_counting')
              end
          end

          Message.create!(:receiver_id => id, :content => message.sub('PLAYER', current_player_str)) if message
        end

        def before_accept_counting
          message = case state
            when 'counting'
                I18n.t('games.messages.accept_counting')
            when 'black_accept_counting'
              if current_user_is_white?
                I18n.t('games.messages.finish_counting')
              end
            when 'white_accept_counting'
              if current_user_is_black?
                I18n.t('games.messages.finish_counting')
              end
          end

          Message.create!(:receiver_id => id, :content => message.sub('PLAYER', current_player_str)) if message
        end

        def before_reject_counting
          message = case state
            when 'black_accept_counting'
              if current_user_is_white?
                I18n.t('games.messages.reject_counting')
              end
            when 'white_accept_counting'
              if current_user_is_black?
                I18n.t('games.messages.reject_counting')
              end
          end

          Message.create!(:receiver_id => id, :content => message.sub('PLAYER', current_player_str)) if message
        end

        def before_resume
          message = case state
            when 'new', 'playing', 'finished'
            else
              if current_user_is_player?
                I18n.t('games.messages.resume')
              end
          end

          Message.create!(:receiver_id => id, :content => message.sub('PLAYER', current_player_str)) if message
        end

        # after %w(before_start before_request_counting before_reject_counting_request
        #          before_do_counting before_accept_counting before_reject_counting before_resume) do |result|
        #   Message.create!(:receiver_id => id, :content => result.sub('PLAYER', current_player_str)) if result
        # end
      end
    end
  end

  Game.send :include, GameStateMachine
end
