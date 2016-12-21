module Table
    extend self

    attr_accessor :counts, :reaction, :take, :write

    def init_tables xserver, h = helper { table( xserver ) }

        ( Table.counts, Table.reaction, Table.take, Table.write ) = h

        yield if block_given?
    end

    private

    def helper s = "", &block
        empty_attrs.count.times { s += "block.call," } ; instance_eval "return #{s[0...-1]}"
    end

    def table x, t = {}
        t[ x ] = proc { [] } ; return t
    end

    def empty_attrs
        [ @counts, @reaction, @take, @write ]
    end
end
