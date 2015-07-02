module OwaspZap
    class Attack
        def initialize(params = {})
            # TODO
            # handle it
            @base = params[:base]
            @target = params[:target]
        end

        def start
            url = Addressable::URI.parse("#{@base}/JSON/ascan/action/scan/")
            url.query_values = {:zapapiformat=>"JSON",:url=>@target}
            RestClient::get url.normalize.to_str
        end

        def scan_as_user(context_id, user_id)
            url = Addressable::URI.parse("#{@base}/JSON/ascan/action/scanAsUser/")
            url.query_values = {:zapapiformat=>"JSON",:url=>@target, contextId: context_id, userId: user_id}
            RestClient::get url.normalize.to_str
        end

        def status
            ret = JSON.parse(RestClient::get("#{@base}/JSON/ascan/view/status/?zapapiformat=JSON"))
            if ret.has_key? "status"
                ret["status"].to_i
            else
                100 # it means no running
            end
        end

        def running?
            self.status != 100
        end

    end
end
