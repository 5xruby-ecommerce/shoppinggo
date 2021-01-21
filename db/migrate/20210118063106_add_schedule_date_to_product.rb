class AddScheduleDateToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :schedule_start, :datetime
    add_column :products, :schedule_end, :datetime
  end
end
