module OrdersHelper
  def shipping_method_display(method)
    "#{method.service_name} - #{number_to_currency(method.cost)}"
  end

  def calculate_weight()
  end
end
