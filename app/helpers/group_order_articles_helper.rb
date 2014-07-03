module GroupOrderArticlesHelper

  # @param goa [GroupOrderArticle]
  # @option options [Number] :multiplier
  # @option options [Boolean] :edit pass +false+ to only show the field (no input box)
  # @return [String] Edit field for a {GroupOrderArticle} result
  def group_order_article_edit_result(goa, options={})
    result = goa.result * (options[:multiplier] || 1)
    unless goa.group_order.order.finished? and current_user.role_finance? and options[:edit] != false
      result
    else
      simple_form_for goa, remote: true, html: {'data-submit-onchange' => 'changed', class: 'delta-input'} do |f|
        raw (if options[:multiplier] then f.hidden_field(:multiplier, value: 1.0/options[:multiplier]) else '' end) +
            f.input_field(:result, as: :delta, class: 'input-nano', data: {min: 0}, id: "r_#{goa.id}", value: result)
      end
    end
  end

end
