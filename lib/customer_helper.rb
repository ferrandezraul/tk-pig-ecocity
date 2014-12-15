class CustomerHelper

  # Return array with names of customers
  def self.names( customers )
    # returns new array with customers name
    customers.collect { |customer| customer.name }
  end

  # Return customer with given name
  # raises an exception if not found
  def self.find_customer_with_name( customers, name )

    customers.each do |customer|
      if customer.name == name
        return customer
      end
    end

    raise Errors::CustomerHelperError.new, "Customer not found."
  end

end