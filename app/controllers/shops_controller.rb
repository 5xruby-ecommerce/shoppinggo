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
      redirect_to shops_path
    else
      render :new
    end
  end

  def edit
    @shop = current_user.shop
  end

  def update
    @shop = current_user.shop
    if @shop.update(shop_params)
      redirect_to shops_path
    else
      render :edit
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :tel)
  end
end
