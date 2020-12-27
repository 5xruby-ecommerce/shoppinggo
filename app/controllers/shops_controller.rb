# frozen_string_literal: true

class ShopsController < ApplicationController
  def index
    # @products = Product.where(shops: current_user.shop)
    @products = current_user.shop.products
  end

  def new
    @shop = Shop.new
  end

  def create
    # @shop = Shop.new(shop_params)

    # if current_user.build_shop(shop_params)
    #   redirect_to root_path, notice: '註冊成功'
    # else
    #   render :new, notice: '註冊失敗'
    # end
    @shop = Shop.new(shop_params)
    @shop.user = current_user
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
