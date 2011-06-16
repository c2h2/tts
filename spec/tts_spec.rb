require File.expand_path("../../lib/tts", __FILE__)
require "rspec"

describe 'testing' do
  it "to_url should return a correct string" do
    "hello".to_url("en").should == "http://translate.google.com/translate_tts?tl=en&q=hello"
  end
end
