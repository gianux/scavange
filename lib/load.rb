require_relative "finder.rb"

module Load
    extend self

    ACCESSORS = [ :servers_port, :relation, :confbase, :base, :servers_key ]

    BASE = { BaseXtrigger:   { port: Loaded::TRIGGPORT,msg: Loaded::TRIGGMSG, msg_type: String },
             BaseXdivparams: { port: Loaded::DIVPORT,  msg: Loaded::CLIMSG,   msg_type: Array  },
             BaseX302:       { port: Loaded::X302PORT, msg: Loaded::DTMSG,  msg_type: Array  },
             BaseX200:       { port: Loaded::X200PORT, msg: Loaded::DTMSG,  msg_type: String }, 
             BaseXerr:       { port: Loaded::XERRPORT, msg: Loaded::DTMSG,  msg_type: String } }

    NamesY = [ :values, :counts ]
    NamesX = BASE.keys.inject([]){ |a,k| a << "#{k}".split("Base").last.to_sym }

    private

    def fill_base modulle, base = BASE, 
            g = get_finder.keys.each_with_index{ | k,i, nb = modulle.x_sym(k) |
                    base[ nb ] = { port: Loaded::GOOLSPORT + i, 
                               msg: Loaded::DTMSG,
                               msg_type: String } 
        }
        base
    end
    def fill_confbase modulle, ld = modulle.ld_bases.keys.inject({}) { |t,k| 
                t[k] =  { trigg: false, react: false, counts: true, values: true } ;
                t 
        }
        ld
    end
    def fill_servers_key modulle, xk = get_finder.keys.inject([]) { |xk,k| 
                xk << :"X#{k}"  # not Base! For monit
        }
        xk
    end

    def fill_relation modulle, ld = ( NamesX + modulle.ld_servers_keys ).inject({}) { |r,x|  
                r[ b = modulle.x_sym( x, nil ) ] = b
                NamesY.each { |y| ( r[ :"#{x}_#{y}" ] = b ) if modulle.base?( modulle.ld_confbases, b, y ) } 
                r
        }
        ld
    end
    def fill_servers_port modulle, sp=[]
        modulle.ld_relations.each_pair { |k, rel, base = modulle.ld_base(k) |

            msg = { base:  proc { "#{k} #{base[:port]}" } ,             
                    monit: proc { "#{k} #{Loaded::MONITPORT}" } }
            arr = { base:  proc {  sp << msg[:base].call } ,  
                    monit: proc {  sp << msg[:monit].call } }

            b = arr[:base] ; m = arr[:monit]

            define_method :base_serverport do b.call if base end
            define_method :monit_serverport do |w| m.call if modulle.loaded_confs( rel, w ) end

            NamesY.map { |word| base_serverport || monit_serverport( word ) } 
        }
        sp.uniq 
    end

    public

    ACCESSORS.map { |a| 
        define_method :"_#{a}" do |modulle| send :"fill_#{a}", modulle end 
    }

end
