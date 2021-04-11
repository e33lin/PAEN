Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  resources :surveys, except: [:index, :show, :edit, :new, :update, :destroy]
  resources :managers, except: [:index, :show, :edit, :update, :destroy]
  resources :teams, except: [:index, :show]
  resources :responses, except: [:index, :show, :edit, :new, :update, :destroy]
  resources :ticket_responses, except: [:index, :show, :edit, :new, :update, :destroy]
  resources :users, except: [:new, :index, :show, :edit, :update, :destroy]  
  resources :tickets, except: [:new, :show, :index, :edit, :update, :destroy]
    
  get '/signup', to: 'users#new'
  get '/login',  to: 'sessions#new'    
  post '/login',  to: 'sessions#create'    
  get '/logout', to: 'sessions#destroy' 
  
  get '/about', to: 'static_pages#about'
    
  get 'dashboard', to: 'users#dashboard', as: 'user_dashboard'
  get 'dashboard/teams/:id', to: 'users#team_list', as: 'user_team_list'    
  get 'dashboard/teams/:id/weekly_surveys/:from', to: 'users#weekly_surveys', as: 'weekly_surveys'
    
  get 'manager_dashboard', to: 'managers#dashboard', as: 'manager_dashboard'
  get 'team_health/:id/metrics', to: 'managers#team_health', as: 'team_health'
    
  get 'teams/:id/members', to: 'teams#edit_members', as: 'edit_members'
  post 'teams/:id/members/add', to: 'teams#add_member', as: 'confirm_add_member'
  post 'teams/:id/members/remove', to: 'teams#remove_member', as: 'confirm_remove_member'
  
  get 'teams/:id/tickets', to: 'managers#tickets', as: 'team_tickets'
  get 'team_health/:id/metrics/:date/details', to: 'managers#health_details', as: 'team_health_details'
    
    # route to get the team associated with the ticket
  get 'teams/:id/tickets/new', to: 'tickets#new', as: 'new_team_ticket'
  post 'teams/:id/tickets', to: 'tickets#create', as: 'create_team_ticket'
    
  #For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match "*path", to: "users#dashboard", via: :all
end
