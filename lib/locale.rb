class Locale
	include Singleton

	def initialize language=:ru
		@@language = language.to_s
		setup('./bases/locale.yaml')
		puts @language
	end

  def setup locale_file
    locale_file = File.open(locale_file)
    @locale_dictionary = YAML.load(locale_file)
    @current_locale = @locale_dictionary
  end

  def locale
  	@current_locale[@@language]
  end

  alias_method :l, :locale

  def set_lang lang
  	if @locale_dictionary.keys.include? lang.to_s
  		@@language = lang.to_s
  		true
  	else
  		false
  	end
  end
end