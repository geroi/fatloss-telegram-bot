class MylistCommand < Command
  def self.parse attrs
    {}
  end

  def execute
    @environment.bot.track('my_list', message.from.id)
    user_food = Database::Food.owned_by(@environment.user)
      unless user_food.empty?
          user_food.each {|food|
            message = "#{food.name}\n"\
                        "#{$l.l['proteins']} #{food.protein}\n"\
                        "#{$l.l['fats']} #{food.fat}\n"\
                        "#{$l.l['carbs']} #{food.carb}\n"\
                        "#{$l.l['calories']} #{food.calories}\n"
            unless food.g_per_piece.nil?
              message << "#{$l.l['weights_one_piece']} #{food.g_per_piece} #{$l.l['grams_per_piece']}"
            end
          HotBot.send message
          }
      else
         HotBot.send $l.l['no_private_products']
      end
  end
end