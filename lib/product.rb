class Product
  attr_reader :name
  attr_reader :price_tienda
  attr_reader :price_coope
  attr_reader :price_pvp
  attr_reader :price_type
  attr_reader :iva
  attr_accessor :weight_per_unit
  attr_reader :observations
  attr_accessor :options    # List of products in case that product contains options to choose

  module PriceType
    POR_KILO = "EUR/KG"
    POR_UNIDAD = "EUR/UNIDAD"
  end

  def initialize(params)
    raise "Invalid price_type #{params[:price_type]}." unless validate_price_type?(params[:price_type])

    @name = params[:name]
    @price_tienda = params[:price_tienda]
    @price_coope = params[:price_coope]
    @price_pvp = params[:pvp]
    @weight_per_unit = params[:weight_per_unit]

    @iva = params[:iva]
    @observations = params[:observations]
    @options = params[:options]
  end

  def to_s
    # Align to the left with a size of 20 chars
    name_formatted = '%-20.20s' % @name

    if has_options?
      name_formatted << subproducts_to_s
    end

    name_formatted
  end

  # How to write your to_json method for your own classes
  # http://stackoverflow.com/questions/4775777/converting-a-custom-object-into-json-using-json-gem
  def to_json(*a)
    {
        :Product => { :name => @name,
                      :price_tienda=> @price_tienda,
                      :price_coope => @price_coope,
                      :price_pvp=> @price_pvp,
                      :price_type=> @price_type,
                      :iva=> @iva,
                      :observations=> @observations,
                      :options => @options,
                      :weight_per_unit => @weight_per_unit }
    }.to_json(*a)
  end

  def has_options?
    if @options
      if @options.any?
        return true
      end
    end

    false
  end

  private

  def subproducts_to_s
    subproducts_formatted = String.new

    if has_options?
      subproducts_formatted << "\n\tOpcions a escollir:\n"
      @options.each do |option|
        subproducts_formatted << "\t#{option.weight} Kg\t#{option.name}\n"
      end
    end

    subproducts_formatted
  end


  # Returns valid if price_type is either PriceType::POR_KILO or PriceType::POR_UNIDAD
  def validate_price_type?( price_type)
    valid = false

    if price_type.upcase == PriceType::POR_KILO
      @price_type = PriceType::POR_KILO
      valid = true
    elsif price_type.upcase == PriceType::POR_UNIDAD
      @price_type = PriceType::POR_UNIDAD
      valid = true
    else
      @price_type = PriceType::POR_KILO
      valid = false
    end

    valid
  end

end