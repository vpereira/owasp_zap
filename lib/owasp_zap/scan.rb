module OwaspZap
    class Scan
        def initialize(params = {})
            @base = params[:base]
            @target = params[:target]
        end
        def start
            url = Addressable::URI.parse "#{@base}/scan/action/scan/"
            url.query_values = {:zapapiformat=>"JSON",:url=>@target}
            RestClient::get url.normalize.to_str
        end
        def status
            JSON.parse RestClient::get("#{@base}/scan/view/status/?zapapiformat=JSON")
        end
    end
end
