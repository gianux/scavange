require_relative "drb_confs.rb"
require_relative "api_confs.rb"

module Kernel
    _finder = {}
    define_method :finder do |f, &block| _finder[f] = block end 

    private 
    define_method :get_finder do _finder end
end

module Loaded
    include DRBConfs
    include APIConfs

    def x_sym name, x = "X" ; "Base#{x}#{name}".to_sym end

    extend self
end

module XBaseReaction
    def base_react t, id = 0, a = t[:head], b = t[:tail], d = t[:divi] 
        a.step( b, d ) { |head| tail = [ b, (head + d - 1) ].min ; yield( head, tail, id += 1 ) if block_given?  }
    end
end 

module XDRbServerObj
    def drb_base name, p 
        uri p 
    end
    def uri_monit; uri Loaded::MONITPORT end

    private
    def uri p 
        DRbObject.new_with_uri("#{Loaded::HOST}#{ p }") 
    end

    extend self
end

module Table
    ( ACCESSORS = [ :detect_200, :detect_302, :detect_gool, :xcli_take, :xcli_write, :xerrors ] ).map { |a|
        attr_accessor :"#{a}" 
        self.instance_variable_set( "@#{a}", {} )
    }
    def gool k = :Detector
        self.detect_gool[ k ] 
    end 

    extend self
end
module Server
    module DtScavanger 
        scv_msg = {} 
        define_method :scavanger do |s| scv_msg[ s ] end
        define_method :set_msg do |s, v| scv_msg[ s ] = v end

        private
        def scavange_gool 
            scavange 
        end
        def scavange; self.em_respo && find_respo end
        def find_respo; DocumentResponse.new.finder self end
    end
end

class DocumentResponse
    def finder dt, page = dt.em_page 
        get_finder.each_pair { |s, bl, str=nil| 
                               ( dt.instance_eval &bl ) && ( str = site_gool( page, s ) )
                             ( str ? dt.set_msg( s, str ) : false ) && ( Table.gool.call( Loaded.x_sym( s ) ) )
        } 
    end
    private
    def site_gool page, s; "#{page}" end
end
