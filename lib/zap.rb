require "json"
require 'rest_client'
require 'addressable/uri'
require 'cgi'

require "./zap/version"
require "./zap/spider"
require "./zap/attack"
require "./zap/alert"

module Zap
    class ZapException < Exception;end
    class ZapV2
       attr_accessor :target,:base

       def initialize(params = {})
            #TODO
            # handle params
            @base = "http://127.0.0.1:8080/JSON"
            @target = params[:target]
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
        #
        #attack
        def ascan
            Zap::Attack.new(:base=>@base,:target=>@target).start
        end

        def spider
            Zap::Spider.new(:base=>@base,:target=>@target).start
        end
   end
end
