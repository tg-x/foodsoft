require 'foodsoft_orderdoc/engine'
require 'foodsoft_orderdoc/export_helper'
require 'foodsoft_orderdoc/add_to_supplier_mail'
require 'mimemagic'
require 'deface'

module FoodsoftOrderdoc
  def self.enabled?
    FoodsoftConfig[:use_orderdoc]
  end

  def self.supplier_has_orderdoc?(supplier)
    supplier and supplier.shared_supplier.present? and supplier.shared_supplier.shared_articles.first.try(:srcdata).present?
  end

  def self.orderdoc(order)
    FoodsoftOrderdoc::ExportHelper.export(article_data(order), search_path(order))
  end

  def self.valid?(order)
    begin
      FoodsoftOrderdoc::ExportHelper.check_export?(article_data(order), search_path(order))
      return true
    rescue FoodsoftOrderdoc::ExportHelper::OrderdocException
      return false
    end
  end

  private

  def self.article_data(order)
    article_data = order.order_articles.ordered.includes(:article).map do |oa|
      shared_article = oa.article.shared_article
      units_to_order = oa.units_to_order
      unit_quantity = oa.price.unit_quantity
      # convert units back if needed
      if shared_article and shared_article.unit_quantity != oa.article.unit_quantity
        unit_quantity = shared_article.unit_quantity
        fc_unit = (::Unit.new(oa.article.unit) rescue nil)
        supplier_unit = (::Unit.new(shared_article.unit) rescue nil)
        if fc_unit and supplier_unit and fc_unit =~ supplier_unit
          conversion_factor = (fc_unit.convert_to(supplier_unit.units) / supplier_unit).scalar
          units_to_order = (units_to_order*oa.article.unit_quantity * conversion_factor / shared_article.unit_quantity).to_f.round(2)
        else
          # skip articles where unit can't be converted TODO proper warning
          units_to_order = "(units incompatible: #{oa.article.unit} vs #{shared_article.unit})"
        end
      end
      # return relevant data
      {
        order_number: oa.article.order_number,
        result: units_to_order,
        unit_quantity: unit_quantity,
        srcdata: (shared_article.srcdata if shared_article)
      }
    end
  end

  def self.search_path(order)
    search_path = FoodsoftConfig[:shared_supplier_assets_path]
    search_path = File.join(search_path, 'mail_attachments', order.supplier.shared_supplier.id.to_s) if search_path
    [search_path].compact
  end
end
