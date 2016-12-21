require 'drb/drb'
require_relative 'loaded.rb'
require_relative 'take.rb'
require_relative 'write.rb'
require_relative 'match_objects.rb'
require_relative 'base_and_monit_tables.rb'

module Server
    module BaseReaction
        include XBaseReaction
    end 
    module LoadTables
        def base s = server, b = self.drb_base( s ); b end 

        private

        def monit u = self.uri_monit; u end

        def load_tables m = monit, b = self.base, match = Matcher::Match
            match.monit.taken  {|w| proc{  m.take(   self.take_msg w )[1] } } # w -> Monit class
            match.monit.writen {|w| proc{  m.write(  self.write_msg w   ) } }
            match.base.taken   {    proc{  b.take(   self.take_msg      ) } } 
            match.base.writen  {              proc{  m.write( self.write_msg :values     ) } } 
            match.base.counter.writen {       proc{  m.write( self.write_msg :counts     ) } }  
        end
    end
    module DRbServerObj
        include XDRbServerObj

        def port server, s = Loaded.ld_relation( server ), p = Loaded.ld_base( s )[:port]; p end
    end
    module MyName
        private
        def server s = self.class.to_s.to_sym; s end

        def know_myname s = server
            Matcher::Match.target_server = s
        end 
    end
    module Run
        def run
            self.take_call_    # gerated in server_and_monit.rb
            self.process_call_
        end
    end
    module XServer
        include Run
        include MyName 
        include DRbServerObj, LoadTables

        def initialize _ = know_myname
            @val = [] ; @tuple = [] ; @last = [] 
            Table.init_tables( server ) { load_tables }
        end
    end

    module CheckedAttributes
        def self.included(xbase)
            xbase.extend ClassMethods
        end
        module ClassMethods
            private
            def attr_checked(attribute, &validation)
                public
                define_method "#{attribute}=" do |value|
                    raise 'Invalid attribute' unless validation.call(value, self)
                    instance_variable_set("@#{attribute}" , value)
                end
                define_method attribute do
                    instance_variable_get "@#{attribute}"
                end
            end
        end
    end

    module CheckRollingParams
        include Server::CheckedAttributes
    
        attr_checked :head do |h,my| ( h >= 1 ) end
        attr_checked :tail do |t,my| ( t >= 1 ) && ( t >= my.head ) end
        attr_checked :divi do |d,my| ( d >= 1 ) && ( d <= my.tail ) end
        attr_checked :file do |f,my| ( `ls #{f}`).chomp.length > 0 end
    end
end
