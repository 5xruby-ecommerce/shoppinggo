class AddColumnToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :number, :integer
  end
end
