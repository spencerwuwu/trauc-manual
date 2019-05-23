Rails.application.routes.draw do
  namespace :admin do
      resources :ci_jobs
      resources :targets
      resources :test_results

      root to: "ci_jobs#index"
    end
  root to: 'page#index'

  get '/log/:id', :to => 'page#log', :as => 'log'
  get '/logerr/:id', :to => 'page#logerr', :as => 'logerr'
  get '/run/:id', :to => 'page#run', :as => 'run'
  get '/run_all', :to => 'page#run_all', :as => 'run_all'
end
