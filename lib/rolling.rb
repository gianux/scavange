require_relative 'server.rb'
require_relative 'loaded.rb'

module Name
    def self.progs
        Loaded::BASES
    end
    def self.client
        Loaded::CLIENT
    end
end

module Trigger
    extend Server::DRbServerObj

    def self.drb p = Trigger.port, b = self.drb_base( nil, p ); b end

    def self.port s = :BaseXtrigger, p = Loaded.ld_base( s )[:port]; p end

    def self.msg m = Loaded.ld_base( :BaseXtrigger )[:msg]; m end
end

module MyTupleParams 
    extend self

    m, p, t  = nil

    private

    Object.const_set :Tuple, Struct.new( :object ) 
    define_method :tuple do t ||= Tuple.new( Trigger.drb ) end

    Object.const_set :My,  Struct.new( :ruby_run, :ruby_cli, :react_msg, :port, :port302) 
    define_method :my do m ||= My.new( Name.progs, Name.client, Trigger.msg, Trigger.port, Trigger.port(:BaseX302) ) end

    MSG   = my.react_msg
    RUN   = my.ruby_run
    CLI   = my.ruby_cli
    TUPLE = tuple.object
    PORT  = my.port 
    PORT302  = my.port302 
end
class Rolling
    include Server::CheckRollingParams
    include MyTupleParams

    def start 
        [ :servers_up, :client_up, :start_rolling ].map { |method_name| send "#{method_name}" } 
    end

    private

    def initialize p = Param::ROLLING
        check_params( p ) 
    end
    def check_params p
        self.head = p[:head]
        self.tail = p[:tail]
        self.divi = p[:divi]
        self.file = p[:wordsfile]
        self.file = p[:sitesfile]
    end
    def servers_up xs = Loaded.ld_confservers, file_name = self.file, dir = Loaded::APIDIR
        RUN.map { |rb| 
            sleep 1
            xs.map { |xserver| Process.spawn "ruby #{dir}/#{rb} #{xserver}" }
        }
    end
    def client_up rb = CLI, d = self.divi, h = self.head, t = self.tail, 
                  p = PORT, p302 = PORT302, dir = Loaded::APIDIR
        sleep 3 
        Process.spawn "ruby #{dir}/#{rb} #{d} #{h} #{t} #{p} https"
        Process.spawn "ruby #{dir}/#{rb} 1 1 #{t} #{p302} http" if Loaded.ld_detectconf( :Detector )[ :BaseX302 ].any?
    end

    def start_rolling
        TUPLE.write( [ MSG, "#{self.head}", "#{self.tail}", "#{self.divi}" ] )
    end
end
