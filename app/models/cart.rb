class Cart
  attr_reader :items, :coupons, :total, :subtotals
  def initialize(items = [], coupons = [], total = 0, subtotals = [])
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
  end

  def empty?
    @items.empty?
  end

  def product_ids
    @items.map(&:product_id)
  end

  def total_price
    if not @subtotals.empty?
      @total = @subtotals.reduce(0) {|sum, item| sum + item[0]}
    else
      @total = 0
    end
    total = @total
    total
  end

  def cal_discount(shop_id,current_user, sum)
    coupon_id = Shop.find(shop_id).coupons.pluck(:id) & current_user.user_coupons.pluck(:coupon_id)
    if not coupon_id.empty?
      coupon = Coupon.find(coupon_id[0])
      discount_rule = coupon.discount_rule
      discount_amount = coupon.discount_amount.to_i
      min_consumption = coupon.min_consumption.to_i
      if min_consumption < sum
        if discount_rule == 'percent'
          discount = (sum * discount_amount * 0.01).floor()
        elsif discount_rule == 'dollor'
          discount = discount_amount
        end
      else
        discount = 0
      end
    else
      discount = 0
    end
    if @subtotals.filter { |shoptotal, shopid| shopid == shop_id }.empty?
      @subtotals << [sum-discount, shop_id]
    else
      @subtotals = @subtotals.map { |origin_shoptotal, shopid| shopid == shop_id ? [sum-discount, shop_id] : [origin_shoptotal, shopid] }
    end
    discount
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
        shoptotal = (shoptotal * (1 - 0.01 * discount_amount.to_i)).floor()
      end 
    end

    if @subtotals.filter { |shoptotal, shopid| shopid == shop_id }.empty?
      @subtotals << [shoptotal, shop_id]
    else
      @subtotals = @subtotals.map { |origin_shoptotal, shopid| shopid == shop_id ? [shoptotal, shop_id] : [origin_shoptotal, shopid] }
    end
  end

  def cal_cart_total 
    if not @subtotals.empty?
      @total = @subtotals.reduce(0) {|sum, item| sum + item[0]}
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
    coupons = @coupons.map do |coupon|
      {
        "usercoupon" => coupon[0],
        "shop_id" => coupon[1]
      }
    end
    total = {"total" => @total}

    { 
      "items" => items,
      "subtotals" => sub_totals,
      "coupons" => coupons,
      "total" => total
    }
  end

  def items_name
    items.map { |item| "#{item.product.name} x #{item.quantity}" }.join('#')
  end

  def self.from_hash(hash)
    if hash && hash["items"] && hash["subtotals"] && hash["coupons"] && hash["total"]
      items = hash["items"].map do |item|
        CartItem.new(item["product_id"], item["quantity"])
      end
      sub_totals = hash["subtotals"].map do |subtotal|
        [subtotal["shoptotal"], subtotal["shop_id"]]
      end
      _coupons = hash["coupons"].map do |coupon|
        [coupon["usercoupon"], coupon["shop_id"]]
      end
      _total = hash["total"]["total"].to_i
      Cart.new(items,coupons=_coupons, total=_total, subtotals=sub_totals)
    else
      Cart.new
    end
  end
end
