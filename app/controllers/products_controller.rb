# frozen_string_literal: true

class ProductsController < ApplicationController

  before_action :find_shop, only: [:create, :edit, :update, :destroy]
  before_action :find_product, only: [:edit, :update, :destroy]

  def show
    @product = Product.find(params[:id])
  end

  def search
    if params[:search]
        @product = Product.where('name LIKE ?OR content LIKE ?', "%#{params[:search]}%",  "%#{params[:search]}%")
    else
        @product = Product.all
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.shop = current_user.shop

    if @product.save
      redirect_to shops_path, notice: '新增商品成功'
    else
      render :new, notice: '沒成功，再試一次吧'
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to shops_path, notice: '更新商品成功'
    else
      render :edit, notice: '更新商品失敗'
    end
  end

  def destroy
    if @product.destroy
      redirect_to shops_path, notice: '已刪除商品'
    else
      redirect_to shops_path, notice: '刪除商品失敗'
    end
  end

  private

  def find_shop
    @shop = Shop.find(current_user.shop.id)
  end

  def find_product
    @product = @shop.products.find(params['id'])
  end

  def product_params
    params.require(:product).permit(:image, :name, :content, :quantity, :price, {images:[]})
  end

end

