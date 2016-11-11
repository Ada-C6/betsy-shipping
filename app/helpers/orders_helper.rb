module OrdersHelper
  def shipping_method_display(option)
    "#{option["service_name"]} - #{number_to_currency(option["total_price"].to_f / 100)}"
  end
end
