$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

require 'product'
require 'subproduct'

require 'tk'
require 'tkextlib/tile'

class ProductsView
  COLUMN_IDS = %w( name price_shop price_coope price_pvp iva price_type )
  COLUMN_NAMES = [ 'Nom', 'Preu Tenda', 'Preu Coope', 'Preu PVP', 'IVA', 'Tipus']
  ROOT_TREE_NODE_ID = 'Productes'

  def initialize( args )
    @tree = Tk::Tile::Treeview.new( args[:parent] )

    # Set column id's
    @tree['columns'] = COLUMN_IDS

    # Get font
    font = Ttk::Style.lookup( @tree[:style], :font )

    # Array.zip( array )
    # a = [ 4, 5, 6 ]
    # b = [ 7, 8, 9 ]
    # [ 1, 2, 3 ].zip( a, b ) #=> [ [1, 4, 7], [2, 5, 8], [3, 6, 9] ]
    #
    # Set headers in columns
    COLUMN_IDS.zip( COLUMN_NAMES ).each{ |col, val|
      @tree.heading_configure( col, :text => val )
      # anchor => String
      # Alignment. Must be one of the values n, ne, e, se, s, sw, w, nw, or center.
      @tree.column_configure( col, :width => TkFont.measure( font, val ), :anchor => 'e' )
    }

    # Create scrollbars
    if Tk.windowingsystem != 'aqua'
      @v_scrollbar = @tree.yscrollbar(Ttk::Scrollbar.new(args[:parent]))
      @h_scrollbar = @tree.xscrollbar(Ttk::Scrollbar.new(args[:parent]))
    else
      @v_scrollbar = @tree.yscrollbar(Tk::Scrollbar.new(args[:parent]))
      @h_scrollbar = @tree.xscrollbar(Tk::Scrollbar.new(args[:parent]))
    end

    ## Code to insert the data nicely
    # root node in tree
    @root_tree_node = @tree.insert( nil, 'end', :text => ROOT_TREE_NODE_ID )

    # Expand (open) node. By default nodes are not open
    @tree.itemconfigure( @root_tree_node.id, 'open', true);

    # Insert nodes with product attributes as parent nodes of node with :id => 'products'
    args[:products].each{ | product |
      product_columns = [ product.name,
                          "#{ product.price_tienda } EUR",
                          "#{ product.price_coope } EUR",
                          "#{ product.price_pvp } EUR",
                          "#{ product.iva } %",
                          product.price_type ]

      # Inserted as children of node with :id => @tree_root_id (root node)
      product_item = @tree.insert( @root_tree_node, :end, :values => product_columns )

      product.options.each_with_index { |option, index|
        option = "#{option.quantity} x #{option.weight} Kg #{option.name}"
        option_columns = [ option ]
        @tree.insert( product_item, 'end', :text => "Opció #{index + 1}", :values => option_columns )
      } if product.has_options?


      # Set column size based on length of data
      # Extracted from /.rvm/src/ruby-2.1.1/ext/tk/sample/demos-en/widget
      COLUMN_IDS.zip( product_columns ).each{ | col, val |
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
