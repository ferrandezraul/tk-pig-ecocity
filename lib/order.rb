require 'product'
require 'customer'

class Order
  attr_reader :customer
  attr_reader :order_items
  attr_reader :date
  attr_reader :total
  attr_reader :total_without_taxes
  attr_reader :taxes
  attr_reader :taxes_hash

  def initialize(customer, date, order_items=[])
    @customer = customer
    @order_items = order_items.dup
    @date = date
    @total = 0
    @total_without_taxes = 0
    @taxes = 0
    @taxes_hash = Hash.new

    calculate
  end

  def <<(order_item)
    @order_items << order_item
    calculate
  end

  def delete(order_item)
    @order_items.delete(order_item)
    calculate
  end

  def to_s
    items = String.new

    if @order_items.any?
      items << "Productes: \n"
      @order_items.each_with_index do |item, index |
        items << "#{item.to_s}"

        items << "\n" if index != @order_items.size - 1
      end
    end

    result = String.new

    result << "#{@date.to_s} #{@customer.name} #{@customer.nif}" << "\n"
    result << "#{@customer.address}" << "\n"
    result << "\n"
    result << "#{ items }" << "\n"
    result << "\n"

    @taxes_hash.each do |key, value|
      result << "IVA #{key}% #{ '%.2f' % value } EUR\n"
    end

    result << "\n"
    result << "IVA TOTAL = #{ '%.2f' % @taxes } EUR" << "\n"
    result << "TOTAL (Sense IVA) = #{ '%.2f' %@total_without_taxes} EUR" << "\n"
    result << "\n"
    result << "TOTAL = #{ '%.2f' % @total } EUR"

  end

  # How to write your to_json method for your own classes
  # http://stackoverflow.com/questions/4775777/converting-a-custom-object-into-json-using-json-gem
  def to_json(*a)
    {
        :Order => { :customer => @customer,
                    :date => @date,
                    :total => @total,
                    :total_without_taxes => @total_without_taxes,
                    :taxes => @taxes,
                    :taxes_hash => @taxes_hash,
                    :order_items => @order_items }
    }.to_json(*a)
  end

  # Returns number of times a product has been ordered
  def times_ordered( product_name )
    ordered = 0
    @order_items.each do |item|
      if item.product.name == product_name
        ordered += 1
      end
    end
    ordered
  end

  # Returns number of times a product has been ordered
  def kg_ordered( product_name )
    ordered = 0
    @order_items.each do |item|
      if item.product.name == product_name
        ordered += item.weight
      end
    end
    ordered
  end

  # Returns number of times a product has been ordered
  def euros_ordered( product_name )
    euros_ordered = 0
    @order_items.each do |item|
      if item.product.name == product_name
        euros_ordered += item.price
      end
    end
    euros_ordered
  end

  def calculate
    @total = 0
    @total_without_taxes = 0
    @taxes = 0
    @taxes_hash = Hash.new

    @order_items.each do |item|
      @total += item.price
      @total_without_taxes += item.price_without_taxes
      @taxes += item.taxes

      # Store all taxes separately. i.e. 10%, 4%
      # == Example
      # @taxes_hash = { 10 => 250, 4 => 37 }
      if @taxes_hash.has_key?(item.product.iva)
        @taxes_hash[item.product.iva] += item.taxes
      else
        @taxes_hash[item.product.iva] = item.taxes
      end
    end
  end

  def self.attributes_valid?( customer, product, quantity, peso )
    begin
      !Float(quantity)
    rescue
      alert "Quantitat ha de ser un numero"
      return false
    end

    if !product.has_options?
      begin
        !Float(peso)
      rescue
        alert "Pes ha de ser un numero en kg"
        return false
      end
    end

    if quantity.to_i <= 0
      alert "Quantitat ha de ser mes gran que 0"
      return false
    end
    if product.nil?
      alert "Selecciona un producte."
      return false
    end
    if customer.nil?
      alert "Selecciona un client"
      return false
    end
    if customer.name.empty?
      alert "Selecciona un client"
      return false
    end
    true
  end

end