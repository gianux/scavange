require 'rinda/tuplespace'

require_relative 'finder_helper.rb'

ARGV[0] ? ( rserver = ARGV[0] ) : ( rserver = 'noname' )

ARGV[1] ? ( rport  = ARGV[1].to_i) : ( rport = Loaded::MONITPORT )

ts = Rinda::TupleSpace.new

begin 
    DRb.start_service("#{Loaded::HOST}#{rport}", ts)
rescue Exception => exception
    #puts "#{rserver}  #{exception}"
   # puts "#{exception}"
end

#puts "#{DRb.uri} server:#{rserver}"

#DRb.thread.join 


DRb.thread ? DRb.thread.join : DRb.thread
