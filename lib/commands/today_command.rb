class TodayCommand < Command
  def self.parse attributes_line
    {}
  end

  def execute
    @environment.bot.track('today', message.from.id)
      sum_cal, sum_protein, sum_fat, sum_carbs = 0, 0, 0, 0

      today_ary = Database::Record.owned_by(@environment.user).today_full
      today_ary.each do |record|
        food = record.food
        if food
          sum_cal += food.calories * record.weight/100
          sum_fat += food.fat * record.weight/100
          sum_protein += food.protein * record.weight/100
          sum_carbs += food.carb * record.weight/100
        end
      end
      HotBot.send "#{$l.l['for_today']} #{Date.today.strftime('%d.%m.%Y')}\n"\
      "#{$l.l['calories']} #{sum_cal}\n#{$l.l['proteins']} #{sum_protein}\n#{$l.l['fats']} #{sum_fat}\n#{$l.l['carbs']} #{sum_carbs}"
      
      if sum_cal > 0
        cal_fat = sum_fat * 900 /sum_cal
        cal_protein = sum_protein*400/sum_cal
        cal_carbs = sum_carbs*400/sum_cal

        draw = Drawer.new
        datasets = [
                    [$l.l['proteins'],[cal_protein]],
                    [$l.l['fats'],[cal_fat]],
                    [$l.l['carbs'],[cal_carbs]]
                  ]
        draw.setup(datasets)
        imgname = "#{@environment.user.id}_#{DateTime.now.strftime('%s')}.png"
        draw.pie_graph(File.join(File.dirname(__FILE__),'..','..','imgs',imgname), "#{$l.l['today_consumption']} #{Date.today.strftime('%d.%m.%Y')}") #СОХРАНЯЕТ В ФАЙЛ НА ДИСКЕ см класс

        RestClient.post("https://api.telegram.org/bot#{@environment.token}/sendphoto",{chat_id: message.chat.id, photo: File.new(File.join(File.dirname(__FILE__),'..','..','imgs',imgname))})
        File.delete(File.join(File.dirname(__FILE__),'..','..','imgs',imgname))
        
          mp = @environment.user.max_proteins ||  160 
          mf = @environment.user.max_fats ||  30 
          mc = @environment.user.max_carbs || 225 
          mcal = @environment.user.max_calories || 1800 
          
          ost_protein = mp - sum_protein
          ost_fat = mf - sum_fat
          ost_carb = mc - sum_carbs
          ost_cals = mcal - sum_cal

          xp, xf, xc, xcals = 0,0,0,0

          if ost_protein < 0
            xp = -ost_protein
            ost_protein = 0
            sum_protein = mp
          end
          if ost_fat < 0
            xf = -ost_fat
            ost_fat = 0
            sum_fat = mf
          end
          if ost_carb < 0
            xc = -ost_carb
            ost_carb = 0
            sum_carbs = mc
          end

          if ost_cals < 0
            xcals = -ost_cals
            ost_cals = 0
            sum_cal = mcal
          end

          datasets2 = [
            [$l.l['proteins'],[sum_protein,sum_fat,sum_carbs]],
            [$l.l['fats'],[ost_protein,ost_fat,ost_carb]],
            [$l.l['carbs'],[xp,xf,xc]]
            # [$l.l['calories'],[0,0,0,0]]
              ]
          draw.setup(datasets2)
          imgname = "#{@environment.user.id}_#{DateTime.now.strftime('%s')}.png"
          draw.bar_graph(File.join(File.dirname(__FILE__),'..','..','imgs',imgname), 
            {0 => "#{$l.l['proteins']}\n#{sum_protein+xp}/#{mp}",
            1 => "#{$l.l['fats']}\n#{sum_fat+xf}/#{mf}",
            2 => "#{$l.l['carbs']}\n#{sum_carbs+xc}/#{mc}",
             3 => "#{$l.l['carbs']}\n#{sum_carbs+xc}/#{mc}"},
              $l.l['consumption_maximum'])
          RestClient.post("https://api.telegram.org/bot#{@environment.token}/sendphoto",{chat_id: message.chat.id, photo: File.new(File.join(File.dirname(__FILE__),'..','..','imgs',imgname))})
          File.delete(File.join(File.dirname(__FILE__),'..','..','imgs',imgname))
        end
  end
end
