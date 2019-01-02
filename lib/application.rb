require 'yaml'

class Application
  attr_reader :token, :botan_token, :help_entries
  attr_accessor :bot, :user
  include Singleton

  def initialize options={}
    setup('./config.yaml')
    @bot = options[:bot]
    @user = options[:user]
  end

  def setup config_file
    config_file = File.open(config_file)
    settings = YAML.load(config_file)
    @token = settings["token"]
    @botan_token = settings["botan_token"]
  end

  def login id # => Client
    @user = unless Database::Client.find_by(telegram_id: id)
      Database::Client.create(telegram_id: id)
    else
      Database::Client.find_by(telegram_id: id)  
    end 
  end

end