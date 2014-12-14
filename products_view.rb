$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

require 'product'

require 'tk'
require 'tkextlib/tile'

class ProductsView

  def initialize( args )
    @tree = Tk::Tile::Treeview.new( args[:parent]) {
      columns 'name price_tienda price_coope'

    }

    font = Ttk::Style.lookup( @tree[:style], :font )
    cc = %w( name price_tienda price_coope )
    cc.each{ |name|
      @tree.heading_configure( name, :text => name,
                             :command => proc{ sort_by( @tree, name, false ) } )

      @tree.column_configure( name, :width => TkFont.measure( font, name ) )
    }

    if Tk.windowingsystem != 'aqua'
      @v_scrollbar = @tree.yscrollbar(Ttk::Scrollbar.new(args[:parent]))
      @h_scrollbar = @tree.xscrollbar(Ttk::Scrollbar.new(args[:parent]))
    else
      @v_scrollbar = @tree.yscrollbar(Tk::Scrollbar.new(args[:parent]))
      @h_scrollbar = @tree.xscrollbar(Tk::Scrollbar.new(args[:parent]))
    end

    ## Code to insert the data nicely
    args[:products].each{ | product |
      @tree.insert( nil, :end, :values => [ product.name, product.price_tienda, product.price_coope ] )
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

  ## Code to do the sorting of the tree contents when clicked on
  def sort_by(tree, col, direction)
    @tree.children( nil ).map!{ |row| [@tree.get( row, col ), row.id] } .
        sort( &( (direction)? proc{ |x, y| y <=> x}: proc{ |x, y| x <=> y } ) ) .
        each_with_index{ | info, idx | @tree.move( info[1], nil, idx) }

    @tree.heading_configure(col, :command => proc{ sort_by( tree, col, ! direction ) } )
  end

end
