
ThinSearch::Application.routes.draw do
  mount Resque::Server.new, :at => "/resque"
  scope '/search' do
    namespace :api do
      namespace :v1 do
        resource :search
      end
    end
  end
end
