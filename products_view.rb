$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

require 'product'

require 'tk'
require 'tkextlib/tile'

class ProductsView

  def initialize( args )
    @column_ids = [ 'name', 'price_shop', 'price_coope', 'price_pvp']
    @column_names = [ 'Nom', 'Preu Tenda', 'Preu Coope', 'Preu PVP']

    @tree = Tk::Tile::Treeview.new( args[:parent]) {
      columns 'name price_shop price_coope price_pvp'
    }

    font = Ttk::Style.lookup( @tree[:style], :font )

    @column_ids.zip( @column_names ).each{ |col, val|
      @tree.heading_configure( col, :text => val )
      @tree.column_configure( col, :width => TkFont.measure( font, val ) )
    }

    if Tk.windowingsystem != 'aqua'
      @v_scrollbar = @tree.yscrollbar(Ttk::Scrollbar.new(args[:parent]))
      @h_scrollbar = @tree.xscrollbar(Ttk::Scrollbar.new(args[:parent]))
    else
      @v_scrollbar = @tree.yscrollbar(Tk::Scrollbar.new(args[:parent]))
      @h_scrollbar = @tree.xscrollbar(Tk::Scrollbar.new(args[:parent]))
    end

    ## Code to insert the data nicely
    # root node in tree
    @tree.insert( '', 'end', :id => 'products', :text => 'Productes')

    # Expand (open) node. By default nodes are not open
    @tree.itemconfigure('products', 'open', true);

    # Insert nodes with product attributes as parent nodes of node with :id => 'products'
    args[:products].each{ | product |
      # Inserted as children of node with :id => 'products' (root node)
      @tree.insert( 'products', :end, :values => [ product.name, product.price_tienda, product.price_coope ] )

      # Set column size based on length of data
      # Extracted from ~/.rvm/src/ruby-2.1.1/ext/tk/sample/demos-en/widget
      @column_ids.zip( [product.name, product.price_tienda, product.price_coope] ).each{ | col, val |
        len = TkFont.measure( font, "#{ val }  ")
        if @tree.column_cget( col, :width ) < len
          @tree.column_configure( col, :width => len )
        end
      }
    }

  end

  def grid(args)
    # All widgets are divided into columns and rows
    # grid call makes the widget visible
    # :sticky => nw When expanding, align it to north west
    # :sticky => ew When expanding, align it to east west
    @tree.grid :column => args[:column], :row => args[:row], :sticky => 'nsew'
    @v_scrollbar.grid :column => args[:column] + 1, :row => args[:row], :sticky => 'ns'
    @h_scrollbar.grid :column => args[:column], :row => args[:row ] +1, :sticky => 'ew'
  end

end
