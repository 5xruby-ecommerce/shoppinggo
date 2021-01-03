module CartsHelper
  def current_cart
    p  "helper#{session[:cartgo]}"
    @_cartgo ||= Cart.from_hash(session[:cartgo])
  end 
end
