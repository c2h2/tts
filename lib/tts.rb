module Tts  
  def to_url lang
    require 'uri'
    langs = ["zh", "en", "it", "fr"]
    #raise "Not accepted language, accpeted are #{langs * ","}" unless langs.include? lang
    base = "http://translate.google.com/translate_tts?tl=#{lang}&q=#{URI.escape self}"
  end  

  def to_file lang, file_name=nil
    require 'open-uri'
    file_name = self +".mp3" if file_name.nil?
    url = self.to_url(lang)
    ua = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.68 Safari/534.24"
    content = open(url, "User-Agent" => ua).read
    File.open(file_name, "wb") do |f|
      f.puts content
    end
  end
end 

class String
  include Tts
end
