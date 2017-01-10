require 'redis'

require 'drb/drb'

require_relative 'redis_confs.rb'

require_relative 'rolling.rb'

module Param

    ARGV.any? ? ( argv = ARGV ) : ( argv = Array.new(5) )

    ROLLING = { head: argv[0].to_i, tail: argv[1].to_i, divi: argv[2].to_i, sitesfile: argv[3], wordsfile: argv[4] } 

end

RedisConfs.set_confs { |rs| 

    rs.files Param::ROLLING

    rs.cli [:values]  
    rs.dt302 [:values, :counts]  

    rs.react302 true
}

r = Rolling.new.start
