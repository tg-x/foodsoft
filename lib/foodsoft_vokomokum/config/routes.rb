Rails.application.routes.draw do
  scope '/:foodcoop' do
    get '/login/vokomokum', controller: 'vokomokum', action: 'login'
    namespace :finance do
      get :vokomokum_export_amounts, controller: 'vokomokum', action: 'export_amounts'
    end
  end
end
