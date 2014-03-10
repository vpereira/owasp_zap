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

    it "base shouldnt be nil" do
        @zap.base.wont_be :nil?
    end
end

