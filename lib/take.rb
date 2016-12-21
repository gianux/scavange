module Server
    module Keep
        def keep 
            keepval unless self.tsm_serversignal? 
        end
    end
    module KeepServerTake
        include Keep
        private
        def keepval t = @tuple[1] 
            @val << t 
        end
    end
    module BaseTake
        module TakeMsg
            def take_msg s = takestr, t = taketype, a = [ s, t ]; a end
        end

        private

        def taketype s = server, l = Loaded.ld_base( server )[ :msg_type ]; l end
        def takestr s = server, l = Loaded.ld_base( server )[ :msg ]; l end

        include TakeMsg
    end
    module MonitTake 
        module TakeMsg
            def take_msg w, t = takestr( w ), a = [ t, nil ] ; a end
        end

        private

        def takestr w, s = server, l = Loaded.msg_last( Loaded.ld_relation( s ), w ); l end

        include TakeMsg
    end

    module TakeSignalMonitorization
       def tsm_serversignal?
           !tsm_basesignal?
       end
       def tsm_baseprocess_signal? 
           tsm_signalmonitz?( tsm_basesignal )
       end
       def tsm_monitprocess_signal?
           tsm_signalmonitz?( tsm_signalmonit )
       end
       private
       def tsm_signalmonitz? signal  
           ( signal == 0 ) ? true : false 
       end 
       def tsm_basesignal? 
           tsm_basesignal > 0 
       end

       def tsm_basesignal t = @tuple[1].length; t end
       def tsm_signalmonit t = @tuple; t end
    end

    module Take
      include TakeSignalMonitorization

      def take s = server, t = Table.take[s].call
          @tuple = t
      end

      self.class.name.match( /Base/ ) ? ( include BaseTake ) : ( include MonitTake )
    end
end
