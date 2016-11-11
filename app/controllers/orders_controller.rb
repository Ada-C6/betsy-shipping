class OrdersController < ApplicationController
  before_action :require_login, only: [:show_seller_orders]
  before_action :truncate_cc_number, only: [:update]
  before_action :new_shipping_method, only: [:shipping_select, :shipping_set]

  attr_reader :shipping_methods

  def show
    @orders = Order.find(current_order.id).orderitems
  end

  def show_seller_orders
  	@user = User.find(current_user.id)
    @user_orders_hash = Orderitem.where(user: current_user).group_by(&:order_id)
    @revenue = @user.revenue
    @completed_revenue = @user.revenue_by_status("Completed")
    @pending_revenue = @user.revenue_by_status("Pending")
    @completed_count = @user.order_by_status("Completed")
    @pending_count = @user.order_by_status("Pending")
  end

  def order_deets
    @user_orders_hash = Orderitem.where(user: current_user).group_by(&:order_id)
    @order = Order.find(params[:order_id])
  end


  def edit
    @order  = Order.find(params[:id])
    @orderitems = Order.find(current_order.id).orderitems
  end

  def update
    if !current_order.checkout(order_update_params)
      redirect_to edit_order_path(current_order), notice:
        "Sorry, we could not complete your order."
    else
      redirect_to shipping_order_path
    end
  end

  def checkout
    @order = current_order
    if @order.orderitems.count == 0
      redirect_to edit_order_path(current_order.id), alert: "Please add items to your cart!"
    end
  end

  def shipping_select
  end

  def shipping_set
    selected_method = ShippingService.method_select(order_shipping_params[:shipping_method_id], @shipping_methods)
    if !current_order.update(shipping_method: selected_method)
      redirect_to shipping_order_path, notice:
        "Sorry something went wrong, please try again in a few moments."
    else
      redirect_to order_confirmation_path(current_order)
    end
  rescue ShippingService::ShippingMethodNotFound
    redirect_to shipping_order_path, notice:
      "Sorry something went wrong, please try again in a few moments."
  end

  def confirmation
    @order = current_order
    @orderitems = @order.orderitems
    session.delete :order_id
    order = Order.create
    order.update(status: "Pending")
    session[:order_id] = order.id
  end


  private

  def orderitem_edit_params
    params.permit(orderitem: [:quantity])
  end

  def order_update_params
    params.require(:order).permit([
      :name_on_credit_card, :credit_card_number,
      :credit_card_exp_date, :credit_card_cvv,
      :billing_zip, :street_address, :city, :state,
      :email])
  end

  def order_shipping_params
    params.permit(:shipping_method_id, :shipping_methods => [])
  end

  def truncate_cc_number
    if params[:order] && params[:order][:credit_card_number]
      card_num = params[:order][:credit_card_number]
      card_num.slice!(0..12) || (card_num = "")
    end
  end

  def new_shipping_method
    @carrier_name = params[:carrier_name]
    @order = current_order
    if @carrier_name
      @shipping_methods = ShippingService.get_method(@carrier_name, @order)
    else
      @shipping_methods = ShippingService.methods_for_order(current_order)
    end
  end

end
