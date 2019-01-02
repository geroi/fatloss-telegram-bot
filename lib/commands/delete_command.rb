class DeleteCommand < Command
  def self.parse attr_line
    {}
  end

  def execute
    ary = Database::Record.owned_by(user).last(5).reverse # поиск последних 5 приемов
    answers_ary = []
    unless ary.empty?
      ary.each {|record|
      answers_ary.push("/del #{record.created_at.strftime('%H:%M')} #{Database::Food.base_and_owned_by(user).find_by_id(record.food_id).name if Database::Food.base_and_owned_by(user).find_by_id(record.food_id)} #{record.weight} ##{record.id}")
      }
      HotBot.send_keyboard_with_text $l.l['choose_record_to_delete'], answers_ary
    end
  end
end