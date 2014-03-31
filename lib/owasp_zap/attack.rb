module OwaspZap
    class Attack
        def initialize(params = {})
            #TODO
            #handle it
            @base = params[:base]
            @target = params[:target]
        end

        def start
            url = Addressable::URI.parse "#{@base}/ascan/action/scan/"
            url.query_values = {:zapapiformat=>"JSON",:url=>@target}
            RestClient::get url.normalize.to_str
        end

        def status
            RestClient::get "#{@base}/ascan/view/status/?zapapiformat=JSON"
        end

    end
end
