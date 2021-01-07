class CartsController < ApplicationController

  # before_action :authenticate_user! ,only:[:add_item]
  def add_item
    if current_user
      product = Product.find(params[:id])
      # quantity = params[:amount].to_i
      quantity = JSON.parse(params.keys.filter{|i| i[/.amount/]}.first)["amount"].to_i
      current_cart.add_item(product.id, quantity)
      session[:cartgo] = current_cart.serialize
      redirect_to root_path, notice: '已加入購物車'
    else
      redirect_to user_session_path
    end
  end

  def update_item
    if current_user
      product = Product.find(params[:id])
      quantity = JSON.parse(params.keys.first)["amount"].to_i
      current_cart.add_item(product.id, quantity)
      session[:cartgo] = current_cart.serialize
      render json: {status: 'ok',
                    count: current_cart.items.count, total_price: current_cart.total_price
      }
    else
      redirect_to user_session_path
    end
  end

  def show
    if not current_user
      redirect_to user_session_path
    end
  end

  def checkout
    @order = Order.new
  end

  def cancel
    session[:cartgo] = nil
    redirect_to root_path, notice: '購物車已清除'
  end

  def destroy
    result_ary = session[:cartgo]["items"].filter { |item| item["item_id"] != params[:id].to_i }
    session[:cartgo] = { 'items' => result_ary }
    redirect_to carts_path, notice: "已刪除訂單"
  end

  def checkout
    @order = create_order
    add_mac_value(sample_params(@order))
  end

  def initialize(params={})
    @params = params
  end

  def check_mac_value
    compute_check_mac_value(@params)
  end

  private
  def create_order
    if current_user
      order = Order.new(user: current_user, sum: current_cart.total_price)

      # {
      #   shopA_id => {
      #     productAA_id => productAA,
      #     productAB_id => productAB
      #   },
      #   shopB_id => {
      #     productBA_id => productBA,
      #     productBB_id => productBB
      #   },
      # }
      products_all = Product.includes(:shop).
        where(id: current_cart.product_ids).
        reduce({}) do |rs, product|
          rs[product.shop_id] ||= {}
          rs[product.shop_id][product.id] = product
          rs
        end

      products_all.each do |(shop_id, products)|
        items = current_cart.items.filter { |item| item.product_id.in?(products.keys) }
        sum = items.sum(&:total_price)
        order.sub_orders.new(sum: sum)
      end

      # current_cart.items.each do |cart_item|
      #   sub_order.order_items.new(
      #     product_id: cart_item.product_id,
      #     quantity: cart_item.quantity,
      #     price: cart_item.product_price
      #   )
      # end
      byebug
      order.save!
      order
    else
      redirect_to new_user_session_path
    end
  end

  def sample_params(order)
    @hash = {
      'MerchantID' => '2000132',
      'MerchantTradeNo' => 'shoppinggoA0000012',
      'MerchantTradeDate' => Time.zone.now.strftime('%Y/%m/%d %T'),
      'PaymentType' => 'aio',
      'TotalAmount' => current_cart.total_price,
      'TradeDesc' => '123',
      'ItemName' => current_cart.items.first.product.name,
      'ReturnURL' => 'http://localhost:3000/carts/checkout',
      'ClientBackURL' => 'http://localhost:3000/carts/checkout',
      'ChoosePayment' => 'Credit',
      'EncryptType' => '1',
    }
  end

  def add_mac_value(params)
    params['CheckMacValue'] = compute_check_mac_value(params) # 計算檢查碼
  end

  def compute_check_mac_value(params)
    params = params.dup
    query_string = to_query_string(params)
    query_string = "HashKey=5294y06JbISpM5x9&#{query_string}&HashIV=v77hoKGq4kWxNNIS"
    raw = urlencode_dot_net(query_string)
    @shavalue = Digest::SHA256.hexdigest(raw).upcase
  end

  def urlencode_dot_net(raw_data)
    encoded_data = CGI.escape(raw_data).downcase
    encoded_data.gsub!('%2d', '-')
    encoded_data.gsub!('%5f', '_')
    encoded_data.gsub!('%2e', '.')
    encoded_data.gsub!('%21', '!')
    encoded_data.gsub!('%2a', '*')
    encoded_data.gsub!('%28', '(')
    encoded_data.gsub!('%29', ')')
    encoded_data.gsub!('%20', '+')
    encoded_data
  end

  def to_query_string(params)
    params = params.sort_by do |key, _val|
      key.downcase
    end

    params = params.map do |key, val|
      "#{key}=#{val}"
    end
    params.join('&')
  end
end
