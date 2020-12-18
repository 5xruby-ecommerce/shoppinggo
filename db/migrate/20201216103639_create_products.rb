# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :content
      t.integer :price
      t.integer :quantity
      t.string :shop
      t.string :references

      t.timestamps
    end
  end
end
