class StartCommand < Command
  def self.parse attributes_line
    {}
  end

  def execute
    @environment.bot.track('start', message.from.id) #еще можно добавить хэш и доп опций
    HotBot.send "#{$l.l['hello']}, #{@message.from.first_name} "\
    "#{@message.from.last_name}! #{$l.l['greetings_message']}"
  end
end