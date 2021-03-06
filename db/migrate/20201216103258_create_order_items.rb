# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.string :category
      t.integer :quantity
      t.integer :price
      t.references :sub_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
