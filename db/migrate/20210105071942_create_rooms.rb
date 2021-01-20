class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :rooms, :sender_id
    add_index :rooms, :receiver_id
    add_index :rooms, [:sender_id, :receiver_id], unique: true
  end
end
