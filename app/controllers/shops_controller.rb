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
      redirect_to root_path, notice: '註冊成功'
    else
      render :new, notice: '註冊失敗'
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :tel)
  end
end
