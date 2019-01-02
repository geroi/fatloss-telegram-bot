class LangCommand < Command
  def self.parse attributes_line
    {lang: attributes_line}
  end

  def execute
    @environment.bot.track('lang', message.from.id)
  	if $l.set_lang @attributes[:lang]
  		HotBot.send $l.l['lang_set_succ']
  	else
  		HotBot.send $l.l['lang_set_err']
	  end
  end
end
