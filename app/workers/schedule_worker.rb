class ScheduleWorker
  include Sidekiq::Worker

  def perform(product_id)
    product = Product.find(product_id)
    product.status = 0
    product.save
  end
end