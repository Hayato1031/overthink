class CreateAims < ActiveRecord::Migration[6.1]
  def change
    create_table :aims do |t|
      t.string :how
      t.string :what
      t.integer :user_id
      t.timestamps null: false
    end
  end
end