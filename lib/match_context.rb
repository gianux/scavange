require_relative 'match_tables.rb'

module Matcher
    module MatchNamesConditions
        def target_matchbase? b = :Base, t = self.target
            "#{t}".match( "#{b}" ) 
        end
    end
    module AskFor
        private
        def askfor word
            self.target_matchbase? ? askedfor?( word ) : askedfor__and__targetmatchword?( word ) 
        end
        def askedfor__and__targetmatchword? w
            askedfor?( w ) ? self.target_matchbase?( w ) : nil
        end
        def askedfor? w 
            Loaded.ld_confbase( self.target )[ w ] == true
        end
    end

    module MatchTablesConditions
        def context_tb( words = [], t = { self.target => proc { [] } }, &block )
            ( set_target_tb( t, &block ) unless words.any? ) || set_table( t, words, &block )
            return t
        end

        private
        def set_table table, words, &block
            words.each { |w| table_set( w, table, &block ) }
        end
        def table_set w, t, &b
            set_target_tb( t, w, &b ) if word_in_conf?( w )
        end
        def set_target_tb t, word = nil, &block
            t[ self.target ] = block.call( word ) if block 
        end
        def word_in_conf? w 
            askfor( w ) 
        end
    end

    class Context 
        include AskFor
        include MatchTablesConditions 
        include MatchNamesConditions 
        include Matcher::MatchTables

        attr_accessor :target

        private

        def initialize 
            self.target = Matcher::Match.target_server
        end
        def method_missing *args
            return Matcher::Match.method( args[0] ).call
        end
    end
end
