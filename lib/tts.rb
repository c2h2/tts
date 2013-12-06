# encoding: utf-8
require 'open-uri'
require 'uri'

module Tts
  @@default_url = "http://translate.google.com/translate_tts"
  @@user_agent  = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.68 Safari/534.24"  

  def to_file lang, file_name=nil
    parts = validate_text_length(self)
    file_name = generate_file_name(self[0..20]) if file_name.nil?
    parts.each do |part|
      url = part.to_url(lang)
      fetch_mp3(url, file_name) 
    end
  end
  
  def validate_text_length text
    if text.length > 100
      chunk_text(text)
    else 
      [text]
    end
  end

  def chunk_text text
    chunks = []
    words = split_into_words(text)
    chunk = ''
    words.each do |word|
      if (chunk.length + word.length) > 100
        chunks << chunk.strip!
        chunk = ''
      end
      chunk += "#{word} "
    end
    chunks << chunk.strip!
  end

  def split_into_words text
    text.gsub(/\s+/m, ' ').strip.split(" ")
  end

  def generate_file_name text
    to_valid_fn(text + ".mp3")
  end

  def to_valid_fn fn
    fn.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')
  end

  def to_url lang
    langs = ["zh", "en", "it", "fr"]
    raise "Not accepted language, accpeted are #{langs * ","}" unless langs.include? lang
    base = "#{Tts.server_url}?tl=#{lang}&q=#{URI.escape self}"
  end

  def fetch_mp3 url, file_name
    begin 
      content = open(url, "User-Agent" => @@user_agent).read
 
      File.open("temp.mp3", "wb") do |f|
        f.puts content
      end
      merge_mp3_file(file_name)
    rescue => e
      $stderr.puts("Internet error! #{e.message}")
      exit(1)
    end
  end

  def merge_mp3_file file_name
    `cat temp.mp3 >> "#{file_name}" && rm temp.mp3`
  end

end

class String
  include Tts
end
