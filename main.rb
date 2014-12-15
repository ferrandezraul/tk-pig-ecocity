$:.unshift File.join( File.dirname( __FILE__ ), "lib" )
$:.unshift File.join( File.dirname( __FILE__ ), "." )

require 'product_csv'
require 'customers_csv'
require 'errors'
require 'main_window'

ORDERS_JSON_PATH = ::File.join( File.dirname( __FILE__ ), "csv/orders.json" )
PRODUCTS_CSV_PATH = ::File.join( File.dirname( __FILE__ ), "csv/products.csv" )
CUSTOMERS_CSV_PATH = ::File.join( File.dirname( __FILE__ ), "csv/customers.csv" )
ORDERS_CSV_PATH = ::File.join( File.dirname( __FILE__ ), "csv/orders.csv" )

def load_products
  begin
    ProductCSV.read( PRODUCTS_CSV_PATH )
  rescue Errors::ProductCSVError => e
    alert e.message
  end
end

def load_customers
  begin
    CustomerCSV.read( CUSTOMERS_CSV_PATH )
  rescue Errors::CustomersCSVError => e
    alert e.message
  end
end

products = load_products
customers = load_customers

MainWindow.new( :products => products,
                :customers => customers )

