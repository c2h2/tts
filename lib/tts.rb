module Tts  
  def to_url lang
    langs = ["zh", "en"]
    raise "Not accepted language, accpeted are #{langs * ","}" unless langs.include? lang
    base = "http://translate.google.com/translate_tts?tl=#{lang}&q=#{self}"
  end  

  def to_file

  end
end 

class String
  include Tts
end
