<<<<<<< HEAD
# frozen_string_literal: true

class ProductsController < ApplicationController

  def index
      if params[:search]
          @products = Product.where('name LIKE ?OR content LIKE ?', "%#{params[:search]}%",  "%#{params[:search]}%")
      else
          @product = Product.all
      end
  end 

  def new
    @product = Product.new
    render layout: "store"
  end
  
  def show
    @product = Product.find(params[:id])
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
    find_product
  end

  def update
    find_product
    if @product.update(product_params)
      redirect_to shops_path, notice: '更新商品成功'
    else
      render :edit, notice: '更新商品失敗'
    end
  end

  def destroy
    find_product
    if @product.destroy
      redirect_to shops_path, notice: '已刪除商品'
    else
      redirect_to shops_path, notice: '刪除商品失敗'
    end
  end

  def search
  end

  private
  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:image, :name, :content, :quantity, :price, {images:[]})
  end
end
=======
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
    product = Product.find(params[:id])

    if current_user.favorite?(product)
      current_user.my_favorites.destroy(product)
      render json: { status: 'removed' }
    else
      current_user.my_favorites << product
      render json: { status: 'added' }
    end
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
>>>>>>> 601938dd8645ad88191889284507e5dc0c998743
