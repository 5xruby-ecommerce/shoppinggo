class Cart 
  def initialize(items = [])
    @items = items
  end 

  def add_item(item_id, quantity = 1)
    found_item = @items.find { |item| item.item_id == item_id}
    if found_item
      found_item.increament(quantity)
    else
      @items << CartItem.new(item_id, quantity)
    end
  end

  def empty?
    @items.empty?
  end

  def items
    @items 
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
      "item_id" => item.item_id,
      "quantity" => item.quantity
    }}

    { "items" => items}
  end 

  def from_hash(hash)
    if hash && hash["items"]
      items = hash["items"].map { |item| CartItem.new(item["item_id"], item["quantity"])}
      cart = Cart.new(items)
    else
      cart = Cart.new
    end 
  end
end