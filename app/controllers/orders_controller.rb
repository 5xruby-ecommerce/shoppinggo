class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :return

  def index
    @orders = current_user.orders
    render layout: "member"
  end

  def show
    @orders = current_user.orders.find(:id)
    render layout: "member"
  end

  def new
    @order = Order.new
    add_mac_value(sample_params(@order))
  end

  def create
    @order = Order.new
    add_mac_value(sample_params(@order))
    if current_user
      @order = Order.new({user: current_user,
                          sum: current_cart.total_price,
                          number: @order.send(:order_number),
                        }.merge(order_params))
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
        discount = current_cart.cal_discount(shop_id,current_user, sum)
        sum = sum - discount
      end
      @order.save!
      session[:cartgo] = nil
      @order
    else
      render :new, notice: '訂單未成立'
    end
  end

    def return
    @callback_value = {
      'CustomField1' => params['CustomField1'],
      'CustomField2' => params['CustomField2'],
      'CustomField3' => params['CustomField3'],
      'CustomField4' => params['CustomField4'],
      'MerchantID' => params['MerchantID'],
      'MerchantTradeNo' => params['MerchantTradeNo'],
      'PaymentDate' => params['PaymentDate'],
      'PaymentType' => params['PaymentType'],
      'PaymentTypeChargeFee' => params['PaymentTypeChargeFee'],
      'RtnCode' => params['RtnCode'],
      'RtnMsg' => params['RtnMsg'],
      'SimulatePaid' => params['SimulatePaid'],
      'StoreID' => params['StoreID'],
      'TradeAmt' => params['TradeAmt'],
      'TradeDate' => params['TradeDate'],
      'TradeNo' => params['TradeNo'],
    }
    callback_val = compute_check_mac_value(@callback_value)
    rtn_val = params['CheckMacValue']
    order = Order.find_by(number:params['MerchantTradeNo'])
      if callback_val == rtn_val
        render plain: "1|OK"
        order.pay!
      end
    end

  private
  def sample_params(order)
    @hash = {
      'MerchantID' => '2000132',
      'MerchantTradeNo' => @order.send(:order_number),
      'MerchantTradeDate' => Time.zone.now.strftime('%Y/%m/%d %T'),
      'PaymentType' => 'aio',
      'TotalAmount' => current_cart.total_price,
      'TradeDesc' => '123',
      'ItemName' => current_cart.items_name,
      'ReturnURL' => 'http://localhost:5000//orders/return',
      'ClientBackURL' => 'http://localhost:5000/orders',
      'ChoosePayment' => 'Credit',
      'EncryptType' => '1',
    }
  end

  def add_mac_value(params)
    params['CheckMacValue'] = compute_check_mac_value(params) # 計算檢查碼
  end

  def compute_check_mac_value(params)
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

  def order_params
    params.require(:order).permit(:receiver, :tel, :address)
  end
end