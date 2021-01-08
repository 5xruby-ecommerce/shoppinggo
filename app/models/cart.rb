class Cart
  def initialize(items = [])
    @items = items
  end

  def add_item(product_id, quantity = 1)
    found_item = @items.find { |item| item.product_id == product_id }
    if found_item
      found_item.increament(quantity)
    else
      @items << CartItem.new(product_id, quantity)
    end
  end

  def empty?
    @items.empty?
  end

  def items
    @items
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
    items = @items.map do |item|
      {
        "product_id" => item.product_id,
        "quantity" => item.quantity,
      }
    end
    { "items" => items }
  end

  def self.from_hash(hash)
    if hash && hash["items"]
      items = hash["items"].map do |item|
        CartItem.new(item["product_id"], item["quantity"])
      end
      Cart.new(items)
    else
      Cart.new
    end
  end
end