class Admin::GamesController < Admin::BaseController
  active_scaffold :game do |config|
    config.columns = [:id, :name, :gaming_platform, :black_id, :black_name, :black_rank,
                      :white_id, :white_name, :white_rank, :result, :winner, :moves,
                      :handicap, :komi_raw, :rule_raw, :played_at_raw, :place]
    config.update.columns.remove :id
  end
end
