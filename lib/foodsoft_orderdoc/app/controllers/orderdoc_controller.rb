class OrderdocController < ApplicationController

  before_filter :authenticate_orders
  before_filter -> { require_plugin_enabled FoodsoftOrderdoc }

  # Return document that can be sent to supplier for ordering.
  def order_doc
    @order = Order.find(params[:id])
    out = FoodsoftOrderdoc.orderdoc(@order)
    if out[:data]
      send_data out[:data], filename: out[:filename], type: out[:filetype]
    else
      redirect_to order_path(@order), alert: out[:error]
    end
  end

end
