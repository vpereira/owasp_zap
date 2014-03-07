module Zap
    class Attack
        def initialize(params = {})
            #TODO
            #handle it
            @base = params[:base]
            @target = params[:target]
        end

        def start
            RestClient::get(Addressable::URI.parse("#{@base}/ascan/action/scan/?zapapiformat=JSON&url=#{CGI.escape(@target)}").normalize.to_str)
        end

        def status
            RestClient::get("#{@base}/ascan/view/status/?zapapiformat=JSON")
        end

    end
end
