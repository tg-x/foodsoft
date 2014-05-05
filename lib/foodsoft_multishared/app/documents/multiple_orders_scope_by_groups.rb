# encoding: utf-8
class MultipleOrdersScopeByGroups < OrderPdf

  def filename
    I18n.t('documents.multiple_orders_by_groups.filename', count: @order.count) + '.pdf'
  end

  def title
    I18n.t('documents.multiple_orders_by_groups.title', count: @order.count)
  end

  def body
    # Start rendering
    @scopes ||= Ordergroup.joins(:orders).where(orders: {id: @order}).order(:scope).pluck('DISTINCT(groups.scope) AS scope')
    @scopes.each do |scope|

      total = 0
      rows = []
      dimrows = []
      group_order_articles = GroupOrderArticle.ordered.joins(:group_order => [:order, :ordergroup]).where(:groups => {:scope => scope}).where(:orders => {id: @order}).includes(:order_article => :article_price).reorder('orders.id')
      has_tolerance = group_order_articles.where('article_prices.unit_quantity > 1').any?

      group_order_articles.each do |goa|
        price = goa.order_article.price.fc_price
        sub_total = price * goa.result
        total += sub_total
        rows <<  [goa.order_article.article.name,
                  goa.order_article.article.unit,
                  goa.group_order.order.name.truncate(10, omission: ''),
                  goa.tolerance > 0 ? "#{goa.quantity} + #{goa.tolerance}" : goa.quantity,
                  goa.result,
                  number_to_currency(price),
                  number_to_currency(sub_total),
                  (goa.order_article.price.unit_quantity if has_tolerance)]
        dimrows << rows.length if goa.result == 0
      end
      next if rows.length == 0

      # total
      go_totals = GroupOrder.ordered.joins(:ordergroup).where(:groups => {:scope => scope}).where(order_id: @order).select('SUM(net_price) AS net_price, SUM(deposit) AS deposit, SUM(gross_price) AS gross_price, SUM(tax0) AS tax0, SUM(tax1) AS tax1, SUM(tax2) AS tax2, SUM(tax3) AS tax3').first
      rows << [{content: I18n.t('documents.order_by_groups.sum'), colspan: 6}, number_to_currency(total), nil]
      # price details
      price_details = []
      price_details << "#{Article.human_attribute_name :price} #{number_to_currency go_totals.net_price}"
      price_details << "#{Article.human_attribute_name :deposit} #{number_to_currency go_totals.deposit}" if go_totals.deposit > 0
      for i in 0..3 do
        next unless (tax_price = go_totals.send "tax#{i}") > 0
        price_details << "#{Article.human_attribute_name :tax} #{FoodsoftConfig[:taxes][i]}% #{number_to_currency tax_price}"
      end
      price_details << "#{Article.human_attribute_name :fc_share_short} #{number_to_currency (total - go_totals.gross_price)}"
      rows << [{content: ('  ' + price_details.join('; ') if total > 0), colspan: 8}]

      # table header
      rows.unshift I18n.t('documents.order_by_groups.rows').dup
      if has_tolerance
        rows.first[6] = {image: "#{Rails.root}/app/assets/images/package-bg.png", scale: 0.6, position: :center}
      else
        rows.first[6] = nil
      end
      rows.first.insert(2, Article.human_attribute_name(:supplier))

      text scope, size: fontsize(9), style: :bold
      table rows, width: 500, cell_style: {size: fontsize(8), overflow: :shrink_to_fit} do |table|
        # borders
        table.cells.borders = [:bottom]
        table.cells.border_width = 0.02
        table.cells.border_color = 'dddddd'
        table.rows(0).border_width = 1
        table.rows(0).border_color = '666666'
        table.row(rows.length-3).border_width = 1
        table.row(rows.length-3).border_color = '666666'
        table.row(rows.length-2).borders = []
        table.row(rows.length-1).borders = []

        # bottom row with price details
        table.row(rows.length-1).text_color = '999999'
        table.row(rows.length-1).size = fontsize(7)
        table.row(rows.length-1).padding = [0, 5, 0, 5]
        table.row(rows.length-1).height = 0 if total == 0

        table.column(0).width = 150
        table.column(2).width = 62
        table.column(4).font_style = :bold
        table.columns(3..6).align = :center
        table.column(5).align = :right
        table.column(6).align = :right
        table.column(6).font_style = :bold
        table.column(7).align = :center
        # dim rows not relevant for members
        table.column(3).text_color = '999999'
        table.column(7).text_color = '999999'
        # hide unit_quantity if there's no tolerance anyway
        table.column(7).width = has_tolerance ? 20 : 0

        # dim rows which were ordered but not received
        dimrows.each { |ri| table.row(ri).text_color = '999999' }
      end

      down_or_page 15
    end

  end
end
