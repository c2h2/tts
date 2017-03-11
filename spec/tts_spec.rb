# encoding: utf-8
require File.expand_path("../../lib/tts", __FILE__)
require "rspec"

describe "to_valid_fn method" do
  # fn.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')
  it "should replace * with _" do
    "hello*nice".to_valid_fn.should == "hello_nice"
    "hello*nice*hello".to_valid_fn.should == "hello_nice_hello"
  end

  it "should replace / with _" do
    "hello/nice".to_valid_fn.should == "hello_nice"
    "hello/nice/hello".to_valid_fn.should == "hello_nice_hello"
  end

  it "should replace / with _" do
    "hello:nice".to_valid_fn.should == "hello_nice"
    "hello:nice:hello".to_valid_fn.should == "hello_nice_hello"
  end

  it "should replace / with _" do
    "hello?nice".to_valid_fn.should == "hello_nice"
    "hello?nice?hello".to_valid_fn.should == "hello_nice_hello"
  end

  it "should replace / with _" do
    "hello|nice".to_valid_fn.should == "hello_nice"
    "hello|nice?hello".to_valid_fn.should == "hello_nice_hello"
  end

end

describe 'to_url method' do
  it "to_url should return a correct string" do
    "hello".to_url("en").should == "http://translate.google.com/translate_tts?tl=en&ie=UTF-8&client=tw-ob&q=hello"
  end

  it "to_url should return a correct string with chinese char" do
    "人民广场".to_url("zh").should == "http://translate.google.com/translate_tts?tl=zh&ie=UTF-8&client=tw-ob&q=%E4%BA%BA%E6%B0%91%E5%B9%BF%E5%9C%BA"
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

  it "to_file should generate a mp3 file for a correct simplified chinese string" do
    "人民广场马上到了".to_file("zh-CN")
    File.exist?("人民广场马上到了.mp3").should be_true
    File.delete("人民广场马上到了.mp3")
  end

  it "to_file should fail a non-exist language" do
    expect{"人民广场马上到了".to_file("dummy")}.should raise_error(RuntimeError)
    File.exist?("人民广场马上到了.mp3").should be_false
  end

end

describe 'generate a correct mp3 file with long text and play via mpg123' do
  it "should playback a correct test mp3 file" do
    "Testing sound with the ruby gem TTS... if you hear the sound correctly, This single test is passed. Thank you very much for you patience...".play
  end

  it "should playback a correct Chinese test mp3 file" do
    "谢谢测试。测试通过".play("zh")
  end
end

describe 'set a server url' do
  before(:all) do
    Tts.server_url  "http://127.0.0.1:3001/translate_tts"
  end

  it "to_url should return a correct string" do
    "hello".to_url("en").should == "http://127.0.0.1:3001/translate_tts?tl=en&ie=UTF-8&client=tw-ob&q=hello"
  end
end
