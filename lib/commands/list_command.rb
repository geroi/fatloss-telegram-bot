class ListCommand < Command
  def self.parse attributes_line
    {}
  end

  def execute
    @environment.bot.track('list', message.from.id)
    counter = 0
    msg = ""
    ary = Database::Food.base_and_owned_by(@environment.user).all

    while counter < ary.length
      for j in 1..10
        msg << "#{ary[counter].name}\n"
        counter+=1
        
        if counter == ary.length 
          break
        end
      
      end
      bot.api.send_message(chat_id: message.chat.id, text: msg)
      msg = ""
    end
  end
end
