class AddCommand < Command
  def self.parse attributes_line
    ary = attributes_line.match(/^(.+[^0-9])\s(\d+)\s(\d+)\s(\d+)\s*(\d*)\s?((\d*)\s?гр\.?\/шт\.?)*$/) || nil
    if !ary.nil?
      protein, fat, carb, name = ary[2], ary[3], ary[4], ary[1]

      gpp_flag = if !ary[6].nil?
                   ary[6].match(/гр\.?\/шт\.?/).nil? ? false : true
                 else
                   false
                 end

      if gpp_flag && ary[7] == ''
          g_per_piece = ary[5]
        else
          g_per_piece = ary[7]
        end
      end
      product = Product.new(proteins: protein, fats: fat, carbs: carb, name: name, weight_per_piece: g_per_piece)
    return product.to_hash
  end

  def execute
    @environment.bot.track('add_product', message.from.id)    
    name = @attributes[:name]
    fat = @attributes[:fats]
    carbs = @attributes[:carbs]
    protein = @attributes[:proteins]
    calories =  protein.to_i*4+fat.to_i*9+carbs.to_i*4
    g_per_piece = @attributes[:weight_per_piece]
    if name && fat && protein && calories && carbs
      Database::Food.create(name: name, fat:fat,protein:protein, carb:carbs, calories:calories, client_id: user.id, g_per_piece: g_per_piece)
      HotBot.send "#{name} #{$l.l['successfully_added']}"
    else
      HotBot.send $l.l['input_error']
    end
  end
end