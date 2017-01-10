require_relative 'base_and_monit.rb'

module TriggerComponents
    head, tail = Fixnum ; ary = Array

    define_method :client_msg do | m = Loaded::TRIGGMSG, h = head, t = tail, a = ary | 
        [ m, h, t, a ] 
    end

    private

    define_method :_cmd do Configs::Run._cmd_sed( head, tail, Configs::SITESFILE ) end

    define_method :set_clientmsg do |h, t| head = h ; tail = t ; ary = run_cmd  end

    def run_cmd a = _cmd; return a end
end

class BaseXtrigger < Server::ProcessBase

    def keep signal = self.tsm_serversignal? 
        set_val unless signal
    end
    def msg_from m = msg_type
        return m
    end

    include Server::BaseReaction

    def react d = divi, h = tp1, t = tp2, &block
        self.base_react( divi: d, head: h , tail: t  ) { |next_h ,next_t| 
            reaction( next_h, next_t, &block ) 
        }
    end

    private

    def trigger s = server, b = Loaded.ld_base( s ); b end

    def set_val desc = tp12
        @val[0] = desc
    end

    def tp12 s = "#{tp1}...#{tp2} / #{divi}"; s end

    def reaction h, t, &bl
        set_clientmsg( h, t ) ; bl.call 
    end
    def tp1  
        @tuple[1].to_i 
    end
    def tp2  
        @tuple[2].to_i 
    end
    def divi  
        @tuple[3].to_i 
    end

    def msg_type m = trigger[:msg], t = trigger[:msg_type]; [ m, t, t, t ] end

    include TriggerComponents 

    def load_tables 
        super 
        Matcher::Match.base.trigg.taken { proc { self.base.take( self.msg_from ) } } 
        Matcher::Match.base.trigg.writen { proc { self.react { self.base.write( self.client_msg ) } } }
    end
end

class BaseX302 < Server::ProcessBase
    def load_tables 
        super 
        Matcher::Match.base.react.writen { proc { self.base.write( self.client_msg ) } }
    end
    def client_msg v = @val.count,  a = [ Loaded::TRIGGMSG, v, v, @tuple[1] ] 
        return a
    end
end
