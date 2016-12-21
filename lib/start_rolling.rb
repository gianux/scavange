require 'redis'

require 'drb/drb'

require_relative 'redis_confs.rb'

require_relative 'rolling.rb'

module Param
    ARGV[0] ? ( STARTN = ARGV[0] ) : "1"
    ARGV[1] ? ( UNIVERSE = ARGV[1] ) : "1"
    ARGV[2] ? ( DIVISION = ARGV[2] ) : "1"
    ARGV[3] ? ( FILENAME = ARGV[3] ) : "_file"
end

r = Rolling.new.start
