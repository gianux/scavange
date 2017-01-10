module Table

    ( accessors ||= [ :counts, :reaction, :take, :write ] ).map { |w| 

        attr_accessor :"#{w}"
    }

    def init_tables xserver, h = helper( xserver ) 

        ( Table.counts, Table.reaction, Table.take, Table.write ) = h

        yield if block_given?
    end


    private

    define_method :helper do | x, t = {}, p = proc { [] } |

        t[ x ] = p 

        Array.new( accessors.count ) { t } 
    end

    extend self
end
