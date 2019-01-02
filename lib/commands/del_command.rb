class DelCommand < Command
  def self.parse attributes_line
  	match_data = attributes_line.match(/#(\d+)$/)
  	unless match_data.nil?
  		id = match_data[1]
  		{id: id}
  	else
  		{}
  	end
  end

  def execute
    if !Database::Record.owned_by(user).find_by(id: @attributes[:id]).nil?
      HotBot.send "Удалено" if Database::Record.owned_by(user).find_by(id: @attributes[:id]).delete
    else
      HotBot.send  "Ошибка ввода"
    end
  end
end
