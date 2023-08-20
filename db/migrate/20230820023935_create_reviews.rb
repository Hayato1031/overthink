class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :anxiety
      t.integer :evaluation
      t.integer :aim_id
    end
  end
end
