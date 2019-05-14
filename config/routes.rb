Rails.application.routes.draw do
  root to: 'page#index'

  get '/log/:id', :to => 'page#log', :as => 'log'
  get '/logerr/:id', :to => 'page#logerr', :as => 'logerr'
  get '/run/:id', :to => 'page#run', :as => 'run'
end
