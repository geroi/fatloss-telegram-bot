# TelegramMessage
# Environment = Application
# Attributes
class AddRecordCommand < Command
  def self.parse message_text
    parsed_message_match_data = message_text.match(/^(.+[^0-9])\s(\d+)(\s?шт[.]?)?$/)
    if parsed_message_match_data
      product = Product.new({
        name: parsed_message_match_data[1],
        weight: parsed_message_match_data[2],
        piece_flag: !!parsed_message_match_data[3]
        })
      result_hash = {
          command_attributes: product.to_hash,
          command_name: 'AddRecord'
        }
    else
      raise InputDataError
    end
  end

  def search_for_food product
    if product.searched?
        Database::Food.base_and_owned_by(user).find_by(name:"#{product.name}") # Food or nil
      else
        Database::Food.base_and_owned_by(user).where("name LIKE ?", "%#{product.name}%") # Relation 
    end
  end

  def execute
    @environment.bot.track('add_record', message.from.id)
    product = Product.new(@attributes)
    food = search_for_food product

      if food.is_a?(ActiveRecord::Relation)
        if food.length > 1
            answers_ary = []
            for x in 0...food.length do
              if product.piece?
                answers_ary.push("#{food[x].name} #{product.weight} #{$l.l['piece']}")
              else
                answers_ary.push("#{food[x].name} #{product.weight}")
              end  
            end
        product.search_flag = true
        p answers_ary
        
        HotBot.send_keyboard_with_text $l.l['several_found'], answers_ary
        
        elsif food.length == 1
          food = food[0]
        else
          food = nil
          product.search_flag = false
        end
      end

      if food.is_a?(Database::Food)
        if product.piece?
          if food.g_per_piece.nil?
            food = nil
          else 
          product.weight.to_i * food.g_per_piece.to_i
          end
        else
          product.weight.to_i
        end
      end

      if food.nil? && product.piece?
        HotBot.send "#{food.name} #{$l.l['no_g_per_piece']}"
        product.piece_flag = false
      elsif food.kind_of?(Database::Food)
        Database::Record.create(food_id: food.id, weight: product.weight, client_id: user.id)
        HotBot.send_text_hide_keyboard "#{$l.l['you_ate']} #{product.weight} #{$l.l['gram']} #{food.name}"
        product.search_flag = false
      elsif !food.kind_of?(ActiveRecord::Relation)
        product.search_flag = false
        HotBot.send $l.l['no_product']
      end          
  end
end