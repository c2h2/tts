# encoding: utf-8
require 'open-uri'
require 'uri'

module Tts
  @@default_url = "http://translate.google.com/translate_tts"
  @@user_agent  = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.68 Safari/534.24"  
  @@referer     = "http://translate.google.com/"

  def self.server_url url=nil
    return @@default_url if url.nil?
    @@default_url = url
  end

  def to_file lang, file_name=nil
    parts = validate_text_length(self)
    file_name = self[0..20].generate_file_name if file_name.nil?
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

  def generate_file_name
    to_valid_fn + ".mp3"
  end

  def to_valid_fn 
    gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')
  end

  def to_url lang
    langs = ['af', 'ar', 'az', 'be', 'bg', 'bn', 'ca', 'cs', 'cy', 'da', 'de', 'el', 'en', 'en_us', 'en_gb', 'en_au', 'eo', 'es', 'et', 'eu', 'fa', 'fi', 'fr', 'ga', 'gl', 'gu', 'hi', 'hr', 'ht', 'hu', 'id', 'is', 'it', 'iw', 'ja', 'ka', 'kn', 'ko', 'la', 'lt', 'lv', 'mk', 'ms', 'mt', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sl', 'sq', 'sr', 'sv', 'sw', 'ta', 'te', 'th', 'tl', 'tr', 'uk', 'ur', 'vi', 'yi', 'zh', 'zh-CN', 'zh-TW']
    raise "Not accepted language, accpeted are #{langs * ","}" unless langs.include? lang
    base = "#{Tts.server_url}?tl=#{lang}&ie=UTF-8&client=tw-ob&q=#{URI.escape self}"
  end

  def fetch_mp3 url, file_name
    begin 
      content = open(url, "User-Agent" => @@user_agent, "Referer" => @@referer).read
 
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

  def play lang="en", times=1, pause_gap = 1 
    #test if mpg123 exists?
    `which mpg123`
    if $?.to_i != 0
      puts "mpg123 executable NOT found. This function only work with POSIX systems.\n Install mpg123 with `brew install mpg123` or `apt-get install mpg123`"
      exit 1
    end
    fn = "tts_playonce"
    self.to_file(lang, fn)
    times.times{|i| `mpg123 -q #{fn}`}
    File.delete(fn)
  end

end

class String
  include Tts
end
