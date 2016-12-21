require_relative 'server.rb'

module Server
    def self.names k = Loaded.ld_relations.keys
        return k
    end
    def self.correct_modname mod 
        mod.name.downcase.split('::')[1]
    end
    def self.modname modname, servname = nil
        "#{modname.downcase}_call_#{servname}"
    end
    module CallerHelper
        def self.create_method modulle 
            mn = Server.correct_modname modulle
            modulle.module_eval do
                private
                define_method :caller_ do |modname, servname| send :"#{Server.modname( modname, servname )}"  end  
                Server.names.map {|s| 
                    public
                    define_method Server.modname mn, s do send :"called_#{mn}" end 
                    define_method Server.modname mn do caller_ mn, s end
                }
            end
        end
    end
    module Write
        private
        CallerHelper.create_method self
        def called_write 
            self.write 
        end
    end
    module Take 
        private
        CallerHelper.create_method self
        def called_take 
            self.take 
        end
    end
    module Process 
        private
        CallerHelper.create_method self 
        def called_process 
            process 
        end
    end
    module CommunMethods
        include Process
        include Server::XServer, Server::Take, Server::Write 
    end
    module Monits 
        include CommunMethods
        include Server::MonitWrite, Server::MonitTake
    end 
    module Bases 
        include CommunMethods
        include Server::BaseWrite, Server::BaseTake, Server::KeepServerTake
    end
    class ProcessBase 
        include Bases
        private
        def process s = self.tsm_baseprocess_signal?
            self.keep
            self.writers_call  # reaction counts 
            self.commun_write( s )  # write .call
        end
    end
    class ProcessMonit 
        include Monits
        private
        def process s = self.tsm_monitprocess_signal?
            self.commun_write( s )
        end
    end
end
