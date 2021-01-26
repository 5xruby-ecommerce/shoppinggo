# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @products = Product.where(status: 0)
  end
end
