# handles membership fee processing

module FoodsoftSignup

  module DebitMembership
    def self.included(base) # :nodoc:
      base.class_eval do

        # debit membership on ordergroup creation
        after_create :debit_membership!, :if => proc { FoodsoftSignup.enabled? :membership_fee }
        def debit_membership!
          Rails.logger.debug "Debit membership fee of #{FoodsoftConfig[:membership_fee]} for ordergroup ##{id}"
          amount = (-FoodsoftConfig[:membership_fee].to_f).to_s
          amount.gsub!('\.', I18n.t('separator', :scope => 'number.format')) # workaround localize_input problem
          note = I18n.t('foodsoft_signup.membership_fee.transaction_note')
          # skip notification on negative amount here
          transaction do
            t = FinancialTransaction.new(:ordergroup => self, :amount => amount, :note => note, :user_id => 0)
            t.save!
            self.account_balance = financial_transactions.sum('amount')
            save!
          end
        end

        # approve ordergroup when membership fee is payed
        alias_method :foodsoft_signup_orig_add_financial_transaction!, :add_financial_transaction!
        def add_financial_transaction!(amount, note, user)
          result = self.foodsoft_signup_orig_add_financial_transaction!(amount, note, user)
          if FoodsoftSignup.enabled? :approval and FoodsoftSignup.enabled? :membership_fee
            if not self.approved? and (diff = amount - FoodsoftConfig[:membership_fee].to_f) > -1e-4
              transaction do
                Rails.logger.debug "Approving ordergroup ##{id} after membership fee payment"
                self.approved = true
                save!
                # when this is the first transaction after the membership fee, and it's more than the
                # fee, we assume it's a donation - debit that
                # TODO config option - perhaps some groups would like to have a prepaid credit right away
                if financial_transactions.count <= 2 and diff > 1e-4
                  note = I18n.t('foodsoft_signup.membership_fee.transaction_note_donation')
                  t = FinancialTransaction.new(:ordergroup => self, :amount => -diff, :note => note, :user_id => 0)
                  t.save!
                  self.account_balance = financial_transactions.sum('amount')
                  save!
                end
              end
            end
          end
          result
        end

      end
    end
  end

end

ActiveSupport.on_load(:after_initialize) do
  Ordergroup.send :include, FoodsoftSignup::DebitMembership
end
