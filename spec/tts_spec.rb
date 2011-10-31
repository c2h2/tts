# encoding: utf-8
require File.expand_path("../../lib/tts", __FILE__)
require "rspec"

describe "to_valid_fn method" do
  # Tts.server_url  "http://127.0.0.1:3001/translate_tts"

  # fn.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')
  it "should replace * with _" do
    to_valid_fn("hello*nice").should == "hello_nice"
    to_valid_fn("hello*nice*hello").should == "hello_nice_hello"
  end

  it "should replace / with _" do
    to_valid_fn("hello/nice").should == "hello_nice"
    to_valid_fn("hello/nice/hello").should == "hello_nice_hello"
  end

  it "should replace / with _" do
    to_valid_fn("hello:nice").should == "hello_nice"
    to_valid_fn("hello:nice:hello").should == "hello_nice_hello"
  end

  it "should replace / with _" do
    to_valid_fn("hello?nice").should == "hello_nice"
    to_valid_fn("hello?nice?hello").should == "hello_nice_hello"
  end

  it "should replace / with _" do
    to_valid_fn("hello|nice").should == "hello_nice"
    to_valid_fn("hello|nice?hello").should == "hello_nice_hello"
  end

end

describe 'to_url method' do
  it "to_url should return a correct string" do
    "hello".to_url("en").should == "http://translate.google.com/translate_tts?tl=en&q=hello"
  end

  it "to_url should return a correct string with chinese char" do
    "人民广场".to_url("zh").should == "http://translate.google.com/translate_tts?tl=zh&q=%E4%BA%BA%E6%B0%91%E5%B9%BF%E5%9C%BA"
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

  it "to_file should generate a mp3 file for a correct chinese string" do
    "人民广场到了".to_file("zh")
    File.exist?("人民广场到了.mp3").should be_true
    File.delete("人民广场到了.mp3")
  end

end

describe 'set a server url' do
  before(:all) do
    Tts.server_url  "http://127.0.0.1:3001/translate_tts"
  end

  it "to_url should return a correct string" do
    "hello".to_url("en").should == "http://127.0.0.1:3001/translate_tts?tl=en&q=hello"
  end



end
