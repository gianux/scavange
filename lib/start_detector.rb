require 'drb/drb'

sites, dt = nil

Detector = Class.new  do
    ARGV.any? ? ( argv = ARGV ) : ( argv = Array.new(6) )

    a = instance_eval "[ #{argv[0]}, #{argv[1]}, #{argv[2]}, '#{argv[3]}', #{argv[4]}, '#{argv[5]}' ]" 

    sites, FLAG200, FLAG302, MSG, TPORTS, FDIRECTION = a
end

require_relative 'detector.rb'

pl =  ( pf = Loaded::GOOLSPORT ) + TPORTS.count

z = TPORTS.select {|k,v| v.between? pf, pl }.keys.inject([]){|a,k| 
        a << k.to_s.split("BaseX").last ; a 
}

Finder.set_words_list z

sites.map { |site| 
  begin 
    Server::DtMulti.em_init_multi

    EM.run { dt = Detector.new.scavate( site ) { 

        Server::DtMulti.em_multi.callback { EM.stop } } 
    }
  rescue => e  
      Table.xerrors[ :"#{dt.class}" ].call " ... #{e} :#{site}" 
  end
}
dt.todo if dt
