class GamesController < ApplicationController
  active_scaffold :game do |config|
    config.columns = [:name, :event, :place, :source, :played_at,
      :rule, :komi, :result, :winner, :moves,
      :black_id, :black_name, :black_rank,
      :white_id, :white_name, :white_rank, :description]
    config.list.columns = [:event, :name, :played_at,
      :black_name, :black_rank, :white_name, :white_rank, :rule, :komi, :result, :winner, :moves]
    config.nested.add_link "Content", [:game_data]
  end
end
