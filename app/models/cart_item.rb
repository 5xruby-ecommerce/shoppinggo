class CartItem 
  attr_reader :item_id, :quantity
  def initialize(item_id, quantity = 1)
    @item_id = item_id 
    @quantity = quantity
  end

  def increament(n = 1) 
    @quantity += n
  end

  def product
    Product.find(@item_id)
  end

  def total_price
    @quantity * product.price
  end
end 