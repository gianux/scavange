require_relative 'load.rb'
require_relative "configs.rb"

def Loaded.base? bp, s, y  ;  bp[ "#{s}".to_sym ][ "#{y}".to_sym ] == true end

module Loaded
    ( Load::MONITACCESSORS + Load::ACCESSORS ).map { |w|  
        private 
        attr_accessor :"#{w}"

        public
        define_method :"ld_#{w}" do |s| ( self.send :"#{w}" )[ s.to_sym ] end
        define_method :"ld_#{w}s" do self.send :"#{w}" end
    } 
    define_method :ld_confbase do |s| confbase[ relation[s] ] end

    %w[ last just ].map { |w|

        define_method :"msg_#{w}" do |s,v| "#{instance_eval "Loaded::#{w.upcase}MONITMSG"} #{s} #{v}" end
    }

    def loaded_confs s, word = nil
       loaded_choices( s ).map { |conf| ( "#{conf}" == "#{word}" ) && ( return true ) } ; return nil
    end

    private

    def loaded_choices s, d = []
        Load.get_monitorize.keys.map{ |k, ks = ( Load.get_monitorize k ).call.keys.first | 
            c = Loaded.send( :"ld_#{k}", :"#{ks}" )[s]  
            d = c if c
        }
        d
    end

    def loaded_objects

        ( Load::MONITACCESSORS + Load::ACCESSORS ).map { |w| self.instance_variable_set("@#{w}", Load.send(:"_#{w}", Loaded) ) }

        yield if block_given?

        @confserver = final_confserver
        @confbase = final_confbase confbase
    end

    def final_confbase t
        t[ :BaseXtrigger ][ :trigg ] = true
        t[ :BaseX302 ][ :react ] = Configs::REACT_302
        t
    end

    loaded_objects { 

        a = confserver 

        Load::NamesX.map { | x | 

            define_method :ports_selection do |w=nil| confserver.select { |sp| sp.to_s.match "#{x}#{w}" } end
            define_method :choice_in_confs do loaded_choices( Loaded.x_sym( x, nil ) ) end
            define_method :final_names do Load::NamesY - choice_in_confs end

            a -= ports_selection unless choice_in_confs.any? 
            final_names.map { |w| a -= ports_selection "_#{w}" } 
        } 
        define_method :final_confserver do a end
    }
    extend self
end
