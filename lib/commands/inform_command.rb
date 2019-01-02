class InformCommand < Command
  def parse attributes_line
    {}
  end

  def execute
    @environment.bot.track('inform', message.from.id)
      if user.inform
        HotBot.send 'Информирование о следующем приеме пищи ОТКЛЮЧЕНО'
      else
        HotBot.send 'Информирование о следующем приеме пищи ВКЛЮЧЕНО'
      end
      user.update(inform: !user.inform)
  end
end