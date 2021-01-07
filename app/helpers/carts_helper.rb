module CartsHelper
  def current_cart
    @_cartgo ||= Cart.from_hash(session[:cartgo])
  end
end
