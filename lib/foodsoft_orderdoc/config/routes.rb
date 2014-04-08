Rails.application.routes.draw do
  scope '/:foodcoop' do
    get '/orders/:id/order_doc', controller: 'orderdoc', action: 'order_doc'
  end
end
