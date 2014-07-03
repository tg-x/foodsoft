module FoodsoftVokomokum
  module BalancingController

    def self.included(base) # :nodoc:
      base.class_eval do
        alias_method :orig_confirm, :confirm

        def confirm
          close_direct
        end

      end
    end

  end
end

ActiveSupport.on_load(:after_initialize) do
  Finance::BalancingController.send :include, FoodsoftVokomokum::BalancingController
end
