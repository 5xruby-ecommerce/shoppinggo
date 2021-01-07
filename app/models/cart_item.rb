class CartItem
  attr_reader :product_id, :quantity

  def initialize(product_id, quantity = 1)
    @product_id = product_id
    @quantity = quantity
  end

  def increament(n = 1)
    @quantity += n
  end

  def product
    @product ||= Product.find_by(id: product_id)
  end

  def total_price
    quantity.to_i * product.price
  end
end