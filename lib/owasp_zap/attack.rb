module OwaspZap
    class Attack
        def initialize(params = {})
            # TODO
            # handle it
            @base = params[:base]
            @target = params[:target]
            @api_key = params[:api_key]
        end

        def start
            set_query "#{@base}/JSON/ascan/action/scan/?apikey=#{@api_key}"
        end

        def scan_as_user(context_id, user_id)
            set_query "#{@base}/JSON/ascan/action/scanAsUser/", contextId: context_id, userId: user_id
        end

        def status
            url = Addressable::URI.parse("#{@base}/JSON/ascan/view/status/")
            url.query_values = {:zapapiformat=>"JSON",:api_key=>@api_key}
            ret = JSON.parse(RestClient::get url.normalize.to_s)
            if ret.has_key? "status"
                ret["status"].to_i
            else
                100 # it means no running
            end
        end

        def running?
            self.status != 100
        end

        private

        def set_query(addr, params={})
            default_params = {:zapapiformat=>"JSON",:url=>@target, :apikey=>@api_key}
            url = Addressable::URI.parse addr
            url.query_values = default_params.merge params
            RestClient::get url.normalize.to_str
        end

    end
end
