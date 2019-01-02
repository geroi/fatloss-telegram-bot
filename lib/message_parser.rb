class MessageParser # => {:command_name, :command_attributes={:name, :protein, :fat, :calories, :g_per_piece}}
  def initialize message
    @message = message.text.mb_chars.downcase!
    @strategy = case get_first_char
      when '/'
        CommandParser.new @message
      else
        ElseParser.new @message
      end
  end

  def parse
    begin
      @strategy.parse
    rescue Exception => e  
      puts e.message  
      puts e.backtrace.inspect 
      HotBot.send $l.l['input_error']
      {} #Неправильный ввод данных
    end
  end

  def get_first_char
    @message[0]
  end
end