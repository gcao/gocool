class GamesCell < Cell::Rails
  include GamesHelper
  
  def list
    @games = @opts[:games]
    
    render
  end
end
