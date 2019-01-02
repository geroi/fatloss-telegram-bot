require 'telegram/bot'
require 'telegram/bot/botan'
require 'forwardable'
require 'rest_client'
require 'fileutils'
require 'gruff'
require 'date'
require './lib/sqlite.rb'
require './lib/drawer.rb'
require './lib/exceptions'
require './lib/user'
require './lib/message_facade'
require './lib/telegram_message'
require './lib/message_parser'
require './lib/command_parser'
require './lib/command_handler'
require './lib/command'
require './lib/commands/lang_command'
require './lib/commands/delete_command'
require './lib/commands/inform_command'
require './lib/commands/start_command'
require './lib/commands/my_list_command'
require './lib/commands/add_record_command'
require './lib/commands/del_command'
require './lib/commands/help_command'
require './lib/commands/hint_command'
require './lib/commands/info_command'
require './lib/commands/list_command'
require './lib/commands/max_command'
require './lib/commands/show_command'
require './lib/commands/today_command'
require './lib/commands/week_command'
require './lib/commands/add_command'
require './lib/commands/carbs_command'
require './lib/commands/fats_command'
require './lib/commands/proteins_command'
require './lib/commands/calories_command'
require './lib/application'
require './lib/record_parser'
require './lib/else_parser'
require './lib/product'
require './lib/hot_bot.rb'
require './lib/locale.rb'
require 'active_support'
require 'active_support/core_ext'
require 'pry'

$l = Locale.instance
application = Application.instance

Telegram::Bot::Client.run(application.token) do |bot|
bot.enable_botan!(application.botan_token)
bot.listen do |message|
    
    message = MessageFacade.new(message: message, type: :telegram).message
    application.login(message.from.id)
    application.bot = bot
    application.user.update(chat_id: message.chat.id)
    HotBot.setup(application)

    message_parser_results_hash = MessageParser.new(message).parse

    command = CommandHandler.new({
      command_name: message_parser_results_hash[:command_name],
      attributes: message_parser_results_hash[:command_attributes],
      environment: application,
      message: message
    })
    command.execute
  
  end #bot.listen
end #Client.run
      

#   elsif command == 'hint' || command == 'худеть' #подсказка по БЖУ по весу
#     if options
#       if options.match(/^(\d+)$/)
#           weight = options.match(/^(\d+)$/)[1].to_i 
#       else
#           weight = 0
#       end
#     else
#       weight = 0
#     end
    
#     if weight != 0
#       weight = weight.to_i
#       max_calories = weight * 24
#       max_carbs = max_calories * 0.15 / 4
#       max_fats = max_calories * 0.35 / 9
#       max_proteins = max_calories * 0.5 / 4
#       bot.api.send_message(chat_id: message.chat.id, text: "Оптимальное соотношение БЖУ для жиросжигания при цели в #{weight}\nБелки #{max_proteins.to_i}г\nЖиры #{max_fats.to_i}г\nУглеводы #{max_carbs.to_i}г\nКалории #{max_calories.to_i}ккал")
#       Database::Client.find_by(id:user.id).update(max_fats:max_fats.to_i, max_calories:max_calories.to_i, max_carbs:max_carbs.to_i,max_proteins:max_proteins.to_i)
#     else
#       bot.api.send_message(chat_id: message.chat.id, text: "Ошибка ввода. Формат ввода\n/fatloss 75\nгде 75 - требуемый вес")
#     end 


#   # elsif command == 'week' || command == 'неделя' #дописать
        
#   #       datasets2 = [['Калории',[sum_protein,sum_fat,sum_carbs]]

#   #         draw = Drawer.new
#   #         draw.setup(datasets2)
#   #         imgname = "#{user.id}_#{DateTime.now.strftime('%s')}.png"
#   #         draw.bar_graph(File.join(File.dirname(__FILE__),'imgs',imgname), {0 => "Белки\n#{sum_protein+xp}/#{user.max_proteins}",1 => "Жиры\n#{sum_fat+xf}/#{user.max_fats}",2 => "Углеводы\n#{sum_carbs+xc}/#{user.max_carbs}"}, "Потребление за неделю")
#   #         RestClient.post('https://api.telegram.org/bot154316183:AAE4tOukwWPp1AUXywLU-bjWU8xq2R-bchc/sendphoto',{chat_id: message.chat.id, photo: File.new("./imgs/#{imgname}")})
#   #         File.delete(File.join(File.dirname(__FILE__),'imgs',imgname))   