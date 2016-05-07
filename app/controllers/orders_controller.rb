class OrdersController < ApplicationController

  def show
    @orders = Order.find(current_order.id).orderitems
  end


  def show_seller_orders
  	@user = User.find(params[:id])
  	@orders = @user.orders
  end

  def edit
    @order  = Order.find(params[:id])
    @quantity_numbers = [1,2,3,4,5,6,7,8,9,10]
    @orderitems = Order.find(current_order.id).orderitems
  end

  def update
    # binding.pry
    @order = current_order
    # @order.update(order_update_params[:order])
    @order.update(order_update_params[:order])
    if @order.status == "Completed"
      flash.now[:alert] = 'Sale could not be deleted.'
      redirect_to order_confirmation_path(@order.id)
    else
      render :checkout
    end
  end

  def seller_items
  end

  def checkout
    @order = current_order
  end


  private

  def orderitem_edit_params
    params.permit(orderitem: [:quantity])
  end

  def order_update_params
    params.permit(order: [:name_on_credit_card, :city, :state, :billing_zip,
      :email, :status, :stree_address, :credit_card_cvv, :credit_card_number, :credit_card_exp_date])
  end



end
