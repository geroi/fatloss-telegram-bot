require 'open-uri'
require 'nokogiri'

URL_P1 = "http://health-diet.ru/base_of_food/sostav/"
URL_P2 = ".php"
File.open('./base_health_food.txt','w'){|file| file.truncate(0)}

urls = [13751]# дописать фор для всех страниц
for x in 1..20000 do
	page = Nokogiri::HTML(open(URL_P1+x.to_s+URL_P2))
	food_name = page.css('u')[0].text if !page.css('u').empty?
	ary = page.css('.cnt_main_block_content > .nutrition > .cnt_text_font_str > .cnt_title')
	calories, proteins, fats, carbs = '','','',''
	if !ary.empty?
		for x in 0..ary.length
			if ary[x]
				case ary[x].text
				when 'Калорийность'
				 calories = page.css('.cnt_main_block_content > .nutrition > .cnt_text_font_str > .cnt_count')[x].text.to_s
				when 'Белки'
				 proteins = page.css('.cnt_main_block_content > .nutrition > .cnt_text_font_str > .cnt_count')[x].text.to_s
				when 'Жиры'
				 fats = page.css('.cnt_main_block_content > .nutrition > .cnt_text_font_str > .cnt_count')[x].text.to_s
				when 'Углеводы'
				 carbs = page.css('.cnt_main_block_content > .nutrition > .cnt_text_font_str > .cnt_count')[x].text.to_s
				end
			end
		end
	end
	proteins = proteins.match(/(\d+[,]?\d?)/)[1] if proteins.match(/(\d+[,]?\d?)/)
	fats = fats.match(/(\d+[,]?\d?)/)[1] if fats.match(/(\d+[,]?\d?)/)
	carbs = carbs.match(/(\d+[,]?\d?)/)[1] if carbs.match(/(\d+[,]?\d?)/)
	calories = calories.match(/(\d+[,]?\d?)/)[1] if calories.match(/(\d+[,]?\d?)/)
	product = [food_name,proteins,fats,carbs,calories]
	food_name = food_name.gsub!('"','') if !food_name.nil?
	for k in 1..4
		product[k] = product[k].gsub(',','.')
		product[k] = product[k].to_f.round
	end
	if !food_name.nil?
		File.open('./base_health_food.txt','a') do |file|
			file.write "#{product[0]}\n#{product[1]}\n#{product[2]}\n#{product[3]}\n#{product[4]}\n"
		end
	end
end