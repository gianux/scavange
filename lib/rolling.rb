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
        check_params ? [ :servers_up, :client_up, :start_rolling ].map { |method_name| send "#{method_name}" } : false
    end

    private

    def initialize
        DRb.start_service
    end
    def check_params
        self.head = Param::STARTN.to_i
        self.tail = Param::UNIVERSE.to_i
        self.divi = Param::DIVISION.to_i
        self.file = Param::FILENAME
    end
    def servers_up ports = Loaded.ld_servers_ports.uniq, file_name = Param::FILENAME, dir = Loaded::APIDIR
        RUN.map { |rb| 
            sleep 1
            ports.map { |server_and_port| 
                Process.spawn "ruby #{dir}/#{rb} #{server_and_port} #{file_name}" 
            }
        }
    end
    def client_up rb = CLI, d = Param::DIVISION, h = Param::STARTN, t = Param::UNIVERSE, 
                  p = PORT, p302 = PORT302, dir = Loaded::APIDIR
        sleep 3 
        Process.spawn "ruby #{dir}/#{rb} #{d} #{h} #{t} #{p} https"
        Process.spawn "ruby #{dir}/#{rb} 1 #{h} #{t} #{p302} http"
    end

    def start_rolling
        TUPLE.write( [ MSG, Param::STARTN, Param::UNIVERSE, Param::DIVISION ] )
    end
end
