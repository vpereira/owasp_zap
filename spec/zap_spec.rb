require 'helper'

include Zap

describe ZapV2 do
    before do
        @zap = ZapV2.new(:target=>'http://127.0.0.1')
    end

    it "shouldnt be nil" do
        @zap.wont_be :nil?
    end

    it "should have a target" do
        @zap.respond_to? :target
    end

    it "target shouldnt be nil" do
        @zap.target.wont_be :nil?
    end

    it "should have a base" do
        @zap.respond_to? :base
    end

    it "should have method start" do
        @zap.respond_to? :start
    end

    it "should have a method shutdown" do
        @zap.respond_to? :shutdown
    end
    it "base shouldnt be nil" do
        @zap.base.wont_be :nil?
    end

    it "base default should be http://127.0.0.1:8080/JSON" do
        @zap.base == "http://127.0.0.1:8080/JSON"
    end
end

describe "changing default params" do
    it "should be able to set base" do
        @zap = ZapV2.new(:target=>'http://127.0.0.1',:base=>'http://127.0.0.2:8383')
        @zap.base == "http://127.0.0.2:8383"
    end
end

describe "method shutdown" do
    before do
        @h = Zap::ZapV2.new :target=>"http://127.0.0.1"
        stub_request(:get, "http://127.0.0.1:8080/JSON/core/action/shutdown/").with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).to_return(:status => 200, :body => "{\"Result\":\"OK\"}" , :headers => {})



    end
    it "should receive a json as answer" do
         @h.shutdown.wont_be :nil?
    end

end
