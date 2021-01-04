class AddColumnToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :order, :number, :integer
  end
end
