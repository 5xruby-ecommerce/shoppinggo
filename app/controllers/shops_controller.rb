# frozen_string_literal: true

class ShopsController < ApplicationController
  layout "store"

  def index
    # @products = Product.where(shops: current_user.shop)
    @products = current_user.shop.products
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = current_user.build_shop(shop_params)
    if @shop.save
      redirect_to rshops_path, notice: '註冊成功'
    else
      render :new, notice: '註冊失敗'
    end
  end

  def edit
    @shop = current_user.shop
  end

  def update
    @shop = current_user.shop
    if @shop.update(shop_params)
      byebug
      redirect_to shops_path, notice: '資料更新成功'
    else
      render :edit
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :tel)
  end
end
