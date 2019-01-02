class InfoCommand < Command
  def self.parse attributes_line
  	@@info_double_flag = false
    {food_name: attributes_line}    
  end

  def execute
    @environment.bot.track('info', message.from.id)
    puts @attributes_line
    if @attributes.nil? || @attributes[:food_name].nil?
      food = nil
    else
      food_name = @attributes[:food_name]
      if @@info_double_flag
        food = Database::Food.base_and_owned_by(@environment.user).find_by(name:"#{food_name}") # Food or nil
      else
        food = Database::Food.base_and_owned_by(@environment.user).where("name LIKE ?", "%#{food_name}%") # Relation 
      end
    end

    if food.kind_of?(ActiveRecord::Relation)
        if food.length > 1
            answers_ary = []
              for x in 0...food.length do
                answers_ary.push("/info #{food[x].name}")
              end  
            @@info_double_flag = true
            HotBot.send_text_with_keyboard $l.l['several_found'], answers_ary
        elsif food.length == 1
          food = food[0]
        else
          food = nil
          @@info_double_flag = false
        end
    end

    if food.kind_of?(Database::Food)
        HotBot.send_text_hide_keyboard "#{food.name}\n#{$l.l['proteins']} #{food.protein}\n"\
        "#{$l.l['fats']} #{food.fat}\n#{$l.l['carbs']} #{food.carb}\n#{$l.l['carbs']} #{food.calories}\n"\
        "#{food.g_per_piece} #{$l.l['weights_one_piece'] if food.g_per_piece}"
        @@info_double_flag = false
    elsif !@@info_double_flag
        HotBot.send $l.l['no_product']
        @@info_double_flag = false
    end   

  end

end
