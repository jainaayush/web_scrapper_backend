class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :url
      t.string :title
      t.string :description
      t.float :price
      t.integer :mobile_number

      t.timestamps
    end
  end
end
