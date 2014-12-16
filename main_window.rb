$:.unshift File.join( File.dirname( __FILE__ ), "lib" )
$:.unshift File.join( File.dirname( __FILE__ ), "." )

require 'tk'
require 'tkextlib/tile'

require 'products_view'
require 'customers_view'
require 'orders_view'

class MainWindow

  def initialize(args)
    @products = args[:products] || Array.new
    @customers = args[:customers] || Array.new
    @orders = args[:orders] || Array.new

    # root
    @root = TkRoot.new{ title "Porc Ecocity" }

    # TkRoot::add_menubar(menu_spec, tearoff=false, opts=nil) click to tog)
    # opts is a hash of default configs for all of cascade menus.
    # Configs of menu_spec can override it.
    @root.add_menubar( menu_spec )

    @content = Tk::Tile::Frame.new(@root)

    @notebook = Tk::Tile::Notebook.new(@content)

    @products_page = Tk::Tile::Frame.new( @notebook )   # first page, which would get widgets gridded into it
    @customers_page = Tk::Tile::Frame.new( @notebook )  # second page
    @orders_page = Tk::Tile::Frame.new( @notebook )     # third page

    @products_view =  ProductsView.new( :parent => @products_page,
                                        :products => @products )
    @customers_view = CustomersView.new( :parent => @customers_page,
                                         :customers => @customers )
    @orders_view = OrdersView.new( :parent => @orders_page,
                                   :orders => @orders )

    @notebook.add @products_page, :text => 'Products', :sticky => 'nswe'
    @notebook.add @customers_page, :text => 'Customers', :sticky => 'nswe'
    @notebook.add @orders_page, :text => 'Comandes', :sticky => 'nswe'

    @notebook.enable_traversal

    # Draw widgets in grid
    grid

    # start eventloop
    Tk.mainloop
  end

  private

  def menu_spec
    # See tk/menuspec.rb for menu_spec.
    # http://www.ruby-doc.org/stdlib-2.0/libdoc/tk/rdoc/TkMenuSpec.html
    [
        [
            [ 'Ecocity', 0 ],
            [ 'About ... ', proc{about_box}, 0, '<F1>' ],
            [ 'Sortir', proc{ exit }, 0, 'Ctrl-Q' ]
        ],
        [
            [ 'Productes', 0 ],
            [ 'Veure Productes', proc{ @notebook.select( @products_page ) } ]
        ],
        [
            ['Clients', 0],
            ['Veure Clients', proc{ @notebook.select( @customers_page ) } ]
        ],
        [
            ['Comandes', 0],
            ['Veure Comandes', proc{ @notebook.select( @orders_page ) } ],
            ['Nova Comanda', proc{ new_order } ]
        ]
    ]
  end

  def new_order
    date_dialog = TkToplevel.new( @root ) {|w|
      title( "Data de la comanda" )
    }
    base_frame = TkFrame.new(date_dialog).pack( :fill=>:both, :expand => true )
    msg = TkLabel.new(base_frame) {
      justify 'left'
      text "Selecciona la data de la comanda"
    }
    msg.pack('side'=>'top', 'padx'=>'.5c')

    TkFrame.new(base_frame) {|frame|
      TkButton.new(frame) {
        text 'Cancelar'
        command proc {
          tmppath = date_dialog
          date_dialog = nil
          tmppath.destroy
        }
      }.pack('side'=>'left', 'expand'=>'yes')

      TkButton.new(frame) {
        text 'Acceptar'
        command proc { Tk.messageBox('icon'=>'info', 'type'=>'ok', 'title'=>'About Ecocity Demo', 'message'=> "Catched date")
                       tmppath = date_dialog
                       date_dialog = nil
                       tmppath.destroy }

      }.pack( 'side' => 'left', 'expand'=> 'yes' )
    }.pack( 'side' => 'bottom', 'fill'=> 'x', 'pady'=> '2m' )
  end

  def about_box
    Tk.messageBox('icon'=>'info', 'type'=>'ok', 'title'=>'About Ecocity Demo',
                  'message'=> "Ecocity Demo\n\n" +
                  "Copyright:: (c) 2014 Raul Ferrandez / " +
                  "Your Ruby & Tk Version ::\n" +
                  "Ruby#{RUBY_VERSION}(#{RUBY_RELEASE_DATE})[#{RUBY_PLATFORM}] / Tk#{$tk_patchlevel}#{(Tk::JAPANIZED_TK)? '-jp': ''}\n\n" +
                  "Ruby/Tk release date :: tcltklib #{TclTkLib::RELEASE_DATE}; tk #{Tk::RELEASE_DATE}")
  end

  def grid
    # All widgets are divided into columns and rows
    # grid call makes the widget visible
    # :sticky => nw When expanding, align it to north west
    # :sticky => ew When expanding, align it to east west
    @content.grid :column => 0, :row => 0, :sticky => 'nsew'
    @notebook.grid :column => 0, :row => 0, :sticky => 'nsew'
    @products_view.grid :column => 0, :row => 0
    @customers_view.grid :column => 0, :row => 0
    @orders_view.grid :column => 0, :row => 0

    # How expand is handled
    # :weight => 1 expand widget when changing size
    # Expand columns and rows with root
    TkGrid.columnconfigure @root, 0, :weight => 1; TkGrid.rowconfigure @root, 0, :weight => 1

    TkGrid.columnconfigure @content, 0, :weight => 1; TkGrid.rowconfigure @content, 0, :weight => 1

    TkGrid.columnconfigure @products_page, 0, :weight => 1; TkGrid.rowconfigure( @products_page, 0, :weight => 1 )
    TkGrid.columnconfigure @customers_page, 0, :weight => 1; TkGrid.rowconfigure( @customers_page, 0, :weight => 1 )
    TkGrid.columnconfigure @orders_page, 0, :weight => 1; TkGrid.rowconfigure( @orders_page, 0, :weight => 1 )
  end

end
