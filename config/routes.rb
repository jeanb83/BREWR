Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get :dashboard, to: 'pages#dashboard' # As a user I can access my dashboard

  resources :groups do # Full CRUD
    resources :events, only: [:new, :create] # As a user I can create an event for a certain group via a form
    resources :messages, only: [:create] # As a user I can send messages within the group page
    resources :group_memberships, only: [:new, :create] # As a user I can send invites to join the group
  end

  resources :events, only: [:show, :edit, :update, :destroy] do # As a user I can do the rest of the crud inside the event page
    resources :votes, only: [:create] # As a user I can vote from within the event show page
  end

  resources :event_memberships, only: [:update] # As a user I can declare that I won't be coming for this event

  resources :group_memberships, only: [:destroy] # As a user I can leave a group
  
  resources :notifications, only: [:index] # As a user I can see all my notifications

end
