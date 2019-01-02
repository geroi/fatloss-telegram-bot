class HelpCommand < Command
  def self.parse attributes_line
    # HotBot.send attributes_line
    if attributes_line && !attributes_line.empty?
      {command: attributes_line}
    else
     {command: ''}
    end
  end

  def execute
    if @attributes[:command].empty?
      list = []
      $l.l['help_entries'].keys.each do |key|
          list.push "/help #{key}"
        end
  	   HotBot.send_text_with_keyboard $l.l['help_message'], list
    else
      if $l.l['help_entries'].keys.include? @attributes[:command]
        HotBot.send $l.l["example"]
        HotBot.send $l.l["help_entries"][@attributes[:command].to_s]["input"]
        HotBot.send $l.l["help_entries"][@attributes[:command].to_s]["text"]
      end
    end
  end
end
