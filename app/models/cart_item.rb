class CartItem 
  attr_reader :item_id, :quantity, :shop_id
  def initialize(item_id, quantity = 1, shop_id)
    @item_id = item_id 
    @quantity = quantity
    @shop_id = shop_id
  end

  def increament(n = 1) 
    @quantity += n
  end

  def product
    Product.find(@item_id)
  end

  def total_price
    @quantity.to_i * product.price
  end
end 