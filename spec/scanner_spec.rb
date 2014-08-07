require 'helper'

describe OwaspZap::Alert do
    before do
        @scanner = OwaspZap::Scanner.new :base=>"http://127.0.0.1:8080"
    end
    it "should not be_nil" do
        refute @scanner.nil?
    end
    it "should respond_to view" do
        @scanner.must_respond_to :view
    end
    it "enable should return true" do
        stub_request(:get, "http://127.0.0.1:8080/JSON/ascan/action/enableScanners/?ids=0,1&zapapiformat=JSON").to_return(:status => 200, :body => "{\"Result\":\"OK\"}" , :headers => {})
        @scanner.enable([0,1]).wont_be_nil
    end
    it "disable should return true" do
        stub_request(:get, "http://127.0.0.1:8080/JSON/ascan/action/disableScanners/?ids=0,1&zapapiformat=JSON").to_return(:status => 200, :body => "{\"Result\":\"OK\"}" , :headers => {})
        @scanner.disable([0,1]).wont_be_nil
    end
end
