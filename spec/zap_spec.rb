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
        assert_respond_to @zap,:base
    end

    it "should have method start" do
        assert_respond_to @zap,:start
    end

    it "should have a method shutdown" do
        assert_respond_to @zap,:shutdown
    end

    it "should respond_to to spider" do
        assert_respond_to @zap,:spider
    end

    it "should call spider and get a spider object" do
        assert_equal @zap.spider.class,Zap::Spider
    end

    it "should respond_to auth" do
        assert_respond_to @zap,:auth
    end

    it "should call auth and get an auth object" do
        assert_equal @zap.auth.class, Zap::Auth
    end

    it "should respond_to ascan" do 
        assert_respond_to @zap,:ascan
    end

    it "should call ascan and get an attack object" do
        assert_equal @zap.ascan.class, Zap::Attack
    end

    it "should respond_to alerts" do
        assert_respond_to @zap,:alerts
    end

    it "should call alerts and get a alert object" do
        assert_equal @zap.alerts.class,Zap::Alert
    end

    it "base shouldnt be nil" do
        @zap.base.wont_be :nil?
    end

    it "base default should be http://127.0.0.1:8080/JSON" do
        assert_equal @zap.base, "http://127.0.0.1:8080/JSON"
    end
end

describe "changing default params" do
    it "should be able to set base" do
        @zap = ZapV2.new(:target=>'http://127.0.0.1',:base=>'http://127.0.0.2:8383')
        assert_equal @zap.base, "http://127.0.0.2:8383"
    end
end

describe "method shutdown" do
    before do
        @h = Zap::ZapV2.new :target=>"http://127.0.0.1"
        stub_request(:get, "http://127.0.0.1:8080/JSON/core/action/shutdown/").to_return(:status => 200, :body => "{\"Result\":\"OK\"}" , :headers => {})
    end

    it "should receive a json as answer" do
         @h.shutdown.wont_be :nil?
    end
    it "should request the shutdown url" do
        @h.shutdown
        assert_requested :get,"http://127.0.0.1:8080/JSON/core/action/shutdown/"
    end

end

describe "StringExtension" do
    it "should not respond_to camel_case and snake_case" do
        @str = "" 
        [:camel_case,:snake_case].each do |m|
            refute_respond_to(@str,m)
        end
    end
     it "should respond_to camel_case and snake_case" do
        @str = "" 
        @str.extend Zap::StringExtension
        [:camel_case,:snake_case].each do |m|
            assert_respond_to @str,m
        end
    end
    it "should answer to camel_case" do
        @str = "foo_bar"
        @str.extend Zap::StringExtension
        assert_equal @str.camel_case,"fooBar"
    end
    it "should answer to snake_case" do
        @str = "fooBar"
        @str.extend Zap::StringExtension
        assert_equal @str.snake_case,"foo_bar" 
    end
end
