class Cart
  attr_reader :items, :coupons, :total, :subtotals
  def initialize(items = [], coupons=[], total= 0, subtotals= [])
    @items = items
    @coupons = coupons
    @total = total
    @subtotals = subtotals
  end

  def add_item(product_id, quantity = 1)
    found_item = @items.find { |item| item.product.id == product_id }
    if found_item
      found_item.increament(quantity)
    else
      @items << CartItem.new(product_id, quantity)
    end
    
    shop_id = Product.find_by(id: product_id).shop_id
    shop_totalprice(shop_id)
    @total = @subtotals.reduce(0) { |total, shoptotal| total + shoptotal[0] }
  end

  def empty?
    @items.empty?
  end

  def product_ids
    @items.map(&:product_id)
  end

  def total_price
    if @items
      total = @items.reduce(0) { |total, item| total + item.total_price }
    else 
      total = 0
    end 

    if Date.today.month == 12 && Date.today.day == 25
      total = total * 0.9
    end

    total
  end

  def use_coupon(usercoupon_id, shop_id)
    if @coupons.filter { |usercoupon, shop| usercoupon == usercoupon_id}.empty?
      @coupons << [usercoupon_id, shop_id]
    end
  end

  def unuse_coupon(usercoupon_id, shop_id)
    use_coupon = !(@coupons.filter { |usercoupon, shop| usercoupon == usercoupon_id}.empty?)
    if use_coupon
      @coupons = @coupons.filter { |usercouponid, shopid| usercouponid != usercoupon_id }
    end
  end

  def shop_totalprice(shop_id)
    shop_items = @items.filter { |item| item.shop_id == shop_id }
    shoptotal = shop_items.reduce(0) { |shoptotal, item| shoptotal + item.total_price }

    user_use_shop_coupon = !(@coupons.filter {|usercouponid, shopid| shopid == shop_id}.empty?)    
    if user_use_shop_coupon
      usercouponid, shopid = @coupons.filter {|usercouponid, shopid| shopid == shop_id}
      couponid = UserCoupon.find_by(id: usercouponid).coupon_id
      coupon = Coupon.find_by(id: couponid)
      discount_amount = coupon.discount_amount
      discount_rule = coupon.discount_rule
      if discount_rule == 'dollar'
        shoptotal -= discount_amount
      elsif discount_rule == 'percent'
        shoptotal = shoptotal * 0.01 * (1 - discount_amount.to_i)
      end 
    end

    if @subtotals.filter { |shoptotal, shopid| shopid == shop_id }.empty?
      @subtotals << [shoptotal, shop_id]
    else
      @subtotals = @subtotals.map { |origin_shoptotal, shopid| shopid == shop_id ? [shoptotal, shopid] : [origin_shoptotal, shop_id] }
    end
  end

  def serialize
    items = @items.map do |item|
      {
        "product_id" => item.product.id,
        "quantity" => item.quantity
      }
    end
    sub_totals = @subtotals.map do |subtotal|
      {
        "shoptotal" => subtotal[0],
        "shop_id" => subtotal[1]
      }
    end
    { 
      "items" => items,
      "subtotals" => sub_totals 
    }
  end

  def self.from_hash(hash)
    if hash && hash["items"] && hash["subtotals"]
      items = hash["items"].map do |item|
        CartItem.new(item["product_id"], item["quantity"])
      end
      sub_totals = hash["subtotals"].map do |subtotal|
        [subtotal["shoptotal"], subtotal["shop_id"]]
      end
      Cart.new(items,coupons=[], total=0, subtotals=sub_totals)
    else
      Cart.new
    end
  end
end