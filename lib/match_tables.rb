module Matcher
    module GiveBlock
        private
        def block_take &b
            ( self.any_server_take &b )
        end
        def block_write &b
            ( self.any_server_write &b )
        end
    end
    module MatchTables
        include GiveBlock

        public
        def taken &block 
            case self.class.name.to_sym 
              when :Monit         then block_take &block
              when :Base          then block_take &block
              when :"Base::Trigg" then block_take &block  
            end
        end
        def writen &block
            case self.class.name.to_sym 
              when :Monit                  then block_write &block
              when :Base                   then block_write &block
              when :"Base::React"          then block_write &block # BaseX302 
              when :"Base::Trigg"          then block_write &block # BaseXtrigger
              when :"Base::Counter"        then block_write &block # all
            end
        end
    end
end
