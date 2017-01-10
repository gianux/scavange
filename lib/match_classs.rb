require_relative 'match_context.rb'

module Context 
    sp = proc { |s| "obj.context_tb( obj.class::WORDS, &b ) #{s} obj.target_matchbase?" }

    [ :if, :unless ].map { |w| 
        define_method "match_#{w}base" do |obj, &b| instance_eval sp.call( w ) end
    }
    [ :take, :write, :counts, :reaction ].map { |w|
        define_method w do |c={}| c && ( instance_eval "Table.#{w}=c" ) end
    }
    extend self
end
module MonitContextTake
    def any_server_take &block
        Context.take( Context.match_unlessbase self, &block )
    end
end
module MonitContextWrite
    def any_server_write &block
        Context.write( Context.match_unlessbase self, &block ) 
    end
end
module BaseContextTake
    def any_server_take &block
        Context.take( Context.match_ifbase self, &block ) 
    end
end
module BaseContextWrite
    def any_server_write &block
        Context.write( Context.match_ifbase self, &block ) 
    end
end
module BaseContextWriteReaction
    def any_server_write &block
        Context.reaction( Context.match_ifbase self, &block ) 
    end
end
module BaseContextWriteCounts
    def any_server_write &block
        Context.counts( Context.match_ifbase self, &block )
    end
end

class Base < Matcher::Context
    include BaseContextTake
    include BaseContextWrite
    WORDS = []

    class Counter < Base
        include BaseContextWriteCounts
        WORDS = [ :counts ]
    end
    class Trigg < Base
        include BaseContextTake
        include BaseContextWriteReaction
        WORDS = [ :trigg ]
    end
    class React < Base
        include BaseContextTake
        include BaseContextWriteReaction
        WORDS = [ :react ]
    end
end

class Monit < Matcher::Context
    include MonitContextTake
    include MonitContextWrite
    WORDS = [ :counts, :values ]
end
