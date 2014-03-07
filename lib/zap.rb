require "json"
require 'rest_client'
require 'addressable/uri'
require 'cgi'

require "./zap/version"
require "./zap/spider"

module Zap
    class ZapException < Exception;end
    class ZapV2
       def initialize(params = {})
            @base = "http://127.0.0.1:8080/JSON"
            @target = params[:target]
        end

        def uri(action)
            params = {
                :alerts=>"baseurl",
                :ascan=>"url",
                :spider=>"url",
            }
            Addressable::URI.parse("#{@base}/spider/action/#{action}/?zapapiformat=JSON&#{params[action]}=#{CGI.escape(@target)}").normalize.to_str
        end

        def index
            RestClient.get(@base).body
        end

        def ok?(json_data)
            json_data.is_a?(Hash) and json_data[0] == "OK"
        end

        def alerts
            #http://localhost:8080/JSON/core/view/alerts/?zapapiformat=JSON&baseurl=http%3A%2F%2F192.168.1.113&start=&count=
            RestClient.get(uri(:alerts))
        end
        #attack
        def ascan
            #http://localhost:8080/JSON/ascan/action/scan/?zapapiformat=JSON&url=http%3A%2F%2F192.168.1.113&recurse=&inScopeOnly=
            RestClient.get(uri(:ascan))
        end

        def shutdown
        end

        def spider
            Zap::Spider.new(:base=>@base,:target=>@target).start
        end
   end
    #load all others requirements
end
