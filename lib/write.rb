module Server
    module CommunMethods
        def commun_write signal, s = server
            signal ? self.send( :"write_call_#{ s }") : ( @last = @tuple ) #public
        end
    end
    module OtherBaseWritersCall
        def writers_call
            Table.reaction[ server ].call 
            Table.counts[ server ].call 
        end
    end
    module BaseWriteMessage
        private

        def writestr w, s = server, l = Loaded.ld_relation(s), m = Loaded.msg_last( l, w ); m end

        def values
            @val
        end
        module BaseCounterWrite 
            private
            def counts ct = @val.flatten.count; ct end
        end
        include BaseCounterWrite
    end
    module MonitWriteMessage
        private

        def writestr w, s = server, l = Loaded.ld_relation(s), j = Loaded.msg_just( l, w ); j end

        def values v = @last; v end

        alias_method :counts, :values
    end
    module WriteMsg
        def write_msg w, s = writestr( w ), a = [ s, send( "#{w}" ) ]; a end
    end
    module MonitWrite
        include WriteMsg
        include MonitWriteMessage
    end
    module BaseWrite
        include WriteMsg
        include BaseWriteMessage
        include OtherBaseWritersCall
    end

    module Write # if signal
        def write s = server, t = Table.write[s].call; t end

        self.class.name.match( /Base/ ) ? ( include BaseWrite ) : ( include MonitWrite )
    end
end
