require 'drb/drb'

require_relative 'base_and_monit.rb' 

module ServerRunner
    extend self

    include Matcher::MatchNamesConditions

    def target s = ServerLoop::TARGET; s end

    def main_loop x = self.xserver
        loop { x.run } 
    end

    private

    def _extend b = Server::ProcessBase, m = Server::ProcessMonit
        self.target_matchbase? ? b : m
    end
    def new_xserver s = ServerLoop::TARGET
        Object.const_set( s, Class.new( _extend ) )  
    end
    def sorce_file_react
        "#{Loaded::APIDIR}/#{Loaded::REACT}"
    end
    def x_obj o = new_xserver, f = sorce_file_react
        load( f ) && ( return o )
    end
    def create_server x = x_obj.new
        self.xserver = x
    end
    def initialize
        DRb.start_service && create_server
    end
end

class ServerRun < Struct.new( :xserver )
    include ServerRunner
end
