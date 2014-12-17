require 'tk'

require 'customer_helper'

class CustomerDialog

  # Widget that provides user with a combobox to chose
  # a customer from given @customers list
  def self.get_customer( parent, customers )
    top_level = TkToplevel.new( parent ) { title( 'Data de la comanda' ) }
    base_frame = TkFrame.new(top_level).pack( :fill=>:both, :expand => true )
    TkLabel.new(base_frame) {
      justify 'left'
      text 'Selecciona el client'
    }.pack( 'side' => 'left', 'padx'=>'.5c')

    TkFrame.new(base_frame) { |frame|
      customer_var = TkVariable.new
      @combobox = Tk::Tile::Combobox.new(parent) { textvariable customer_var }
      @combobox['values'] = CustomerHelper.names( customers )
    }.pack( 'fill'=> 'x', 'pady'=> '2m' )

    TkFrame.new(base_frame) { |frame|
      TkButton.new(frame) {
        text 'Cancelar'
        command proc {
          yield false
          tmppath = top_level
          top_level = nil
          tmppath.destroy
        }
      }.pack('side'=>'left', 'expand'=>'yes')

      TkButton.new(frame) {
        text 'Acceptar'
        command proc { yield @combobox.get
                       tmppath = top_level
                       top_level = nil
                       tmppath.destroy }

      }.pack( 'side' => 'left', 'expand'=> 'yes' )
    }.pack( 'side' => 'bottom', 'fill'=> 'x', 'pady'=> '2m' )
  end

end