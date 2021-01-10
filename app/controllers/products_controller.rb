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
    @product = current_user.shop.products.new
  end

  def create
    @product = Product.new(product_params)
    @product.shop = current_user.shop

    if @product.save
      redirect_to shops_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to shops_path
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to shops_path
    else
      redirect_to shops_path
    end
  end

  def favorite
    render html: '1'
  end

  private

  def find_shop
    @shop = current_user.shop
  end

  def find_product
    @product = current_user.shop.products.find(params['id'])
  end

  def product_params
    params.require(:product).permit(
      :image,
      :name,
      :content,
      :quantity,
      :price,
      {images:[]})
  end
end
