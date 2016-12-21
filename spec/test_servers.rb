require 'redis'
require 'rinda/tuplespace'
require_relative "../lib/base_and_monit.rb"
require_relative "../lib/react_server.rb"
require_relative "../irb/monitorize.rb"
require_relative "../lib/xclient.rb"
require_relative "../lib/server_run.rb"

module DtParams
    MSG = Loaded::DTMSG
    FLAG200 = true 
    FLAG302 = true 
    TPORTS = {:BaseX302=>33302, :BaseX200=>67890, :BaseXerr=>98989, :BaseXportuga=>11111}
    FOLLOWDIRECTION = "https"
end
module Param
    include DtParams
    HEAD = 1 ; TAIL = 1 ; DIVI = 1 ; PORT = "99999" 
    CLICONF = true
    CONF200 = true
    CONF302 = true
    FILENAME = ( `pwd` ).chomp.concat("/file/alexa1M.txt")
end

require_relative "../lib/detector.rb"

module Testes
    extend self
    ts = Rinda::TupleSpace.new

    Load._base( Loaded ).keys.map { | k | 
        Loaded.ld_base( k )[:port] }.
            inject( [ Loaded::MONITPORT ] ){ |a,p| a << p }.
                uniq.map { | k | DRb.start_service "#{Loaded::HOST}#{k}", ts }

    OBJ = Object
    OBJ.extend Server::DRbServerObj
end

Matcher::constants.select{|m| (instance_eval "Matcher::#{m}.class") == Module  }.
    map{ |m| instance_eval "Matcher::#{m}.module_eval do extend self end" } 

class BaseX302 < Server::ProcessBase
end
class BaseX200 < Server::ProcessBase
end
class BaseXdivparams < Server::ProcessBase
end
class BaseXgool < Server::ProcessBase
end
class Xtrigger_values < Server::ProcessMonit
end
class Xtrigger_counts < Server::ProcessMonit
end
class Xdivparams_values < Server::ProcessMonit
end
class Xdivparams_counts < Server::ProcessMonit
end
class Xgool_counts < Server::ProcessMonit
end
class Xgool_values < Server::ProcessMonit
end
class X302_values < Server::ProcessMonit
end
class X302_counts < Server::ProcessMonit
end
class X200_values < Server::ProcessMonit
end
class X200_counts < Server::ProcessMonit
end

redis = Redis.new

redis.set 'cliconf', "[ :values ]"
redis.set 'triggconf', "[ :values, :counts ]"
redis.set 'dt200conf', "[ :values, :counts ]"
redis.set 'dt302conf', "[ :values, :counts ]"
