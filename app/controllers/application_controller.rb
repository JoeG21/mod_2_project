class ApplicationController < ActionController::Base
    before_action :set_cart
    #helper_method :current_cart
    helper_method :current_user

    def current_user
      if !session[:user_id].nil? && !session[:user_id] != ""
        @user = User.find_by(id: session[:user_id])
      else
        nil
      end
    end

    def logged_in?
        !!current_author
    end


    private
    

    def set_cart
        @cart = ShoppingCart.find(session[:shopping_cart_id])
        rescue ActiveRecord::RecordNotFound
        @cart = ShoppingCart.create
        session[:shopping_cart_id] = @cart.id
    end

    def authorized
        if logged_in?
          true
        else
          flash[:error] = "You must login to see this page."
          redirect_to login_path
        end
    end

    def cart_count
      cart_items = SelectedItem.select{|item|  item.shopping_cart_id == session[:shopping_cart_id]}
      @cart_count = cart_items.map{|item| item.quantity}.sum


    end
    # def current_cart
    #     if !session[:cart_id].nil?
    #       Cart.find(session[:cart_id])
    #     end
    # end

end
