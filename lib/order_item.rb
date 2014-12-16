require 'product'
require 'customer'

class OrderItem
  attr_reader :product
  attr_reader :product_options  # Only for lots (A list of SubProduct objects)
  attr_reader :quantity
  attr_reader :weight
  attr_reader :observations
  attr_reader :price
  attr_reader :price_without_taxes
  attr_reader :taxes

  def initialize(customer, product, quantity, weight, observations, sub_products)
    @product = product
    @quantity = quantity
    @weight = weight
    @observations = observations
    @product_options = sub_products.dup
    @price = 0
    @taxes = 0
    @price_without_taxes = 0

    calculate_price(customer.type)
  end

  def to_s
    item_to_s + observations_to_s + product_options_to_s
  end

  # How to write your to_json method for your own classes
  # http://stackoverflow.com/questions/4775777/converting-a-custom-object-into-json-using-json-gem
  def to_json(*a)
    {
        :OrderItem => { :product => @product,
                        :quantity => @quantity,
                        :weight => @weight,
                        :observations => @observations,
                        :price => @price,
                        :price_without_taxes => @price_without_taxes,
                        :taxes => @taxes,
                        :product_options => @product_options }
    }.to_json(*a)
  end

  def item_to_s
    if @weight.to_f == 0.0
      "#{@quantity.to_i} x #{@product.name} = #{'%.2f' % @price_without_taxes.to_f} EUR + #{@product.iva}% IVA = #{'%.2f' % @price.to_f} EUR"
    else
      "#{@quantity.to_i} x #{'%.3f' % @weight.to_f} kg #{@product.name} = #{'%.2f' % @price_without_taxes.to_f} EUR + #{@product.iva}% IVA = #{'%.2f' % @price.to_f} EUR"
    end
  end

  def product_options_to_s
    sub_string = String.new
    if !@product_options.empty?
      @product_options.each_with_index do |subproduct, index|
        sub_string << "\t#{subproduct.quantity} x #{subproduct.weight} kg #{subproduct.name}"

        # Do not add new line in last iteration
        sub_string << "\n" if index != @product_options.size - 1
      end
    end

    sub_string
  end

  private

  def calculate_price(customer_type)
    raise "Wrong customer type found" unless customer_type =~ /CLIENT|COOPE|TIENDA/

    if @product.price_type == Product::PriceType::POR_UNIDAD
      calculate_price_based_on_units(customer_type)
    else
      calculate_price_based_on_weight(customer_type)
    end

    calculate_taxes
  end

  def calculate_price_based_on_weight(customer_type)
    case customer_type
      when "CLIENT"
        @price = @quantity * @weight.to_f * @product.price_pvp.to_f
      when "COOPE"
        @price = @quantity * @weight.to_f * @product.price_coope.to_f
      when "TIENDA"
        @price = @quantity * @weight.to_f * @product.price_tienda.to_f
      else
        @price = 0
    end
  end

  def calculate_price_based_on_units(customer_type)
    case customer_type
      when "CLIENT"
        @price = @quantity * @product.price_pvp.to_f
      when "COOPE"
        @price = @quantity * @product.price_coope.to_f
      when "TIENDA"
        @price = @quantity * @product.price_tienda.to_f
      else
        @price = 0
    end
  end

  def calculate_taxes
    @taxes = ( @price * @product.iva ) / ( 100 + @product.iva )
    @price_without_taxes = @price - @taxes
  end

  def observations_to_s
    if @observations.empty?
      String.new
    else
      "\nObservacions: #{@observations.to_s}"
    end
  end

end