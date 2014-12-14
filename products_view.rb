$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

require 'product'

require 'tk'
require 'tkextlib/tile'

class ProductsView

  def initialize( args )
    @tree = Tk::Tile::Treeview.new( args[:parent]) {
      columns 'name description price'
    }

    @tree.heading_configure( 'name', :text => 'Nom')
    @tree.heading_configure( 'description', :text => 'Descripció')
    @tree.heading_configure( 'price', :text => 'Preu')

    if Tk.windowingsystem != 'aqua'
      @v_scrollbar = @tree.yscrollbar(Ttk::Scrollbar.new(args[:parent]))
      @h_scrollbar = @tree.xscrollbar(Ttk::Scrollbar.new(args[:parent]))
    else
      @v_scrollbar = @tree.yscrollbar(Tk::Scrollbar.new(args[:parent]))
      @h_scrollbar = @tree.xscrollbar(Tk::Scrollbar.new(args[:parent]))
    end

    ## Code to insert the data nicely
    args[:products].each{ | product |
      @tree.insert( '', :end, :values => [ product.name, product.price_tienda, product.price_coope ] )
    }
  end

  def grid
    # All widgets are divided into columns and rows
    # grid call makes the widget visible
    # :sticky => nw When expanding, align it to north west
    # :sticky => ew When expanding, align it to east west
    @tree.grid :column => 0, :row => 2, :sticky => 'nsew'
    @v_scrollbar.grid :column => 1, :row => 2, :sticky => 'ns'
    @h_scrollbar.grid :column => 0, :row => 3, :sticky => 'ew'
  end


end
