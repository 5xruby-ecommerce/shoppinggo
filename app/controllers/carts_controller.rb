class CartsController < ApplicationController

  def add_item
    product = Product.find(params[:id])
    quantity = JSON.parse(params.keys.first)["amount"].to_i
    current_cart.add_item(product.id, product.name, quantity, product.price)
    session[:cartgo] = current_cart.serialize
    redirect_to root_path, notice: '已加入購物車'
  end

  def show
  end

  def destroy
    session[:cartgo] = nil
    redirect_to root_path, notice: "購物車已清空"
  end

  def checkout
    @order = Order.new
    create_order(sample_params)
  end

  def initialize(params={}) # 建立空陣列，產生訂單時接資料
    @params = params
  end

  def check_mac_value  # 建立檢查碼
    compute_check_mac_value(@params)  # 組合檢查碼
  end

  private

  def sample_params
    @hash = {
      'MerchantID' => '2000132',
      'MerchantTradeNo' => 'shoppinggoA000011',
      'MerchantTradeDate' => Time.zone.now.strftime('%Y/%m/%d %T'),
      'PaymentType' => 'aio',
      'TotalAmount' => current_cart.total_price,
      'TradeDesc' => '123',
      'ItemName' => 'Ruby',
      'ReturnURL' => 'http://localhost:3000/carts/checkout',
      'ClientBackURL' => 'http://localhost:3000/carts/checkout',
      'ChoosePayment' => 'Credit',
      'EncryptType' => '1',
    }
  end

  def create_order(params)
    params['CheckMacValue'] = compute_check_mac_value(params) # 計算檢查碼
  end

  def compute_check_mac_value(params)
    # 先將參數備份
    params = params.dup
    # 轉成 query_string
    query_string = to_query_string(params)
    # 加上 HashKey 和 HashIV
    query_string = "HashKey=5294y06JbISpM5x9&#{query_string}&HashIV=v77hoKGq4kWxNNIS"
    # 進行 url encode
    raw = urlencode_dot_net(query_string)
    # 套用 SHA256 後轉大寫
    @shavalue = Digest::SHA256.hexdigest(raw).upcase
  end

  def urlencode_dot_net(raw_data)
    # url encode 後轉小寫
    encoded_data = CGI.escape(raw_data).downcase
    # 調整成跟 ASP.NET 一樣的結果
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
    # 對小寫的 key 排序
    params = params.sort_by do |key, _val|
      key.downcase
    end

    # 組成 query_string
    params = params.map do |key, val|
      "#{key}=#{val}"
    end
    params.join('&')
  end

end
