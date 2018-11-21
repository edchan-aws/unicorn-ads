class CreateAds < ActiveRecord::Migration[5.2]
  def change
    create_table :ads do |t|
      t.string :category
      t.string :key_words
      t.integer :bid_price_in_cents
      t.string :content
      t.string :image_url

      t.timestamps
    end
  end
end
