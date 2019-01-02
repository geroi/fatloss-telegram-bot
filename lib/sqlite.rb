require 'active_record'
require 'sqlite3'

module Database
	DB_FILE = File.join(File.dirname(__FILE__),'..','db','records.sqlite3')
	ActiveRecord::Base.establish_connection(
  	adapter: "sqlite3",
    database:  DB_FILE
	)

	unless File.exist?(DB_FILE)
		ActiveRecord::Schema.define do #запись (ид, ид_клиента, ид_еды, вес_еды, время приема)
	    	create_table :records do |t|
	 		  t.integer  :food_id 
	          t.integer  :weight
	          t.integer :client_id
	          t.timestamps
	  	  end
	
	    	create_table :foods do |t| #еда - ид, название, б, ж, у, калории
	      	  t.string :name
	      	  t.integer :protein
	      	  t.integer :fat
	      	  t.integer :carb
	      	  t.integer :calories
	      	  t.integer :client_id
	      	  t.integer :g_per_piece
	      	  t.timestamps
	  	  end
	
	    	create_table :clients do |t|
	      	  t.integer :telegram_id
	      	  t.integer :max_carbs
	      	  t.integer :max_calories
	      	  t.timestamps
	  	  end
		end
	end

	class ActiveRecord::Base
		time_zone_aware_attributes = true
		default_timezone = :local #'Moscow'
	end

	class Record < ActiveRecord::Base
		belongs_to :client
		belongs_to :food
		scope :owned_by, ->(user){where(client_id: user.id)}
		scope :today, ->{where("created_at >= ?", Time.now.strftime("%Y-%m-%d 00:00:00"))} 
		scope :today_full, ->{where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)} 
	end

	class Food < ActiveRecord::Base
		validates :name, presence: true
		validates :protein, presence: true
		validates :fat, presence: true
		validates :carb, presence: true
		before_save { |food| food.name.downcase! }
		scope :base, -> { where(client_id: nil) }
		scope :owned_by,	-> (user) {where(client_id: user.id)}
		scope :base_and_owned_by, -> (user) {where("client_id IS NULL OR client_id IS ?",user.id)}
	end

	class Client < ActiveRecord::Base
		has_many :records
	end

end
