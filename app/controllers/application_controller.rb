# frozen_string_literal: true

class ApplicationController < ActionController::Base

  include CartsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private
  def render_not_found
    render :file => '/public/404.html', layout: false, :status => 404
  end

end
