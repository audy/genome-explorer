Rails.application.routes.draw do

  resources :delayed_jobs do
  end

  resources :genomes do
    resources :scaffolds do
      resources :features
    end
    resources :features
  end

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end
