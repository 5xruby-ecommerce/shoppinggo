class ScheduleWorker
  include Sidekiq::Worker

  def perform(product_id)
    byebug
    p '--------'
    product = Product.find(product_id)
    product.status = 0
    p 'try sidekiq'
    p '--------'
  end
end