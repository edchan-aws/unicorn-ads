json.extract! ad, :id, :category, :key_words, :bid_price_in_cents, :content, :image_url, :created_at, :updated_at
json.url ad_url(ad, format: :json)
