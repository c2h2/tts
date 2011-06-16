require File.expand_path("../../lib/tts", __FILE__)
require "rspec"

describe 'to_url method' do
  it "to_url should return a correct string" do
    "hello".to_url("en").should == "http://translate.google.com/translate_tts?tl=en&q=hello"
  end
end

describe 'to_file method' do
  it "to_file should generate a mp3 file for a correct string" do
    "hello".to_file("en")
    File.exist?("hello.mp3").should be_true
    File.delete("hello.mp3")
  end
  
  it "to_file should generate a mp3 file with given name for a correct string" do
    "hello".to_file("en", "my_hello.mp3")
    File.exist?("my_hello.mp3").should be_true
    File.delete("my_hello.mp3")
  end
  
end
