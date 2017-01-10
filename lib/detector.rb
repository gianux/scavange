require 'drb/drb'
require_relative 'em_request_detector.rb'
require_relative "finder.rb" 

class Detector
  include XDRbServerObj
  include Server::DtRequest 
  include Server::DtScavanger 

  %w[ FLAG200 FLAG302 MSG TPORTS FDIRECTION ].map {|c| 
      raise "give values to FLAG200, FLAG302, MSG, TPORTS, FDIRECTION (load start_detector.rb)" unless self.const_defined?( c ) 
  }

  def self.create_flagmethod

    FLAG302 ? ( 
      def dtd_302_msg s = :BaseX302, ar = self.dtf_302, msg = MSG 
          self.drb_base( s, TPORTS[s] ).write( [ msg , ar ] ) 
      end 
      def todo write = Table.detect_302[ my_name ] 
          write.call
      end 
      def pre_todo
          em_status302? && dtf_fill302
      end
      def load_tables x = Table.detect_200[my_name] = proc {}
        Table.detect_gool[my_name] = proc { |s| write { self.dtd_gool_msg s } }
        Table.detect_302[my_name] = proc { write { self.dtd_302_msg } } 
        Table.xerrors[my_name] = proc { |e| write { self.dtd_err_msg e } }
      end
    ) : false

    FLAG200 ? ( 
      def dtd_200_msg s = :BaseX200, page = self.em_page.to_s, msg = MSG
        self.drb_base( s, TPORTS[s] ).write( [ msg , page ] ) 
      end
      def load_tables x = Table.detect_302[my_name] = proc {}
        Table.detect_gool[my_name] = proc { |s| write { self.dtd_gool_msg s } }
        Table.detect_200[my_name] = proc { write { self.dtd_200_msg } }
        Table.xerrors[my_name] = proc { |e| write { self.dtd_err_msg e } }
      end
    ) : false

    FLAG200 && FLAG302 ? (  
      def load_tables 
        Table.detect_gool[my_name] = proc { |s| write { self.dtd_gool_msg s } }
        Table.detect_200[my_name] = proc { write { self.dtd_200_msg } } 
        Table.detect_302[my_name] = proc { write { self.dtd_302_msg } } 
        Table.xerrors[my_name] = proc { |e| write { self.dtd_err_msg e } }
      end
    ) : false

  end

  def em_url h = "#{FDIRECTION}://www." 
      "#{h}#{self.em_page }" 
  end

  def scavate site, &block
      Server::DtMulti.em_multi.add( self.em_set_page( site ), 

                                    self.em_mkrequest { self.em_request.callback { 
                                                               self.pre_todo ;
                                                               writers ;
                                                               self.em_reset_status } 
                                    } 
                                  )
      yield 

      return self
  end
  def dtd_gool_msg s, scv = self.scavanger( s.to_s.split( "X" )[1]), msg = MSG
      self.drb_base( s, TPORTS[s] ).write( [ msg, scv ] )  
  end
  def dtd_err_msg error, msg = MSG
      self.drb_base( '', TPORTS[:BaseXerr] ).write( [ msg, error ] )
  end
  def dtd_200_msg; end
  def dtd_302_msg; end
  def pre_todo; end
  def todo; end

  private

  def my_name
      :"#{self.class}"
  end
  def initialize _ = Detector.create_flagmethod
      load_tables
  end
  def write
      yield if block_given?
  end
  def writers st200 = em_status200?
      scavange_gool && Table.detect_200[my_name].call if st200
  end
  def load_tables z = Table.detect_200[my_name] = proc {} , x = Table.detect_302[my_name] = proc {}
      Table.detect_gool[my_name] = proc { |s| write { self.dtd_gool_msg s } } 
      Table.xerrors[my_name] = proc { |e| write { self.dtd_err_msg e } }
  end
end
