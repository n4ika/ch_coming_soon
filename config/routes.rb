Rails.application.routes.draw do
  root "pages#home"

  get "privacy", to: "pages#privacy"

  resources :waitlist_signups, only: [ :create ]
end
