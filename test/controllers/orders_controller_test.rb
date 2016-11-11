require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:completed)
    session[:order_id] = @order.id
  end

  class ShippingSelectTest < OrdersControllerTest
    setup do
      def send_request(params={})
        get :shipping_select, {
          id: @order.id
        }.merge(params)
      end
    end

    test "should respond success" do
      VCR.use_cassette("shipping_methods") do
        send_request

        assert_response :success
      end
    end

    test "should render appropriate view template" do
      VCR.use_cassette("shipping_methods") do
        send_request

        assert_template :shipping_select
      end
    end

    test "should ignore id parameter" do
      VCR.use_cassette("shipping_methods") do
        send_request id: 35275

        assert_equal @order, assigns(:order)
      end
    end

    test "should set shipping method options" do
      VCR.use_cassette("shipping_methods") do
        send_request

        assert_not_nil assigns(:shipping_methods)
        assert_kind_of Array, assigns(:shipping_methods)
        assert assigns(:shipping_methods).all? do |method|
          method.kind_of? ShippingMethod
        end
      end
    end
  end

  class ShippingSetTest < OrdersControllerTest
    setup do
      def send_base_request(params={})
        patch :shipping_set, {
          id: @order.id
        }.merge(params)
      end
    end

    setup do
      get :shipping_select, id: @order.id
      @shipping_methods = assigns(:shipping_methods)
      assert_not @shipping_methods.empty?
    end

    class Success < ShippingSetTest
      setup do
        @selected_method = @shipping_methods.sample
        def send_request(params={})
          send_base_request({
            shipping_method_id: @selected_method.id
          }.merge(params))
        end
      end

      test "should redirect to confirmation page" do
        VCR.use_cassette("shipping_methods") do
          send_request

          assert_response :redirect
          assert_redirected_to order_confirmation_path(@order)
        end
      end

      test "should set shipping options on order" do
        VCR.use_cassette("shipping_methods") do
          assert_not_equal @selected_method.name, @order.shipping_name
          assert_not_equal @selected_method.cost, @order.shipping_cost

          send_request

          @order.reload
          assert_equal @selected_method.name, @order.shipping_name
          assert_equal @selected_method.cost, @order.shipping_cost
        end
      end
    end

    class Failure < ShippingSetTest
      setup do
        alias :send_request :send_base_request

        def test_bad_request(id)
          send_request shipping_method_id: id

          assert_response :redirect
          assert_redirected_to shipping_order_path
          assert_not flash[:notice].empty?
        end
      end

      test "should redirect to shipping selection page when bad id selected" do
        VCR.use_cassette("shipping_methods") do
          bad_id = @shipping_methods.map { |s| s.id }.max * 2
          test_bad_request(bad_id)
        end
      end

      test "should redirect to shipping selection page when nil/no id selected" do
        VCR.use_cassette("shipping_methods") do
          test_bad_request(nil)
        end
      end
    end
  end
end
