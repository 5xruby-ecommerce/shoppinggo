class CartItem
  attr_reader :product_id, :quantity, :product_name, :product_price
  def initialize(product_id, quantity = 1, product_name, product_price)
    @product_id = product_id
    @quantity = quantity
    @product_name = product_name
    @product_price = product_price
  end

  def increament(n = 1)
    @quantity += n
  end

  def product
    @product = Product.find_by(id: @product_id)
  end

  def sub_order_sum
    # @product = Product
  end

  def total_price
    @product = Product.find_by(id: product_id)
    @quantity.to_i * @product.price
  end
end