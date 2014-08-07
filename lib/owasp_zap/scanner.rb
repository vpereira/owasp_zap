module OwaspZap
    # TODO 
    # maybe create a policy class as well
    class Scanner
        def initialize(params = {})
            @base = params[:base]
        end

        def view(policy_id = 0)
            # http://127.0.0.1:8080/JSON/ascan/view/scanners/?zapapiformat=JSON&policyId=0
            url = Addressable::URI.parse("#{@base}/JSON/ascan/view/scanners/")
            url.query_values = {:zapapiformat=>"JSON",:policyId=>policy_id}
            RestClient::get url.normalize.to_str
        end

        def disable(policy_ids=[0])
            # http://127.0.0.1:8080/JSON/ascan/action/disableScanners/?zapapiformat=JSON&ids=0
            url = Addressable::URI.parse("#{@base}/JSON/ascan/action/disableScanners/")
            url.query_values = {:zapapiformat=>"JSON",:ids=>policy_ids.join(',')}
            RestClient::get url.normalize.to_str
        end

        def enable(policy_ids=[0])
            # http://127.0.0.1:8080/JSON/ascan/action/enableScanners/?zapapiformat=JSON&ids=0
            url = Addressable::URI.parse("#{@base}/JSON/ascan/action/enableScanners/")
            url.query_values = {:zapapiformat=>"JSON",:ids=>policy_ids.join(',')}
            RestClient::get url.normalize.to_str
        end
    end
end
