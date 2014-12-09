require 'tk'

def aboutBox
  Tk.messageBox('icon'=>'info', 'type'=>'ok', 'title'=>'About Ecocity Demo',
                'message'=> "Ecocity Demo\n\n" +
                    "Copyright:: (c) 2014 Raul Ferrandez / " +
                    "Your Ruby & Tk Version ::\n" +
                    "Ruby#{RUBY_VERSION}(#{RUBY_RELEASE_DATE})[#{RUBY_PLATFORM}] / Tk#{$tk_patchlevel}#{(Tk::JAPANIZED_TK)? '-jp': ''}\n\n" +
                    "Ruby/Tk release date :: tcltklib #{TclTkLib::RELEASE_DATE}; tk #{Tk::RELEASE_DATE}")
end

def seeProducts
  Tk.messageBox('icon'=>'info', 'type'=>'ok', 'title'=>'Productes', 'message'=> "Todo ..." )
end

def seeCustomers
  Tk.messageBox('icon'=>'info', 'type'=>'ok', 'title'=>'About Ecocity Demo', 'message'=> "To do ..." )
end

########################################################################################################################
########################################## Start here ##################################################################
########################################################################################################################

# root
$root = TkRoot.new{ title "Porc Ecocity" }


# See tk/menuspec.rb for menu_spec.
# http://www.ruby-doc.org/stdlib-2.0/libdoc/tk/rdoc/TkMenuSpec.html
menu_spec = [
              [
                [ 'File', 0 ],
                [ 'About ... ', proc{aboutBox}, 0, '<F1>' ],
                '---',
                [ 'Quit', proc{exit}, 0, 'Ctrl-Q' ]
              ],
              [
                [ 'Productes', 0 ],
                [ 'Veure Productes', proc{ seeProducts } ]
              ],
              [
                ['Clients', 0],
                ['Veure Clients', proc{ seeCustomers } ]
              ]
            ]

# TkRoot::add_menubar(menu_spec, tearoff=false, opts=nil) click to tog)
# opts is a hash of default configs for all of cascade menus.
# Configs of menu_spec can override it.
$root.add_menubar( menu_spec )




# start eventloop
Tk.mainloop