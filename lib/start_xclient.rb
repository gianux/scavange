require_relative "xclient.rb"

module Param

    ARGV.any? ? ( argv = ARGV ) : ( argv = Array.new(5) )

    XCLIENT = { divi: argv[0].to_i, head: argv[1].to_i, tail: argv[2].to_i, port: argv[3], fdirection: argv[4] } 

end

a = XClient.new.run 
