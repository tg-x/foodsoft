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
    article_data = order.order_articles.ordered.includes(:article).map {|oa| {
      order_number: oa.article.order_number,
      result: oa.units_to_order,
      srcdata: (oa.article.shared_article.srcdata rescue nil)
    }}
  end

  def self.search_path(order)
    search_path = FoodsoftConfig[:shared_supplier_assets_path]
    search_path = File.join(search_path, 'mail_attachments', order.supplier.shared_supplier.id.to_s) if search_path
    [search_path].compact
  end
end
