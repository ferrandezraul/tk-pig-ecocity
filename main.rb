$:.unshift File.join( File.dirname( __FILE__ ), "lib" )

require 'tk'
require 'tkextlib/tile'

require 'product_csv'
require 'errors'

ORDERS_JSON_PATH = ::File.join( File.dirname( __FILE__ ), "csv/orders.json" )
PRODUCTS_CSV_PATH = ::File.join( File.dirname( __FILE__ ), "csv/products.csv" )
CUSTOMERS_CSV_PATH = ::File.join( File.dirname( __FILE__ ), "csv/customers.csv" )
ORDERS_CSV_PATH = ::File.join( File.dirname( __FILE__ ), "csv/orders.csv" )

def load_products
  begin
    ProductCSV.read( PRODUCTS_CSV_PATH )
  rescue Errors::ProductCSVError => e
    alert e.message
  end
end

def about_box
  Tk.messageBox('icon'=>'info', 'type'=>'ok', 'title'=>'About Ecocity Demo',
                'message'=> "Ecocity Demo\n\n" +
                    "Copyright:: (c) 2014 Raul Ferrandez / " +
                    "Your Ruby & Tk Version ::\n" +
                    "Ruby#{RUBY_VERSION}(#{RUBY_RELEASE_DATE})[#{RUBY_PLATFORM}] / Tk#{$tk_patchlevel}#{(Tk::JAPANIZED_TK)? '-jp': ''}\n\n" +
                    "Ruby/Tk release date :: tcltklib #{TclTkLib::RELEASE_DATE}; tk #{Tk::RELEASE_DATE}")
end

def see_products
  Tk.messageBox('icon'=>'info', 'type'=>'ok', 'title'=>'Productes', 'message'=> "Todo ..." )
end

def see_customers
  Tk.messageBox('icon'=>'info', 'type'=>'ok', 'title'=>'About Ecocity Demo', 'message'=> "To do ..." )
end

########################################## Start here ##################################################################

products = load_products

# root
$root = TkRoot.new{ title "Porc Ecocity" }


# See tk/menuspec.rb for menu_spec.
# http://www.ruby-doc.org/stdlib-2.0/libdoc/tk/rdoc/TkMenuSpec.html
menu_spec = [
              [
                [ 'File', 0 ],
                [ 'About ... ', proc{about_box}, 0, '<F1>' ],
                [ 'Quit', proc{exit}, 0, 'Ctrl-Q' ]
              ],
              [
                [ 'Productes', 0 ],
                [ 'Veure Productes', proc{ see_products } ]
              ],
              [
                ['Clients', 0],
                ['Veure Clients', proc{ see_customers } ]
              ]
            ]

# TkRoot::add_menubar(menu_spec, tearoff=false, opts=nil) click to tog)
# opts is a hash of default configs for all of cascade menus.
# Configs of menu_spec can override it.
$root.add_menubar( menu_spec )

$frame = Tk::Tile::Frame.new($root) { padding "3 3 12 12" }.grid( :sticky => 'nsew')
TkGrid.columnconfigure $root, 0, :weight => 1; TkGrid.rowconfigure $root, 0, :weight => 1

label = Tk::Tile::Label.new($frame) { text 'Products:' }

tree = Tk::Tile::Treeview.new($frame) { columns 'name description price' }
tree.heading_configure( 'name', :text => 'Nom')
tree.heading_configure( 'description', :text => 'Descripcio')
tree.heading_configure( 'price', :text => 'Preu')

# For iOS
if Tk.windowingsystem != 'aqua'
  vsb = tree.yscrollbar(Ttk::Scrollbar.new($frame))
  hsb = tree.xscrollbar(Ttk::Scrollbar.new($frame))
else  # Linux, win
  vsb = tree.yscrollbar(Tk::Scrollbar.new($frame))
  hsb = tree.xscrollbar(Tk::Scrollbar.new($frame))
end

Tk.grid(label,     :in=>$frame, :sticky=>'nsew')
Tk.grid(tree, vsb, :in=>$frame, :sticky=>'nsew')
Tk.grid(hsb,       :in=>$frame, :sticky=>'nsew')

## Code to insert the data nicely
products.each{ | product |
  tree.insert( '', :end, :values=>[ product.name, product.price_tienda, product.price_coope] )
}

##############

#TkEcocityManager.new( :tkroot => $root, :products => products )

# Display children widgets from frame
#TkWinfo.children($frame).each {|w| TkGrid.configure w, :padx => 5, :pady => 5}

# start eventloop
Tk.mainloop