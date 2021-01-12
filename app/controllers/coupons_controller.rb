class CouponsController < ApplicationController

  def index
  end

  def new
    @shop = Shop.find(current_user.shop.id)
    @coupon = Coupon.new
    render layout: "store"
  end

  def create
    @coupon = Coupon.new(coupon_params)
    @coupon.shop_id = current_user.shop.id

    respond_to do |format|
      if @coupon.save
        format.html {
          redirect_to shops_path, notice: 'Coupon was successfully created'
        }
        format.json { render :show, status: :create, location: @coupon}
      else
        format.html { render :new }
        format.json { render json: @coupon.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @coupon.save
        format.html {
          redirect_to shops_path, notice: 'Coupon was successfully created'
        }
        format.json { render :show, status: :create, location: @coupon}
      else
        format.html { render :new }
        format.json { render json: @coupon.errors, status: :unprocessable_entity}
      end
    end
  end

  def list
    @coupons = Coupon.where(shop_id: current_user.shop.id)
    render layout: "store"
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def show
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy
    respond_to do |format|
      format.html {redirect_to list_coupons_path, notice: 'Coupon was successfully destroyed',}
      format.json { head :no_content}
    end
  end

  private
    def coupon_params
      params.require(:coupon).permit(:title, :discount_rule, :discount_amount, :min_consumption, :discount_start, :discount_end, :amount)
    end

end