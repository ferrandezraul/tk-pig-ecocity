require 'csv'
require 'customer'
require 'errors'

module CustomerColumns
  NAME = 0       # Name
  ADDRESS = 1    # Price
  TYPE = 2       # Price for cope
  NIF = 3       # Price for cope
end

class CustomerCSV
  #  Returns array of Customer attributes
  #  = Example
  #  customer = [
  #  {
  #    :name => "La Garrofa",
  #    :address => "c/ Pirelli 5, 08800 Vilanova i la Geltru",
  #    :type => "COOPE"
  #  }
  #]
  def self.read( file_path )

    raise "File not found #{file_path}" unless File.exist?(file_path)

    # By default separator is ","
    # CSV.read(file_path, { :col_sep => ';' })
    customers_array = CSV.read(file_path, encoding: "ISO8859-1")  # uses encoding: "ISO8859-1" to be able to read UTF8

    # Filter headers. Note that it is assumed that headers start with '#'
    customers_array.reject! { |customer_attributes| customer_attributes.first.start_with?("#") }

    # Raise exception if invalid attributes
    customers_array.each { |customer_attributes| verify_customer_attributes( customer_attributes) }

    # Returns new array with customers
    customers_array.map do |customer_attributes|
      Customer.new( :name => customer_attributes[CustomerColumns::NAME],
                    :address => customer_attributes[CustomerColumns::ADDRESS],
                    :type => customer_attributes[CustomerColumns::TYPE],
                    :nif => customer_attributes[CustomerColumns::NIF])
    end

  end

  private

  def self.verify_customer_attributes( attributes )
    raise Errors::CustomersCSVError.new, "Error loading customers csv. Nom de client invalid" unless attributes[CustomerColumns::NAME]
    raise Errors::CustomersCSVError.new, "Error loading customers csv. Addreca del client \"#{attributes[CustomerColumns::NAME]}\" invalid" unless attributes[CustomerColumns::ADDRESS]
    raise Errors::CustomersCSVError.new, "Error loading customers csv. Tipus del client \"#{attributes[CustomerColumns::NAME]}\" invalid" unless attributes[CustomerColumns::TYPE]
    raise Errors::CustomersCSVError.new, "Error loading customers csv. Tipus del client \"#{attributes[CustomerColumns::NAME]}\" invalid. Tipus ha de ser CLIENT, COOPE o TIENDA" unless attributes[CustomerColumns::TYPE] =~ /CLIENT|COOPE|TIENDA/
    raise Errors::CustomersCSVError.new, "Error loading customers csv. NIF invalid \"#{attributes[CustomerColumns::NIF]}\" invalid" unless attributes[CustomerColumns::NIF]
  end

end