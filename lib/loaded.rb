require_relative 'load.rb'

module Load
    extend self

    MONITACCESSORS = [ :cliconf, :triggconf, :detectconf ] 

    _monitorize = {}
    define_method :monitorize do |m, &block| _monitorize[m] = block end
    define_method :get_monitorize do |m=nil| m ? _monitorize[m] : _monitorize  end

    %w[ cliconf triggconf detectconf ].map { |word| define_method "_#{word}" do 
                                                        self.get_monitorize(:"#{word}").call 
                                                    end }
end

require_relative "configs.rb"

def Loaded.base? bp, s, y  ;  bp[ "#{s}".to_sym ][ "#{y}".to_sym ] == true end

module Loaded
    extend self
    ( Load::MONITACCESSORS + Load::ACCESSORS ).map { |w|  
        private 
        attr_accessor :"#{w}"

        public
        define_method ( a = "ld_#{w}" ) { |s| instance_eval "#{w}[:#{s}]" } ; module_function a
        define_method ( b = "ld_#{w}s"  ) {   instance_eval "#{w}"        } ; module_function b
    } 
    define_method ( c = :ld_confbase ) { |s| confbase[ relation[s] ]  } ; module_function c  

    %w[ last just ].map { |w|

        define_method :"msg_#{w}" do |s,v| "#{instance_eval "Loaded::#{w.upcase}MONITMSG"} #{s} #{v}" end
    }

    def loaded_confs s, word = nil
       loaded_choices( s ).map { |conf| ( "#{conf}" == "#{word}" ) && ( return true ) } ; return nil
    end

    private

    def loaded_choices s, d = []
       Load.get_monitorize.keys.map{ |k, ks = ( Load.get_monitorize k ).call.keys.first | 
          c = Loaded.send( :"ld_#{k}", :"#{ks}" )[s]        ; d=c if c
       }
       return d
    end

    def loaded_objects
        @base = Load._base Loaded
        @confbase = Load._confbase Loaded
        @servers_key = Load._servers_key Loaded 
        @cliconf = Load._cliconf
        @triggconf = Load._triggconf
        @detectconf = Load._detectconf
        @relation = Load._relation Loaded
        @servers_port = Load._servers_port Loaded 
        yield if block_given?
    end

    loaded_objects { 
        Load::NamesX.each { | x | 
            define_method :ports_selection do |w=nil| servers_port.select { |sp| sp.match "#{x}#{w}" } end
            define_method :choice_in_confs do loaded_choices( Loaded.x_sym( x, nil ) ) end
            define_method :final_names do Load::NamesY - loaded_choices( Loaded.x_sym( x, nil ) ) end

            @servers_port -= ports_selection unless choice_in_confs.any? 

            final_names.map { |w| @servers_port -= ports_selection "_#{w}" } 
        } 
        @confbase[ :BaseXtrigger ][ :trigg ] = true
        @confbase[ :BaseX302 ][ :react ] = true
        @servers_port << "#{ b = :BaseXtrigger } #{Loaded.ld_base( b )[:port]}" 
    }
end
