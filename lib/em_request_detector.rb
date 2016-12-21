require 'eventmachine'
require 'em-http'

module Dt302 
  v302 = Array.new

  define_method :dtf_302 do v302 end

  private

  def dtf_fill302; self.dtf_302 << self.em_page end
end

module DtStatus 
  def status_200?;  my_status == 200 end
  def status_302?;  my_status != 200 end

  status = Fixnum

  define_method :em_reset_status do status = 0 end
  define_method :em_status do self.em_request.response_header.status end
  private
  define_method :my_status do status end
  define_method :set_my_status do status = self.em_status end

  def em_status200?; set_my_status && status_200? end
  def em_status302?; set_my_status && status_302? end
end

module DtPage 
  page = String

  define_method :em_page do page end
  define_method :em_set_page do |site| page = site end 
end

module Server
    module DtRequest 
      include DtPage
      include Dt302
      include DtStatus

      def em_mkrequest &block; em_httprequest ; block.call if block end

      def em_respo; @document = self.em_request.response end 

      request = Object

      define_method :em_request do request end

      private

      define_method :em_httprequest do request = EM::HttpRequest.new( self.em_url, em_options ).get end

      def em_options; { redirects: 3, connect_timeout: 5 } end

    end
    module DtMulti 
        extend self

        multi = Object
        define_method :em_init_multi do multi = EventMachine::MultiRequest.new end 
        define_method :em_multi do multi end 
    end
end
