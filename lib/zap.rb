require "json"
require 'rest_client'
require 'addressable/uri'
require 'cgi'

require_relative "zap/version"
require_relative "zap/spider"
require_relative "zap/attack"
require_relative "zap/alert"

module Zap
    class ZapException < Exception;end
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
            Zap::Alert.new(:base=>@base,:target=>@target).view
        end
        
        #attack
        def ascan
            Zap::Attack.new(:base=>@base,:target=>@target).start
        end

        def spider
            Zap::Spider.new(:base=>@base,:target=>@target).start
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
   end
end
