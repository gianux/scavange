require_relative 'match_classs.rb'

module MatchBaseObjs
    def counter 
        Base::Counter.new 
    end
    def react
        Base::React.new
    end
    def trigg
        Base::Trigg.new
    end
end

module MatchServersBase
    include MatchBaseObjs
    def base 
        Base.new
    end
end
module MatchServersMonit
    def monit 
        Monit.new
    end
end
module MatchServers
    include MatchServersBase
    include MatchServersMonit
end

module MatchObjects 
    include MatchServers
end
module Matcher
  class Match
    class << self
      include MatchObjects
      attr_accessor :target_server
    end
  end
end
