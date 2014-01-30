Rails.application.routes.draw do
  scope '/:foodcoop' do
    namespace :payments do
      scope '/adyen', :as => :adyen do

        post :notify, :controller => 'AdyenNotifications', :action => 'notify'

        resource :pin, :controller => 'AdyenPin', :only => [:new, :create] do
          get :index
          get :detect
          get :created
        end

        resource :hpp, :controller => 'AdyenHpp', :only => [:new, :create] do
          get :index, to: 'AdyenHpp#new'
          get :result
        end

      end
    end
  end
end
