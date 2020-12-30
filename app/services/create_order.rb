require 'net/http'

class CreateOrder

  def initialize(params={}) # 建立空陣列，產生訂單時接資料
    @params = params
  end

  def check_mac_value  # 建立檢查碼
    compute_check_mac_value(@params)  # 組合檢查碼
  end

  # def test
  #   expect(
  #     {
  #       'TradeDesc' => '促銷方案',
  #       'PaymentType' => 'aio',
  #       'MerchantTradeDate' => '2013/03/12 15:30:23',
  #       'MerchantTradeNo' => 'ecpay20130312153023',
  #       'MerchantID' => '2000132',
  #       'ReturnURL' => 'https://www.ecpay.com.tw/receive.php',
  #       'ItemName' => 'Apple iphone 7 手機殼',
  #       'TotalAmount' => '1000',
  #       'ChoosePayment' => 'ALL',
  #       'EncryptType' => '1'
  #     },
  #     'CFA9BDE377361FBDD8F160274930E815D1A8A2E3E80CE7D404C45FC9A0A1E407'
  #   )
  #     end

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
      'MerchantTradeNo' => 'shoppinggoA000003',
      'MerchantTradeDate' => Time.zone.now.strftime('%Y/%m/%d %T'),
      'PaymentType' => 'aio',
      'TotalAmount' => '5',
      'TradeDesc' => '123',
      'ItemName' => 'Ruby',
      'ReturnURL' => 'http://localhost:3000/carts/checkout',
      'ClientBackURL' => 'http://localhost:3000/carts/checkout',
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

    # 轉成 query_string
    query_string = to_query_string(params)
    # 加上 HashKey 和 HashIV
    query_string = "HashKey=5294y06JbISpM5x9&#{query_string}&HashIV=v77hoKGq4kWxNNIS"
    p "query_string: #{query_string}"
    # 進行 url encode
    raw = urlencode_dot_net(query_string)
    p "raw: #{raw}"
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

  # def expect(a, b)
  #   @params = a
  #   rs = check_mac_value
  #   puts rs
  #   puts rs == b
  # end
end