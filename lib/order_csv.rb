require 'csv'
require 'product'
require 'subproduct'
require 'errors'

require 'product_helper'

module OrderColumns
  CUSTOMER = 0                #
  TAXES = 1                   #
  TOTAL_WITHOUT_TAXES = 2     #
  TOTAL = 3                 #
  ITEMS = 4                 #
  DATE = 5
end

class OrderCSV
  #  Returns array of Order attributes
  #  = Example
  #  orders = [
  #  {
  #    :customer => { :name => La Garrofa},
  #    :total_taxes => 8.50,
  #    :total_without_taxes => 8.50,
  #    :total => 10.50,
  #    :items => []
  #  }
  #]
  def self.read( file_path, products, customers )

    raise "File not found #{file_path}" unless File.exist?(file_path)

    # By default separator is ","
    # CSV.read(file_path, { :col_sep => ';' })
    orders_attributes_list = CSV.read(file_path, encoding: 'ISO8859-1')  # uses encoding: "ISO8859-1" to be able to read UTF8

    # Filter headers. Note that it is assumed that headers start with '#'
    orders_attributes_list.reject! { |order_attributes| order_attributes.first.start_with?('#') }

    orders_attributes_list.each { |order_attributes| verify_order_attributes( order_attributes ) }

    # Returns new array with product objects
    orders_attributes_list.map do |order_attributes|
      items = get_order_items( order_attributes )

      # customer, date, order_items=[]
      Order.new( CustomerHelper.find_customer_with_name( customers, order_attributes[OrderColumns::CUSTOMER] ),
                 order_attributes[OrderColumns::DATE],
                 items )

    end

  end

  private

  def self.verify_order_attributes( attributes )
    raise Errors::ProductCSVError.new, "Error loading orders csv." unless attributes[OrderColumns::CUSTOMER]
    raise Errors::ProductCSVError.new, "Error loading orders csv." unless attributes[OrderColumns::TAXES]
  end

  # Returns array of order items
  # == Example
  # [ { :product => product_object, :weight => 0.2, :observations=> "Whatever", :price => 3, :price_without_taxes => 2, :taxes => 1, :sub_products => [] },
  #   { :product => product_object, :weight => 0.6, :observations=> "Whatever2", :price => 4, :price_without_taxes => 3, :taxes => 2, :sub_products => [] } ]
  def self.get_order_items( product_attributes )
    Array.new
  end

end