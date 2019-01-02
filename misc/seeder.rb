require './lib/sqlite'
puts File.realpath(__FILE__)
open(File.join(File.dirname(__FILE__),'..','bases','base_extended.txt')) { |f| 
	until f.eof? do
	food = Database::Food.new
	for x in 0..4
		str = f.readline.mb_chars.downcase!
		case x
		when 0 then food.name = str.strip
		when 1 then food.protein = str.to_i
		when 2 then food.fat = str.to_i
		when 3 then food.carb = str.to_i
		when 4 then food.calories = str.to_i
		end
	end
	food.save
end
}
