module Zap
    class Spider

        def initialize(params = {})
            #TODO
            #handle it
            @base = params[:base]
            @target = params[:target]
        end

        def start
            #http://localhost:8080/JSON/spider/action/scan/?zapapiformat=JSON&url=http%3A%2F%2F192.168.1.113    
            RestClient::get(Addressable::URI.parse("#{@base}/spider/action/scan/?zapapiformat=JSON&url=#{CGI.escape(@target)}").normalize.to_str)
        end

        def status
            RestClient::get("http://localhost:8080/JSON/spider/view/status/?zapapiformat=JSON")
        end
    end
end
