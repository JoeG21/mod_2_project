class OrdersController < ApplicationController

    def new
        @cart = ShoppingCart.find(session[:shopping_cart_id])
        if @cart.selected_items.empty?
            flash[:message] = "Your cart is empty"
            redirect_to shopping_cart_path(session[:shopping_cart_id])
        end
        @order = Order.new
    end

    def create
        params
        @order = Order.new(order_params)
        @order.save
        session[:shopping_cart_id] = nil
        redirect_to order_path(@order[:id])
    end

    def show 
        @order = Order.find(params[:id])
        @cart = ShoppingCart.find(@order[:shopping_cart_id])
        @cart_items = SelectedItem.all.select do |select_item| 
            select_item.shopping_cart_id == @order[:shopping_cart_id]
        end
        @total = total
    end

    private
    def order_params
        params.require(:order).permit(:name, :address, :city, :state, :zip, :cc, :ccexp, :user_id, :shopping_cart_id)
    end

    private

    def cart_items
        @cart_items = SelectedItem.all.select do |select_item| 
            select_item.shopping_cart_id == @order[:shopping_cart_id]
        end
    end

    def total
        total = 0
        @cart_items.each do |item|
            total += ((item.item.price || 0)*(item.quantity || 0))
        end
        total.round(2)
    end



end
