ary = []
file = File.open('./base_health_food.txt','r').read
file.each_line {|line|
	ary.push(line)	
}
num = 0
cycles = ary.length / 5
for c in 0..cycles-1
	for x in 0..4
		case x
		when 0
			puts 'fail' unless ary[c*5+x].match(/[[:alpha:]]+/)
		when 1
			puts 'fail' unless ary[c*5+x].match(/^(\d+)$/)
		when 2
			puts 'fail' unless ary[c*5+x].match(/^(\d+)$/)
		when 3
			puts 'fail' unless ary[c*5+x].match(/^(\d+)$/)
		when 4
			puts 'fail' unless ary[c*5+x].match(/^(\d+)$/)
			puts c*5+x
		end
	end
end
