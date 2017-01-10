require "drb/drb"

require_relative "../lib/server.rb"

module Monitorize

    DRb.start_service
    ts = DRbObject.new_with_uri("#{Loaded::HOST}#{Loaded::MONITPORT}")

    arr = Configs::Run._cmd_sed 1, 1000, Configs::WORDSFILE
    Finder.set_words_list arr

    drb = Object
    drb.extend Server::DRbServerObj


    tb_ = Loaded.ld_bases.keys.inject({}){ |t, k| t[ k.to_sym ] = drb.drb_base( k ) ; t }
    words = tb_.keys.inject([]) { |a, k| a << "#{k}".split("X").last ; a }

    words.map { | w, type="", vals=[] |

      s = Loaded.x_sym ( w )

      msg = Loaded.ld_base( s )[:msg]

      ( type = [] ) if ( Loaded.ld_bases[ s ][ :msg_type ] == Array )

      define_method "xx#{w}_pass_values" do tb_[ s ].write( [ msg, type ] ) end

      vals = [:values, :counts]

      vals.map { |v, nm = "#{w}_#{v}"|
        private
        define_method "write_#{nm}" do ts.write([ Loaded.msg_last(s,v), 0 ]) end
        define_method "take_#{nm}" do ts.take([ Loaded.msg_just(s,v), nil ]) end

        public
        define_method "xx#{nm}" do send( "write_#{nm}" ) ; send( "take_#{nm}" ) end
      }
    }

    define_method :xxtrigger_pass_values do 
      tb_[ :BaseXtrigger ].write([ Loaded.ld_base( :BaseXtrigger )[:msg], "", "", "1" ]) 
    end

    extend self
end

module Monitorize
    def self.my_methods_call
        Monitorize.methods.grep( /xx/ ).map { |m| 
            serv = Loaded.x_sym( m.to_s.split("xx")[1].to_s.split("_").first )
            word = m.to_s.split("xx")[1].to_s.split("_").last 

            send( :"#{m}" ) if ( Loaded.loaded_confs serv, word )  
        }
    end
    def self.now
        Monitorize.my_methods_call.map { |n| 
            ( puts "----------------------------------------------------------------------------------" ; 
              p n ) if n 
        }
    end
end
