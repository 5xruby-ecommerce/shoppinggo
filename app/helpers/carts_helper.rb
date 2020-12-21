module CartsHelper
  def current_cart
    @__cartgo ||= Cart.from_hash(session[:cartgo])
  end 
end
