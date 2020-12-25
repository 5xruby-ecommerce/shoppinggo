require 'net/http'

class CreateOrder

  def initialize(params={}) # 建立空陣列，產生訂單時接資料
    @params = params
  end

  def run
    create(sample_params)
  end

  private

  def url
    'https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5'
  end

  def sample_params
    # 基本參數
    {
      'MerchantID' => '2000132',
      'MerchantTradeNo' => 'ShoppingGo002',
      'MerchantTradeDate' => Time.zone.now.strftime('%Y/%m/%d %T'),
      'PaymentType' => 'aio',
      'TotalAmount' => '5',
      'TradeDesc' => '123',
      'ItemName' => 'Ruby',
      'ReturnURL' => 'http://localhost:3000/carts',
      'ClientBackURL' => 'http://localhost:3000/carts',
      'ChoosePayment' => 'Credit',
      'EncryptType' => '1'
    }
  end

  def create(params)
    params['CheckMacValue'] = compute_check_mac_value(params) # 計算檢查碼

    uri = URI(url)
    # 送出 Post request 到綠界，並取得回應內容
    response = Net::HTTP.post_form(uri, params)
    response.body.force_encoding('UTF-8')
  end

  def compute_check_mac_value(params)
    # 先將參數備份
    params = params.dup

    # 某些參數需要先進行 url encode
    %w[MerchantID MerchantTradeNo MerchantTradeDate PaymentType TotalAmount TradeDesc ItemName ReturnURL ClientBackURL ChoosePayment EncryptType].each do |key|
      next if params[key].nil?
      params[key] = urlencode_dot_net(params[key])
    end

    # 某些參數不需要參與 CheckMacValue 的計算
    # exclude_keys = %w[InvoiceRemark ItemName ItemWord ItemRemark]
    # params = params.reject do |k, _v|
    #   exclude_keys.include? k
    # end

    # 轉成 query_string
    query_string = to_query_string(params)
    # 加上 HashKey 和 HashIV
    query_string = "HashKey=5294y06JbISpM5x9&#{query_string}&HashIV=v77hoKGq4kWxNNIS"
    # 進行 url encode
    raw = urlencode_dot_net(query_string)
    # 套用 SHA256 後轉大寫
    Digest::SHA256.hexdigest(raw).upcase
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








# arr = HashKey=5294y06JbISpM5x9&    &HashIV=v77hoKGq4kWxNNIS

# HashKey=5294y06JbISpM5x9&ChoosePayment=Credit&ClientBackURL=http://localhost:3000/carts&EncryptType=1&ItemName=Ruby&MerchantID=2000132&MerchantTradeDate=2020/12/24 18:40:00&MerchantTradeNo=ShoppingGo001&PaymentType=aio&ReturnURL=http://localhost:3000/carts&TotalAmount=5000&TradeDesc=123&HashIV=v77hoKGq4kWxNNIS