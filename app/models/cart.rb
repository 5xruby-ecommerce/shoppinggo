class Cart
  def initialize(items = [])
    @items = items
  end

  def add_item(product_id, quantity = 1, product_name, product_price)
    found_item = @items.find { |item| item.product_id == product_id}
    if found_item
      found_item.increament(quantity)
    else
      @items << CartItem.new(product_id, quantity, product_name, product_price)
    end
  end

  def empty?
    @items.empty?
  end

  def items
    @items
  end

  def product_names
    @items.map(&:product_name).join(', ')
    # @items.map { |cart_item| cart_item.product_name }.join(', ')
  end

  def product_ids
    @items.map(&:product_id)
  end

  def total_price
    total = @items.reduce(0) { |total, item| total + item.total_price}

    if Date.today.month == 12 && Date.today.day == 25
      total = total * 0.9
    end
    total
  end

  def serialize
    items = @items.map { |item| {
      "product_id" => item.product_id,
      "quantity" => item.quantity,
      "product_name" => item.product_name,
      "product_price" => item.product_price,
    }}
    { "items" => items}
  end

  def self.from_hash(hash)
    if hash && hash["items"]
      items = hash["items"].map { |item| CartItem.new(item["product_id"], item["quantity"], item["product_name"], item["product_price"])}
      Cart.new(items)
    else
      Cart.new
    end
  end
end