Rails.application.routes.draw do
  scope '/:foodcoop' do
    namespace :payments do
      resource :mollie, controller: 'mollie_ideal', only: [:new, :create] do
        get :check
        get :result
        get :cancel
      end
    end
  end
end
