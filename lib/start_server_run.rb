require 'drb/drb'
require 'rinda/tuplespace'

require_relative 'server_run.rb' 

module Param
    ARGV[0] ? ( TARGET = ARGV[0].to_sym ) : false
end

rs = Object 
rs.extend Server::DRbServerObj 

rport = rs.port( Param::TARGET )

begin 
    DRb.start_service("#{Loaded::HOST}#{rport}", Rinda::TupleSpace.new )
rescue => exception
end

r = ServerRun.new.main_loop 
