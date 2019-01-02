class ProteinsCommand < Command
  def self.parse attributes_line
  	if attributes_line.match(/^(\d+)$/)
        num = attributes_line.match(/^(\d+)$/)[1].to_i
      else
        num = 0
    end 
    {num: num}
  end

  def execute
    @environment.bot.track('proteins', message.from.id)
    if @attributes[:num] > 0 && @attributes[:num] < 10000
      @environment.user.update(max_proteins: @attributes[:num])
      HotBot.send "#{$l.l['max_proteins_set']} #{@attributes[:num]}"
    else 
      HotBot.send $l.l['input_error']
    end
  end
end
