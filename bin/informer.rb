#!/home/ubuntu/.rvm/rubies/ruby-2.3.0/bin/ruby
require 'telegram/bot'
require 'rest-client'
require File.join(File.dirname(__FILE__),'sqlite.rb')
require 'logging'

#####################################################
# 					
# Informer class for Telegram Fatloss bot
# Добавить в cron на исполнение каждую минуту		 
# 
####################################################

Logging.logger['Informer'].level = :info
Logging.logger.root.appenders = [Logging.appenders.stdout, Logging.appenders.file('./log/informer.log')]

class Informer
	TOKEN = '154316183:AAE4tOukwWPp1AUXywLU-bjWU8xq2R-bchc'
	SCHEDULE = File.dirname(__FILE__) + "/lib/schedule"
	REGEX = /^(\d{2}.\d{2} \d{2}:\d{2}) (\d+)$/
	

	def initialize
		@logger = Logging.logger[self]
		@schedule = []
		@fresh_tasks_ary = []
		setup
	end

	def inform(tasks)
	 	chats = []
	 	tasks.each {|task|
	 		chat_id = task.match(/(\d+)$/)[1].to_i
	 		chats.push(chat_id)
	 	}
	 	chats.each{ |chat|
	 		send(chat, "Время принимать пищу!")
	 	}
	end

	def get_this_minute_tasks
		time = Time.now.strftime("%d.%m %H:%M")
		result_ary = []
		@schedule.each { |task|
			result_ary.push(task) if task.slice(0,11) == time
		}
		@logger.info "Actual time #{time} - founded #{result_ary.length} tasks to perform"
		return result_ary
	end

	def setup
		file = File.open(SCHEDULE,'r').read
		file.each_line {|line|
			line.strip!
			@schedule.push(line) if !line.empty?
		}
		@logger.info "[SUCCESS] Actual schedule has #{@schedule.length} elements"
	end

	def send(chat_id, text)
		RestClient.post('https://api.telegram.org/bot' + TOKEN + '/sendmessage',{chat_id:chat_id, text:text})
		@logger.info("[SUCCESS] Message was sent to #{chat_id} at #{Time.now.strftime("%H:%M:%s")}")
	end

	def remove_task!(task)
		if task_exists?
			@schedule.delete(task)
		else
			nil
		end
	end

	def add_to_schedule!(task)
		if !task_exists?(task)
			@schedule.push(task)
		else
			nil
		end	
	end

	def task_exists?(task)
		@schedule.grep(task).empty? ? false : true
	end

	def save
		@schedule.reject! {|element|
			element.empty?
		}
		@logger.info "[SUCCESS] #{@schedule.length} new elements was saved to schedule"
		File.open(SCHEDULE,'w') { |file|
			@schedule.each {|task|
				file << "#{task}\n"
			}
		}
	end

	def get_today_tasks
		ids = []
		grouped_by_id_records = Database::Record.today.group(:client_id)
		puts "today #{grouped_by_id_records.length}"
		if !grouped_by_id_records.empty?
			grouped_by_id_records.each {|record|
			if Database::Client.find_by(id:record.client_id).inform
				ids.push(record.client_id)
			end
			}
		else
			ids = []
		end

		tasks_ary = []
		
		if !ids.empty?
			tasks_ary = []
			ids.each {|id|
			first_record = Database::Record.today.where(client_id: id).order(created_at: :asc)[0]

			first_record_time = first_record.created_at
			@logger.info "[SUCCESS] First meal time #{first_record_time}"			
			times_ary = add_hours_to_time_several_times(first_record_time,3,4)

			times_ary.each { |time|
				tasks_ary.push("#{time.strftime("%d.%m %H:%M")} #{Database::Client.find_by(id:id).chat_id}")
				}
			}
		end

		return tasks_ary
	end

	def add_hours_to_time_several_times(time, hours, times)
		times_ary = []
		for x in 0..times do
			new_time = time + (x*hours).hours
			times_ary.push(new_time)
		end
		return times_ary
	end

end

informer = Informer.new

	ary = informer.get_today_tasks
	ary.each {|task|
		informer.add_to_schedule!(task)
	}
	informer.save

	task_ary = informer.get_this_minute_tasks
	informer.inform(task_ary)
