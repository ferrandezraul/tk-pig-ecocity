require 'csv'
require 'product'
require 'subproduct'
require 'errors'

require 'product_helper'

module Columns
  NAME = 0                # Name
  PRICE_TIENDA = 1        # Price (with taxes)
  PRICE_COOPE = 2         # Price for cope
  PVP = 3                 # PVP
  IVA = 4                 # IVA
  TIPO = 5                # Tipo de precio (por_unidad o por_kilo)
  PESO_APROX_UNIDAD = 6   # Tipo de precio (por_unidad o por_kilo)
  OBSERVATIONS = 7        # Observations
  SUBPRODUCTS = 8         # Sub-products
end

class ProductCSV
  #  Returns array of Product attributes
  #  = Example
  #  products = [
  #  {
  #    :name => "Costelles (0.3 kg)",
  #    :price => 8.50,
  #    :price_coope => 9.50,
  #    :pvp => 10.50,
  #    :observations => "Cuits o sense coure",
  #    :subproducts => []                       # [ { :weight => 0,5, :name => "Llom", :product => product_object_llom },
  #                                                 { :weight => 0,4, :name => "Carn picada", :product => product_object_carn_picada } ]
  #  }
  #]
  def self.read( file_path )

    raise "File not found #{file_path}" unless File.exist?(file_path)

    # By default separator is ","
    # CSV.read(file_path, { :col_sep => ';' })
    products_attributes_list = CSV.read(file_path, encoding: "ISO8859-1")  # uses encoding: "ISO8859-1" to be able to read UTF8

    # Filter headers. Note that it is assumed that headers start with '#'
    products_attributes_list.reject! { |product_attributes| product_attributes.first.start_with?("#") }

    products_attributes_list.each { |product_attributes| verify_product_attributes( product_attributes ) }

    # Returns new array with product objects
    products_list = products_attributes_list.map do |product_attributes|
      subproducts = get_subproducts_attributes( product_attributes )

      Product.new( :name => product_attributes[Columns::NAME],
                   :price_tienda => product_attributes[Columns::PRICE_TIENDA].to_f,
                   :price_coope => product_attributes[Columns::PRICE_COOPE].to_f,
                   :pvp => product_attributes[Columns::PVP].to_f,
                   :iva => product_attributes[Columns::IVA].to_i,
                   :price_type => product_attributes[Columns::TIPO],
                   :weight_per_unit => validate_weight_per_unit(product_attributes[Columns::PESO_APROX_UNIDAD]),
                   :observations => product_attributes[Columns::OBSERVATIONS],
                   :options => subproducts )

    end

    products_list.each do |product|
      if !product.options.empty?
        subproducts_list = product.options
        subproducts_list.each do |subproduct|
          real_product = ProductHelper.find_product_with_name( products_list, subproduct.name )
          raise "Subproduct not found #{subproduct.name} in product #{product.name}" unless real_product
        end
      end
    end

  end

  private

  def self.validate_weight_per_unit(weight_per_unit)
    if weight_per_unit
      return weight_per_unit.to_f
    else
      return 0
    end
  end

  def self.verify_product_attributes( attributes )
    raise Errors::ProductCSVError.new, "Error loading csv. Nom de producte invalid" unless attributes[Columns::NAME]
    raise Errors::ProductCSVError.new, "Error loading csv. Preu tenda del producte #{attributes[Columns::NAME]} invalid" unless attributes[Columns::PRICE_TIENDA]
    raise Errors::ProductCSVError.new, "Error loading csv. Preu coope del producte #{attributes[Columns::NAME]} invalid" unless attributes[Columns::PRICE_COOPE]
    raise Errors::ProductCSVError.new, "Error loading csv. Preu PVP del producte   #{attributes[Columns::NAME]} invalid" unless attributes[Columns::PVP]
    raise Errors::ProductCSVError.new, "Error loading csv. IVA del producte   #{attributes[Columns::NAME]} invalid" unless attributes[Columns::IVA]
    raise Errors::ProductCSVError.new, "Error loading csv. Tipus de preu del producte #{attributes[Columns::NAME]} invalid" unless attributes[Columns::TIPO]
  end

  def self.has_subproducts?( product_attributes )
    if product_attributes[Columns::SUBPRODUCTS]
      return true
    end

    return false
  end

  # Returns array of hashes
  # == Example
  # [ { :weight => 0,5, :name => "Llom", :product => product_object_llom },
  #   { :weight => 0,4, :name => "Carn picada", :product => product_object_carn_picada } ]
  def self.get_subproducts_attributes( product_attributes )
    subproducts = []
    if !has_subproducts?( product_attributes )
      return subproducts
    end

    # Read all subproducts and add them to
    i = 0
    while product_attributes[Columns::SUBPRODUCTS + i]
      subproduct_weight = product_attributes[Columns::SUBPRODUCTS + i]
      subproduct_name = product_attributes[Columns::SUBPRODUCTS + i + 1]

      # example, if subproduct_name="Botifarra|Costelles"
      # names contains ["Botifarra","Costelles"]
      names = split_subproducts_names( subproduct_name )

      names.each do |name|
        subproducts << SubProduct.new( :name => name,
                                       :weight => subproduct_weight,
                                       :quantity => 1 )
      end

      i += 2
    end

    subproducts
  end

  # Returns list of product names included in name and separated by '|'
  # == Example
  # name = "Botifarra|Costelles"
  # split_subproducts_names( name )
  # returns ["Botifarra","Costelles"]
  def self.split_subproducts_names( name )
    names = []
    if name.include?("|")
      names = name.split("|")
    else
      names << name
    end
  end

end