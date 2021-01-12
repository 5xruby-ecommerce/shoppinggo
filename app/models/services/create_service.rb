class CreateService
  def initialize(params = {})
    @params = params
  end

  private
  def create_order
    if current_user
      order = Order.new(user: current_user, sum: current_cart.total_price)
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
      order.save!
      session[:cartgo] = nil
      order
    else
      redirect_to new_user_session_path
    end
  end

  def sample_params(order)
    @hash = {
      'MerchantID' => '2000132',
      'MerchantTradeNo' => order.number,
      'MerchantTradeDate' => Time.zone.now.strftime('%Y/%m/%d %T'),
      'PaymentType' => 'aio',
      'TotalAmount' => current_cart.total_price,
      'TradeDesc' => '123',
      'ItemName' => current_cart.items_name,
      'ReturnURL' => 'http://localhost:5000/carts/checkout',
      'ClientBackURL' => 'http://localhost:5000/',
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