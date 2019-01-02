module HotBotMethods
  def setup application
    @@bot = application.bot
    @@user = application.user    
  end

  def send_keyboard_with_text text, entries
    list = keyboard entries
    send text, reply_markup: list
  end

  alias_method :send_text_with_keyboard, :send_keyboard_with_text

  def send_keyboard entries
    list = keyboard entries
    send "Выберите один из вариантов", reply_markup: list
  end

  def keyboard entries
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: entries, one_time_keyboard: true, resize_keyboard: true)
  end

  def send text, options={}
    @@bot.api.send_message({chat_id: @@user.chat_id, text: text, parse_mode:'Markdown'}.merge!(options))
  end

  def send_text_hide_keyboard text
    kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
    send text, reply_markup: kb
  end
end
class HotBot
  extend HotBotMethods
end