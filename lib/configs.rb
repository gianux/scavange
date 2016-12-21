require "redis"

redis = Redis.new

cliconf = redis.get 'cliconf'
triggconf = redis.get 'triggconf'
dt200conf = redis.get 'dt200conf'
dt302conf = redis.get 'dt302conf'

#cliconf = []
#triggconf = [:values]
#dt200conf = [:counts]
#dt302conf = []

td = { Detector: { BaseX200: ( instance_eval "#{dt200conf}" ), 
                   BaseX302: ( instance_eval "#{dt302conf}" ), 
                   BaseXerr: [ :values, :counts ] } } 

get_finder.keys.map { |k| td[:Detector][ "BaseX#{k}".to_sym ] = [ :values, :counts ] }

Load.monitorize( :detectconf ) { td }

Load.monitorize( :cliconf ) { { XClient: { BaseXdivparams: ( instance_eval "#{cliconf}") } } }

Load.monitorize( :triggconf ) { { BaseXtrigger: { BaseXtrigger: ( instance_eval "#{triggconf}" ) } } } 
