
module FoodsoftOrderdoc
  module AddToSupplierMail
    def self.included(base) # :nodoc:
      base.class_eval do

        alias_method :foodsoft_orderdoc_add_order_result_attachments, :add_order_result_attachments
        def add_order_result_attachments
          foodsoft_orderdoc_add_order_result_attachments
          if FoodsoftOrderdoc.enabled? and FoodsoftOrderdoc.supplier_has_orderdoc?(@order.supplier)
            Rails.logger.debug "Adding orderdoc to supplier mail for order #{@order.id}"
            orderdoc = FoodsoftOrderdoc.orderdoc(@order)
            if orderdoc[:data]
              attachments[orderdoc[:filename]] = orderdoc[:data]
            else
              Rails.logger.warn "Could not add orderdoc to supplier mail for order #{@order.id}: #{orderdoc[:error]}"
            end
          end
        end

      end
    end
  end
end

ActiveSupport.on_load(:after_initialize) do
  Mailer.send :include, FoodsoftOrderdoc::AddToSupplierMail
end
