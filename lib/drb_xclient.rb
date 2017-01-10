require_relative "loaded.rb"

module CliDrb 
    include XDRbServerObj 

    def current_port 
        Param::XCLIENT[:port]
    end
    def monit_port
        Loaded.ld_base( MONITSERVER )[:port] 
    end

    dt, myconf = [ ( Load.get_monitorize :detectconf ).call.keys.first, ( Load.get_monitorize :cliconf ).call ]

    MONITSERVER = myconf.keys.map{ |k| myconf[k].keys }.flatten.first

    CLICONF = Loaded.ld_cliconf( :"#{ myconf.keys.first }" )[MONITSERVER].any?
    CONF200 = Loaded.ld_detectconf( :"#{dt}" )[ :BaseX200 ].any?
    CONF302 = ( Loaded.ld_detectconf( :"#{dt}" )[ :BaseX302 ].any? || Configs::REACT_302 )

    private
    p, t  = nil
    Object.const_set :Tuple, Struct.new( :tuple  ) 
    define_method :obj_take do t ||= Tuple.new( self.drb_base( nil, self.current_port ) ) end
    define_method :obj_write do p ||= Tuple.new( self.drb_base( nil, self.monit_port ) ) end
end
