require "drb/drb"
require_relative "drb_xclient.rb"

module ClientAttributes 
    extend self

    m = nil

    private
    Object.const_set :My, Struct.new( :name, :value, :keep, :heads, :tails ) 
    define_method :my do m ||= My.new( self.class.name.to_sym , [],  [],  0,  0 ) end
end

class XClient 
    include ClientAttributes, XBaseReaction, CliDrb

    def monit_msg
        Loaded.ld_base( MONITSERVER )[:msg] 
    end
    def run n = my.name
        job ; yield n if block_given?
    end
    def make_react 
        reaction
    end
    def monit msg = self.monit_msg, k = my.keep
        obj_write.tuple.write( [ msg, k ] )
    end

    private

    [ :write , :takes ].map { |w| define_method w do |&block| block.call end }

    def load_tables t = proc { takes { self.make_react } }, w = proc { write { self.monit } }
        Table.xcli_take[ my.name ] = t
        Table.xcli_write[ my.name ] = w if CLICONF
    end
    def initialize 
        load_tables
    end
    def description h=my.heads, t=my.tails, d=my.value.count
        "#{h} #{t} count:#{d}"
    end
    def table_sport_param
        tb = Load::BASE.keys.inject({}){|t,k| 
                                    ( t[k] = Loaded.ld_base( k )[:port] )if Loaded.ld_base( k )[:msg] == Loaded::DTMSG ; t }
    end
    def run_detector t = table_sport_param, a = my.value, dir = Loaded::APIDIR, rb = Loaded::DETECTOR,
                     c200 = CONF200, c302 = CONF302, msg = Loaded::DTMSG, p = Param::XCLIENT[:fdirection]

        r = "ruby #{dir}/#{rb} '#{a}' #{c200} #{c302} '#{msg}' '#{t}' #{p}" 
        Process.spawn r
    end
    def value_in_tuple v = obj_take.tuple.take( [ Loaded::TRIGGMSG, my.heads, my.tails, nil] )
        my.value = v[3]
    end
    def value v = value_in_tuple, &block
        v ? block.call : nil
    end
    def keep ; [] end
    def keep ; my.keep << description end if CLICONF

    def take  v = value { keep }, &block
        v ? block.call : nil
    end
    def reaction p = Param::XCLIENT, d = p[:divi], h = p[:head], t = p[:tail],
                 r = self.base_react( divi: d, head: h, tail: t ) { |head, tail, id| 
                        my.heads = head ;
                        my.tails = tail ;
                        take { run_detector } 
                 }
        return r
    end
    def job x = Table.xcli_take[ my.name ] , y = Table.xcli_write[ my.name ]
        ( x.call if x ) && ( y.call if y )
    end
end
