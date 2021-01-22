class CartsController < ApplicationController
  # before_action :authenticate_user! ,only:[:add_item]
  skip_before_action :verify_authenticity_token, only: :return

  def add_item
    if current_user
      product = Product.find(params[:id])
      quantity = JSON.parse(params.keys.filter{|i| i[/.amount/]}.first)["amount"].to_i
      current_cart.add_item(product.id, quantity)
      current_cart.shop_totalprice(product.shop_id)
      current_cart.cal_cart_total
      session[:cartgo] = current_cart.serialize
      redirect_to root_path, notice: '已加入購物車'
    else
      redirect_to user_session_path
    end
  end

  def update_item
    if current_user
      product = Product.find(params[:id])
      quantity = JSON.parse(params.keys.filter{|i| i[/.amount/]}.first)["amount"].to_i
      current_cart.add_item(product.id, quantity)
      current_cart.shop_totalprice(product.shop_id)
      current_cart.cal_cart_total
      shoptotal = current_cart.subtotals.filter {|total, shopid| shopid == product.shop_id}[0][0]
      session[:cartgo] = current_cart.serialize
      render json:{ status: 'ok',
                    count: current_cart.items.count,
                    total_price: current_cart.total_price,
                    change: quantity,
                    shoptotal: shoptotal,
                    shopID: product.shop_id
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

  def empty
    session[:cartgo] = nil
    redirect_to root_path, notice: '購物車已清除'
  end

  def destroy
    result_ary = session[:cartgo]["items"].filter { |item| item["product_id"] != params[:id].to_i }
    session[:cartgo] = { 'items' => result_ary }
    redirect_to carts_path, notice: "已刪除訂單"
  end

  def get_coupon_info
    coupon = Coupon.find(params[:id])
    user_coupons = current_user.user_coupons.where(coupon_id: params[:id])
    own = !(user_coupons.empty?)

    if own
      status = user_coupons.pluck(:coupon_status)
      id = user_coupons.pluck(:id)

      render json: {
        discount_rule: coupon[:discount_rule],
        discount_start: coupon_TimeWithZone_convert(coupon[:discount_start]),
        discount_end: coupon_TimeWithZone_convert(coupon[:discount_end]),
        min_consumption: coupon[:min_consumption],
        discount_amount: coupon[:discount_amount],
        amount: coupon[:amount],
        counter_catch: coupon[:counter_catch],
        usercoupon_id: id,
        occupy: own,
        status: status
      }
    else
      render json: {
        discount_rule: coupon[:discount_rule],
        discount_start: coupon_TimeWithZone_convert(coupon[:discount_start]),
        discount_end: coupon_TimeWithZone_convert(coupon[:discount_end]),
        min_consumption: coupon[:min_consumption],
        discount_amount: coupon[:discount_amount],
        amount: coupon[:amount],
        counter_catch: coupon[:counter_catch],
        occupy: own
      }
    end
  end

  # def checkout
    # check_service = Ecpay::Checkcode::CreateService.new(...)

    # check_service.perform
    # @order = Order.new
    # add_mac_value(sample_params(@order))
  # end

  # def check_mac_value
  #   compute_check_mac_value(@params)
  # end

  # def return
  #   @callback_value = {
  #     'CustomField1' => params['CustomField1'],
  #     'CustomField2' => params['CustomField2'],
  #     'CustomField3' => params['CustomField3'],
  #     'CustomField4' => params['CustomField4'],
  #     'MerchantID' => params['MerchantID'],
  #     'MerchantTradeNo' => params['MerchantTradeNo'],
  #     'PaymentDate' => params['PaymentDate'],
  #     'PaymentType' => params['PaymentType'],
  #     'PaymentTypeChargeFee' => params['PaymentTypeChargeFee'],
  #     'RtnCode' => params['RtnCode'],
  #     'RtnMsg' => params['RtnMsg'],
  #     'SimulatePaid' => params['SimulatePaid'],
  #     'StoreID' => params['StoreID'],
  #     'TradeAmt' => params['TradeAmt'],
  #     'TradeDate' => params['TradeDate'],
  #     'TradeNo' => params['TradeNo'],
  #   }
  #   callback_val = compute_check_mac_value(@callback_value)
  #   rtn_value = params['CheckMacValue']
  #   order = Order.find_by(number:params['MerchantTradeNo'])
  #     if callback_val == rtn_value
  #       render plain: "1|OK"
  #       order.pay!
  #     end
  #   end

  # private
  # def create_order
  #   if current_user
  #     order = Order.new(user: current_user,
  #                       sum: current_cart.total_price)
  #     products_all = Product.includes(:shop).
  #       where(id: current_cart.product_ids).
  #       reduce({}) do |rs, product|
  #         rs[product.shop_id] ||= {}
  #         rs[product.shop_id][product.id] = product
  #         rs
  #       end

  #     products_all.each do |(shop_id, products)|
  #       items = current_cart.items.filter { |item| item.product_id.in?(products.keys) }
  #       sum = items.sum(&:total_price)
  #       discount = current_cart.cal_discount(shop_id,current_user, sum)
  #       sum = sum - discount
  #       order.sub_orders.new(sum: sum)
  #     end
  #     order.save!
  #     order
  #   else
  #     redirect_to new_user_session_path
  #   end
  # end

  # def sample_params(order)
  #   @hash = {
  #     'MerchantID' => '2000132',
  #     'MerchantTradeNo' => order.number,
  #     'MerchantTradeDate' => Time.zone.now.strftime('%Y/%m/%d %T'),
  #     'PaymentType' => 'aio',
  #     'TotalAmount' => current_cart.total_price,
  #     'TradeDesc' => '123',
  #     'ItemName' => current_cart.items_name,
  #     'ReturnURL' => 'http://localhost:5000/carts/return',
  #     'ClientBackURL' => 'http://localhost:5000/',
  #     'ChoosePayment' => 'Credit',
  #     'EncryptType' => '1',
  #   }
  # end

  # def add_mac_value(params)
  #   params['CheckMacValue'] = compute_check_mac_value(params) # 計算檢查碼
  # end

  # def compute_check_mac_value(params)
  #   # params = params.dup
  #   query_string = to_query_string(params)
  #   query_string = "HashKey=5294y06JbISpM5x9&#{query_string}&HashIV=v77hoKGq4kWxNNIS"
  #   raw = urlencode_dot_net(query_string)
  #   @shavalue = Digest::SHA256.hexdigest(raw).upcase
  # end

  # def to_query_string(params)
  #   params = params.sort_by do |key, _val|
  #     key.downcase
  #   end

  #   params = params.map do |key, val|
  #     "#{key}=#{val}"
  #   end
  #   params.join('&')
  # end

  # def urlencode_dot_net(raw_data)
  #   encoded_data = CGI.escape(raw_data).downcase
  #   encoded_data.gsub!('%2d', '-')
  #   encoded_data.gsub!('%5f', '_')
  #   encoded_data.gsub!('%2e', '.')
  #   encoded_data.gsub!('%21', '!')
  #   encoded_data.gsub!('%2a', '*')
  #   encoded_data.gsub!('%28', '(')
  #   encoded_data.gsub!('%29', ')')
  #   encoded_data.gsub!('%20', '+')
  #   encoded_data
  # end

  # def order_params
  #   params.require(:order).permit(:receiver, :tel, :address)
  # end
end
