class ProductHelper

  # Return array with names of products
  def self.names( products )
    products.collect { |product| product.name }
  end

  # Return customer with given name
  # raises an exception if not found
  def self.find_product_with_name( products, name )
    products.each do |product|
      if product.name == name
        return product
      end
    end

    raise CustomerHelperError.new, "Product not found."
  end

end