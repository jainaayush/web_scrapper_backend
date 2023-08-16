Rails.application.routes.draw do  
  namespace :api do
    namespace :v1 do
      resources :product, only: :index
      post "scrape" => "product#scrape"
    end
  end      
end