json.extract! product, :id, :name, :description, :price, :stock, :color, :size, :category, :entry_date, :deleted_at, :images, :created_at, :updated_at
json.url product_url(product, format: :json)
json.images url_for(product.images)
