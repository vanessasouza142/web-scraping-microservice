Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'scraping', to: 'scraping#create'
    end
  end
end

