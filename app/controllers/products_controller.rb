# frozen_string_literal: true

class ProductsController < ApplicationController

  before_action :find_shop, only: [:create, :edit, :update, :destroy]
  before_action :find_product, only: [:edit, :update, :destroy]
  layout 'store', only: [:new, :edit]

  def show
    @product = Product.find(params[:id])
  end

  def search
    if params[:search]
      if Product.where('name LIKE ?OR content LIKE ?', "%#{params[:search]}%",  "%#{params[:search]}%").present?
        @product = Product.where('name LIKE ?OR content LIKE ?', "%#{params[:search]}%",  "%#{params[:search]}%") 
      else 
        @product = Product.tagged_with(params[:search], wild: true)
      end
    else
      @product = Product.all
    end
    @product = @product.where(status: 0)
  end

  def new
    @product = current_user.shop.products.new
  end

  def create
    @product = Product.new(product_params)
    @product.shop = current_user.shop

    if @product.schedule_start.nil?
      @product.schedule_start = Time.now
    end 

    if @product.schedule_start > Time.now 
      @product.status = 1
    end

    if @product.save
      if @product.schedule_start > Time.now
        ScheduleWorker.perform_at(@product.schedule_start, @product.id)
      end
      redirect_to shops_path
    else
      render :new, layout: "store"
    end
  end

  def edit
  end

  def update

    if @product.schedule_start.nil?
      @product.schedule_start = Time.now
    end 

    if @product.schedule_start > Time.now 
      @product.status = 1
    end
    if @product.update(product_params)
      if @product.schedule_start > Time.now 
        ScheduleWorker.perform_at(@product.schedule_start, @product.id)
      end
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
    product = Product.find(params[:id])

    if current_user.favorite?(product)
      current_user.my_favorites.destroy(product)
      render json: { status: 'removed' }
    else
      current_user.my_favorites << product
      render json: { status: 'added' }
    end
  end

  def my_favorite
    @my_favorites = current_user.my_favorites
    render layout: 'member'
  end

  

  private

  def find_shop
    @shop = current_user.shop
  end

  def find_product
    @product = current_user.shop.products.find(params['id'])
    # @product = current_user.shop.products.find(product_params)
  end

  def product_params
    params.require(:product).permit(
      :image,
      :name,
      :content,
      :quantity,
      :price,
      :schedule_start,
      :schedule_end,
      :category_list,
      :sub_list,
      {images:[]})
  end
end
