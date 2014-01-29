Rails.application.routes.draw do
  scope '/:foodcoop' do
    namespace :current_orders do
      resources :ordergroups, :only => [:index, :show] do
        collection do
          get :show_on_group_order_article_create
          get :show_on_group_order_article_update
        end
      end

      resource :orders, :only => [:show]
    end
  end
end
