require_relative "xclient.rb"

module Param
    ARGV[0] ? ( DIVI = ARGV[0].to_i) : "1" 
    ARGV[1] ? ( HEAD = ARGV[1].to_i) : "1"
    ARGV[2] ? ( TAIL = ARGV[2].to_i) : "1"
    ARGV[3] ? ( PORT = ARGV[3].to_i) : "21212"
    ARGV[4] ? ( FOLLOWDIRECTION = ARGV[4] ) : "https"
end

a = XClient.new.run 
#{ |name| puts "write params to BaseXdivparam tk:#{Table.xcli_take[ name ]} wr:#{Table.xcli_write[ name ]}" }
