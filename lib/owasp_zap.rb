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
       attr_reader :api_key
       def initialize(params = {})
            #TODO
            # handle params
            @base = params[:base] || "http://127.0.0.1:8080"
            @target = params[:target]
            @api_key = params[:api_key]
            @zap_bin = params [:zap] || "#{ENV['HOME']}/ZAP/zap.sh"
            @output = params[:output] || $stdout #default we log everything to the stdout
        end

        def status_for(component)
            case component
            when :ascan
                Zap::Attack.new(:base=>@base,:target=>@target).status
            when :spider
                Zap::Spider.new(:base=>@base,:target=>@target).status
            when :scan
                Zap::Scan.new(:base=>@base,:target=>@target).status
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

        def policy
            Zap::Policy.new(:base=>@base)
        end

        def alerts
            Zap::Alert.new(:base=>@base,:target=>@target)
        end

        def scanner
            Zap::Scanner.new(:base=>@base)
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

        # TODO
        # DOCUMENT the step necessary: install ZAP under $home/ZAP or should be passed to new as :zap parameter
        def start(params = {})
            # default we are disabling api key
            params = {api_key:false}.merge(params)
            cmd_line = "#{@zap_bin}"
            case
            when params.key?(:daemon)
              cmd_line += " -daemon"
            when params.key?(:api_key)
              cmd_line += if params[:api_key] == true
                " -config api.key=#{@api_key}"
              else
                " -config api.disablekey=true"
              end
            end
            if params.key?(:host)
                cmd_line += " -host #{params[:host]}"
            end
            if params.key?(:port)
                cmd_line += " -port #{params[:port]}"
            end
            fork do
               # if you passed :output=>"file.txt" to the constructor, then it will send the forked process output
               # to this file (that means, ZAP stdout)
               unless @output == $stdout
                STDOUT.reopen(File.open(@output, 'w+'))
                STDOUT.sync = true
               end
               print "Running the following command: #{cmd_line} \n"

               exec cmd_line

            end
            Process.wait if params.key? :asynch
        end

        #shutdown zap
        def shutdown
            RestClient::get "#{@base}/JSON/core/action/shutdown/"
        end

        #xml report
        #maybe it should be refactored to alert.
        def xml_report
            RestClient::get "#{@base}/OTHER/core/other/xmlreport/"
        end

        def html_report
            RestClient::get "#{@base}/OTHER/core/other/htmlreport/"
        end
   end
end
