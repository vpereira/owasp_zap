require "json"
require 'rest_client'
require 'addressable/uri'
require 'cgi'

require_relative "zap/version"
require_relative "zap/spider"
require_relative "zap/attack"
require_relative "zap/alert"
require_relative "zap/auth"

module Zap
    class ZapException < Exception;end

    # extending String instance
    module StringExtension
        # from camel_case to snake_case: ie: fooBar to foo_bar
        def snake_case
          return downcase if match(/\A[A-Z]+\z/)
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z])([A-Z])/, '\1_\2').
          downcase
        end
        # from snake_case to camel_case: ie: foo_bar to fooBar
        def camel_case
          self.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        end
    end

    class ZapV2
       attr_accessor :target,:base

       def initialize(params = {})
            #TODO
            # handle params
            @base = params[:base] || "http://127.0.0.1:8080/JSON"
            @target = params[:target]
            @zap_bin = params [:zap] || "#{ENV['HOME']}/ZAP/zap.sh"
        end

        def status_for(component)
            case component
            when :ascan
                Zap::Attack.new(:base=>@base,:target=>@target).status
            when :spider
                Zap::Spider.new(:base=>@base,:target=>@target).status
            else
                {:status=>"unknown component"}.to_json
            end

        end
        def ok?(json_data)
            json_data.is_a?(Hash) and json_data[0] == "OK"
        end

        def alerts
            Zap::Alert.new(:base=>@base,:target=>@target)
        end
        
        #attack
        def ascan
            Zap::Attack.new(:base=>@base,:target=>@target)
        end

        def spider
            Zap::Spider.new(:base=>@base,:target=>@target)
        end

        def auth
            Zap::Auth.new(:base=>@base) 
        end

        #TODO
        #DOCUMENT the step necessary: install ZAP under $home/ZAP or should be passed to new as :zap parameter
        def start
            fork do
               exec @zap_bin 
            end
        end

        #shutdown zap
        def shutdown
            RestClient::get "#{@base}/core/action/shutdown/"
        end

        #xml report
        #maybe it should be refactored to alert. 
        def xml_report
            RestClient::get "#{@base}/OTHER/core/other/xmlreport/"
        end
   end
end
