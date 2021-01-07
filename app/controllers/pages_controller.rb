# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @products = Product.all
  end
end
