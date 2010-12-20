framework 'Foundation'
class String
  def language
    CFStringTokenizerCopyBestStringLanguage(self, CFRangeMake(0, self.size))
  end
end


msgs = ["Bonne année!", "Happy new year!", "¡Feliz año nuevo!", "Felice anno nuovo!", "أعياد سعيدة",
 "明けましておめでとうございます。"]

msgs.each do |msg|
  puts "#{msg} (#{msg.language})"
end
