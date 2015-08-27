require "json"
require "rest_client"
require "addressable/uri"
require "cgi"
require "logger"

require_relative "owasp_zap/version"
require_relative "owasp_zap/error"
require_relative "owasp_zap/string_extension"
require_relative "owasp_zap/spider"
require_relative "owasp_zap/attack"
require_relative "owasp_zap/alert"
require_relative "owasp_zap/auth"
require_relative "owasp_zap/scanner"
require_relative "owasp_zap/policy"

module OwaspZap
    class ZapException < Exception;end

    class Zap
       attr_accessor :target,:base, :zap_bin

       def initialize(params = {})
            #TODO
            # handle params
            @base = params[:base] || "http://127.0.0.1:8080"
            @target = params[:target]
            @zap_bin = params [:zap] || "#{ENV['HOME']}/ZAP/zap.sh"
            @api_key = ENV['API_KEY'] || random_token 
            @output = params[:output] || $stdout #default we log everything to the stdout
        end

        def status_for(component)
            case component
            when :ascan
                Zap::Attack.new(:base=>@base,:target=>@target, :api_key=>@api_key).status
            when :spider
                Zap::Spider.new(:base=>@base,:target=>@target, :api_key=>@api_key).status
            when :scan
                Zap::Scan.new(:base=>@base,:target=>@target, :api_key=>@api_key).status
            else
                {:status=>"unknown component"}.to_json
            end

        end

        def ok?(json_data)
            json_data.is_a?(Hash) and json_data[0] == "OK"
        end

        def random_token
            o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
            string = (0...50).map { o[rand(o.length)] }.join
        end

        def running?
            begin
                response = RestClient::get "#{@base}"
            rescue Errno::ECONNREFUSED
                return false
            end
            response.code == 200
        end

        def policy
            Zap::Policy.new(:base=>@base)
        end

        def alerts
            OwaspZap::Alert.new(:base=>@base,:target=>@target, :api_key=>@api_key)
        end
        
        def scanner
            OwaspZap::Scanner.new(:base=>@base, :api_key=>@api_key)
        end

        #attack
        def ascan
            OwaspZap::Attack.new(:base=>@base,:target=>@target, :api_key=>@api_key)
        end

        def spider
            OwaspZap::Spider.new(:base=>@base,:target=>@target, :api_key=>@api_key)
        end

        def auth
            OwaspZap::Auth.new(base: @base, target: @target, api_key: @api_key) 
        end

        # TODO
        # DOCUMENT the step necessary: install ZAP under $home/ZAP or should be passed to new as :zap parameter
        def start(params = {})
            
            cmd_line = "#{@zap_bin} -config api.key=#{@api_key}" 

            cmd_line += " -daemon" if params[:daemon]

            fork do
               # if you passed :output=>"file.txt" to the constructor, then it will send the forked process output
               # to this file (that means, ZAP stdout)
               unless @output == $stdout
                STDOUT.reopen(File.open(@output, 'w+'))
                STDOUT.sync = true 
               end
               exec cmd_line
            end
        end

        #shutdown zap
        def shutdown
            RestClient::get "#{@base}/JSON/core/action/shutdown/?apikey=#{@api_key}"
            sleep 1 if running?
        end

        #xml report
        #maybe it should be refactored to alert. 
        def xml_report
            RestClient::get "#{@base}/OTHER/core/other/xmlreport/?apikey=#{@api_key}"
        end
        
        def html_report
            RestClient::get "#{@base}/OTHER/core/other/htmlreport/?apikey=#{@api_key}"
        end
   end
end
