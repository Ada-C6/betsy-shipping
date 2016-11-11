class Order < ActiveRecord::Base
  has_many :orderitems
  belongs_to :user

  # If must have both a shipping_name and a shipping_cost, or neither
  validates :shipping_name, presence: true, if: -> (order) { order.shipping_cost.present? }
  validates :shipping_cost, presence: true, if: -> (order) { order.shipping_name.present? }

  def total_price
    subtotal = orderitems.map { |item| item.total_price }.sum
    subtotal + (shipping_cost || 0)
  end

  def total_weight
    orderitems.map { |item| item.total_weight }.sum
  end

  # Update the order details with the provided attributes
  # then reduce the stock of any products in the order.
  #
  # This is done in a transaction so that we can rollback
  # if any product's stock cannot be reduced.
  # Returns true if everything completed successfully, false otherwise.
  def checkout(attributes)
    completed = false
    transaction do
      update!(attributes.merge(status: "Completed"))
      orderitems.each do |item|
        raise ActiveRecord::Rollback unless item.reduce_stock
      end
      completed = true
    end

    completed
  end

  # When we set the shipping method, we actually store
  # the name of the service and the cost
  def shipping_method=(method)
    raise ArgumentError.new("method cannot be nil") unless method.present?
    self.shipping_name = method.service_name
    self.shipping_cost = method.cost
    self.shipping_method_id = method.id
  end
end
