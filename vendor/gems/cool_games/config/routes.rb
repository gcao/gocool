CoolGames::Engine.routes.draw do
  resources :games do
    member do
      get *%w(play resign undo_guess_moves next do_this mark_dead messages)
      post *%w(send_message)
    end

    collection do
      get *%w(waiting)
    end
  end

  resources :uploads
  match "upload_search" => "upload_search#index"

  resources :players do
    collection do
      get *%w(search suggest suggest_opponents)
    end
  end

  resources :pairs

  resources :invitations do
    member do
      get *%w(accept reject cancel)
    end
  end
end
