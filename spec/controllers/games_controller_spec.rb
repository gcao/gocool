require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe GamesController do
  
  it "#upload_games saves an uploaded game" do
    post :upload, :file => fixture_file_upload('/sgf/simple.sgf', 'text/plain')
    
    response.should be_success
  end
end