require 'csv'

class FinancialTransactionsCsv
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  def initialize(financial_transactions, options={})
    @financial_transactions = financial_transactions
  end

  def to_csv
    CSV.generate do |csv|
      # header
      csv << [
               FinancialTransaction.human_attribute_name(:created_on),
               FinancialTransaction.human_attribute_name(:ordergroup),
               FinancialTransaction.human_attribute_name(:ordergroup),
               FinancialTransaction.human_attribute_name(:user),
               FinancialTransaction.human_attribute_name(:note),
               FinancialTransaction.human_attribute_name(:amount)
             ]
      # data
      @financial_transactions.includes(:user, :ordergroup).each do |t|
        csv << [
                 t.created_on,
                 t.ordergroup_id,
                 t.ordergroup.name,
                 show_user(t.user),
                 t.note,
                 number_to_currency(t.amount)
               ]
      end
    end
  end

  # Helper method to test pdf via rails console: OrderCsv.new(order).save_tmp
  def save_tmp
    File.open("#{Rails.root}/tmp/#{self.class.to_s.underscore}.csv", 'w') {|f| f.write(to_csv.force_encoding("UTF-8")) }
  end
end
