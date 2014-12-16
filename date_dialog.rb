require 'tk'
require 'date'

class DateDialog

  def self.get_date( parent )
    date_dialog = TkToplevel.new( parent ) { title( 'Data de la comanda' ) }
    base_frame = TkFrame.new(date_dialog).pack( :fill=>:both, :expand => true )
    TkLabel.new(base_frame) {
      justify 'left'
      text 'Selecciona la data de la comanda'
    }.pack( 'side' => 'left', 'padx'=>'.5c')

    date = TkVariable.new( Date.today )
    TkFrame.new(base_frame) { |frame|
      Tk::Tile::Entry.new(frame) { textvariable date }.pack( 'expand' => 'yes' )
    }.pack( 'fill'=> 'x', 'pady'=> '2m' )

    TkFrame.new(base_frame) { |frame|
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
        command proc { yield date
                       tmppath = date_dialog
                       date_dialog = nil
                       tmppath.destroy }

      }.pack( 'side' => 'left', 'expand'=> 'yes' )
    }.pack( 'side' => 'bottom', 'fill'=> 'x', 'pady'=> '2m' )
  end

end