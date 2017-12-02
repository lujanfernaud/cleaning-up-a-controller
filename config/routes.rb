CleanUpControllerApp::Application.routes.draw do
  resources :users do
    resources :expenses do
      resource :approval, only: :create
    end
  end
end
