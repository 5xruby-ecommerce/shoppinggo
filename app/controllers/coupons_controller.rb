class CouponsController < ApplicationController
  before_action :find_coupon, only: [:edit, :update, :destroy]
  
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
          redirect_to list_coupons_path
        }
        # format.json { render :show, status: :create, location: @coupon}
      else
        format.html { render :new }
        # format.json { render json: @coupon.errors, status: :unprocessable_entity}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @coupon.update(coupon_params)
        format.html {
          redirect_to list_coupons_path
        }
        # format.json { render :show, status: :create, location: @coupon}
      else
        format.html { render :new }
        # format.json { render json: @coupon.errors, status: :unprocessable_entity}
      end
    end
  end

  def list
    @coupons = Coupon.where(shop_id: current_user.shop.id)
    render layout: "store"
  end

  def show
  end

  def destroy
    @coupon.destroy
    respond_to do |format|
      format.html {redirect_to list_coupons_path, notice: 'Coupon was successfully destroyed'}
      format.json { head :no_content}
    end
  end

  private
    def find_coupon
      @coupon = current_user.shop.coupons.find(params[:id])
    end

    def coupon_params
      params.require(:coupon).permit(:title, :discount_rule, :discount_amount, :min_consumption, :discount_start, :discount_end, :amount)
    end
end