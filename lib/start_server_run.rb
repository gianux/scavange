require_relative 'server_run.rb' 

module ServerLoop
    ARGV[0] ? ( TARGET = ARGV[0].to_sym ) : false
    ARGV[1] ? ( PORT = ARGV[1].to_i ) : false
end

module Param
    ARGV[2] ? ( FILENAME = ARGV[2] ) : false
end

r = ServerRun.new.main_loop 
