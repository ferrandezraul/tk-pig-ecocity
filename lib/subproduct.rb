class SubProduct
  attr_reader :name
  attr_reader :weight
  attr_reader :quantity

  def initialize(params)
    @name = params[:name]
    @weight = params[:weight]
    @quantity = params[:quantity]
  end

  def to_s
    "#{@quantity} x #{@weight} #{@name}"
  end

  # How to write your to_json method for your own classes
  # http://stackoverflow.com/questions/4775777/converting-a-custom-object-into-json-using-json-gem
  def to_json(*a)
    {
        :SubProduct => { :name => @name,
                         :weight => @weight,
                         :quantity => @quantity  }
    }.to_json(*a)
  end

end