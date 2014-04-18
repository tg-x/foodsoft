module SharedHelper

  # provide input_html for password autocompletion
  def autocomplete_flag_to_password_html(password_autocomplete)
    case password_autocomplete
      when true then {autocomplete: 'on'}
      when false then {autocomplete: 'off'}
      when 'store-only' then {autocomplete: 'off', data: {store: 'on'}}
      else {}
    end
  end

  # admin path to an area the user has access to (used in layout)
  def admin_path_sensible(user=@current_user)
    if user.role_orders?
      orders_path
    elsif user.role_suppliers? or user.role_article_meta?
      suppliers_path
    elsif user.role_admin?
      admin_root_path
    elsif user.role_finance?
      finance_order_index_path
    end
  end

end
