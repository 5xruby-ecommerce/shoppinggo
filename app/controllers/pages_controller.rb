# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @shop = Shop.all
    @products = Product.all
  end
end
