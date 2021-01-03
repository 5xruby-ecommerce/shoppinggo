class Cart 
  def initialize(items = [])
    @items = items
  end 

  def add_item(item_id, quantity = 1, shop_id)
    found_item = @items.find { |item| item.item_id == item_id}
    if found_item
      found_item.increament(quantity)
    else
      @items << CartItem.new(item_id, quantity, shop_id)
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
      "quantity" => item.quantity,
      "shop_id" => item.shop_id
    }}

    { "items" => items}
  end 

  def self.from_hash(hash)
    if hash && hash["items"]
      items = hash["items"].map { |item| CartItem.new(item["item_id"], item["quantity"], item["shop_id"])}
      Cart.new(items)
    else
      Cart.new
    end 
  end
end