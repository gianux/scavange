require "redis"

require_relative "server.rb"

module Configs
    module Run
        def _cmd_sed h, t, f, s = "sed -n '#{h},#{t} p' #{f}" 
            ( `#{s}` ).split("\n") if (  ( h + t ) > 0 )
        end

        extend self
    end

    redis = Redis.new

    WORDSFILE = redis.get 'wordsfile'
    SITESFILE = redis.get 'sitesfile'
    REACT_302 = instance_eval "#{ redis.get 'react302conf' }"

    define_method :set_confs do | cliconf = redis.get( 'cliconf' ), 
                                  triggconf = redis.get( 'triggconf'), 
                                  dt200conf = redis.get( 'dt200conf'), 
                                  dt302conf = redis.get('dt302conf'),
                                  t = proc { triggconf = [ :true ] }  |

        triggconf.respond_to?( :any? ) ? ( t.call unless triggconf.any? ) : t.call

        td = { Detector: { BaseX200: ( instance_eval "#{dt200conf}" ), 
                           BaseX302: ( instance_eval "#{dt302conf}" ), 
                           BaseXerr: [ :values, :counts ] } } 

        get_finder.keys.map { |k| td[:Detector][ "BaseX#{k}".to_sym ] = [ :values, :counts ] }

        Load.monitorize( :detectconf ) { td }

        Load.monitorize( :cliconf ) { { XClient: { BaseXdivparams: ( instance_eval "#{cliconf}") } } }

        Load.monitorize( :triggconf ) { { BaseXtrigger: { BaseXtrigger: ( instance_eval "#{triggconf}" ) } } } 
    end

    extend self
end

arr = Configs::Run._cmd_sed 1, 1000, Configs::WORDSFILE

Finder.set_words_list arr

Configs.set_confs
