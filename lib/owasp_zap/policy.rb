module OwaspZap
    class Policy
        def initialize(params = {})
            @base = params[:base]
        end

        def all(format = "JSON")
            # http://127.0.0.1:8080/JSON/ascan/view/policies/?zapapiformat=JSON
            url = Addressable::URI.parse "#{@base}/#{format}/ascan/view/policies/"
            url.query_values = {:zapapiformat=>format}
            RestClient::get url.normalize.to_str
        end
    end
end
