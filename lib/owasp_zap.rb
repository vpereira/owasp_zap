require "json"
require "rest_client"
require "addressable/uri"
require "cgi"

require_relative "owasp_zap/version"
require_relative "owasp_zap/string_extension"
require_relative "owasp_zap/spider"
require_relative "owasp_zap/attack"
require_relative "owasp_zap/alert"
require_relative "owasp_zap/auth"

module OwaspZap
    class ZapException < Exception;end

    class Zap
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

        def running?
            begin
                response = RestClient::get "#{@base}"
            rescue Errno::ECONNREFUSED
                return false
            end
            response.code == 200
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
        def start(params = {})
            cmd_line = if params.key? :daemon
                "#{@zap_bin} -daemon"
            else
                @zap_bin
            end
            fork do
               exec cmd_line
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
