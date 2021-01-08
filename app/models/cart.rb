class Cart 
  def initialize(items = [], coupons = [], total = 0, subtotals=[])
    @items = items
    @coupons = coupons
    @total = total
    @subtotals = subtotals
  end 

  def add_item(item_id, quantity = 1, shop_id)
    found_item = @items.find { |item| item.item_id == item_id }
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
    total = @items.reduce(0) { |total, item| total + item.total_price }

    if Date.today.month == 12 && Date.today.day == 25
      total = total * 0.9
    end

    @total = total
    total
  end

  def use_coupon()
    @coupons << usercoupon_id
  end

  def unuse_coupon(shop_id, coupon_id)
    @coupons.delete(usercoupon_id)
  end

  def totalprice_use_coupon(shop_id)
    shop_items = @items.filter { |item| item.shop_id == shop_id }
    
    total = 0
    shop_items.each do |item|
      total += item.total_price
    end

    if @subtotals.each.filter { |item| item[1] == shop_id }.empty?
      @subtotals << [total, shop_id]
    else

    end

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
      items = hash["items"].map { |item| CartItem.new(item["item_id"], item["quantity"], item["shop_id"]) }
      Cart.new(items)
    else
      Cart.new
    end 
  end
end