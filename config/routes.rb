Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check
  mount ActionCable.server => '/cable'
  root 'home#index'
end
