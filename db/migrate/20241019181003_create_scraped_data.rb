class CreateScrapedData < ActiveRecord::Migration[7.1]
  def change
    create_table :scraped_data do |t|
      t.integer :task_id
      t.string :task_url
      t.string :brand
      t.string :model
      t.string :price

      t.timestamps
    end
  end
end
