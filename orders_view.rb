$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

require 'order'

require 'tk'
require 'tkextlib/tile'

class OrdersView
  COLUMN_IDS = %w( date customer_name customer_address order_items total )
  COLUMN_NAMES = [ 'Data', 'Client', 'Adreça', 'Productes', 'TOTAL']
  ROOT_TREE_NODE_ID = 'Comandes'

  # Draws a Tree displaying customer attributes
  # args[:parent] Parent Tk widget
  # args[:customers] List of customers
  def initialize( args )
    @orders = args[:orders] || Array.new

    @tree = Tk::Tile::Treeview.new( args[:parent] )

    set_headers

    create_scrollbars( args[:parent] )

    insert_data( @orders )

    # Expand (open) node. By default nodes are not open
    @tree.itemconfigure( @root_tree_node.id, 'open', true)
  end

  def grid( args )
    # All widgets are divided into columns and rows
    # grid call makes the widget visible
    # :sticky => nw When expanding, align it to north west
    # :sticky => ew When expanding, align it to east west
    @tree.grid :column => args[:column], :row => args[:row], :sticky => 'nsew'
    @v_scrollbar.grid :column => args[:column] + 1, :row => args[:row], :sticky => 'ns'
    @h_scrollbar.grid :column => args[:column], :row => args[:row ] +1, :sticky => 'ew'
  end

  def set_headers
    # Set column id's
    @tree['columns'] = COLUMN_IDS

    # Array.zip( array )
    # a = [ 4, 5, 6 ]
    # b = [ 7, 8, 9 ]
    # [ 1, 2, 3 ].zip( a, b ) #=> [ [1, 4, 7], [2, 5, 8], [3, 6, 9] ]
    COLUMN_IDS.zip( COLUMN_NAMES ).each{ |col, val|
      # Set heading in columns
      @tree.heading_configure( col, :text => val )

      # anchor => String
      # Alignment. Must be one of the values n, ne, e, se, s, sw, w, nw, or center.
      @tree.column_configure( col, :anchor => 'e' )
    }
  end

  def create_scrollbars( parent )
    if Tk.windowingsystem != 'aqua'
      @v_scrollbar = @tree.yscrollbar(Ttk::Scrollbar.new( parent ) )
      @h_scrollbar = @tree.xscrollbar(Ttk::Scrollbar.new( parent ) )
    else
      @v_scrollbar = @tree.yscrollbar(Tk::Scrollbar.new( parent ) )
      @h_scrollbar = @tree.xscrollbar(Tk::Scrollbar.new( parent ) )
    end
  end

  def insert_data( orders )
    ## Code to insert the data nicely
    # root node in tree
    @root_tree_node = @tree.insert( nil, 'end', :text => ROOT_TREE_NODE_ID )

    # Insert nodes with order attributes as parent nodes of node with :id => 'comandes'
    orders.each{ | order |
      # Inserted as children of node with :id => @tree_root_id (root node)
      @tree.insert( @root_tree_node, :end, :values => [ order.date,
                                                        order.customer.name,
                                                        order.customer.address,
                                                        order.order_items,
                                                        order.total ] )
    }
  end

end
