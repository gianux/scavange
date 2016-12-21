require 'drb/drb'

module Param 
    ARGV.any? ? ( argv = ARGV ) : ( argv = [ [], false, false, '', {}, '' ] )

    a = instance_eval "[ #{argv[0]}, #{argv[1]}, #{argv[2]}, '#{argv[3]}', #{argv[4]}, '#{argv[5]}' ]" 

    SITES, FLAG200, FLAG302, MSG, TPORTS, FOLLOWDIRECTION  = a
end

require_relative 'detector.rb'

dt = nil

Param::SITES.map { |site| 
  begin 
    EM.run { dt = Detector.new.scavate( site ) { Server::DtMulti.em_multi.callback { EM.stop } } 
    }
  rescue => e  
      Table.xerrors[ :"#{dt.class}" ].call " ... #{e} :#{site}" 
  end
}
dt.todo if dt
