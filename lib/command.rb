class Command
  attr_accessor :bot, :user, :message
  def initialize options={attributes: {}, environment: nil}
    @environment = options[:environment]
    @bot = @environment.bot
    @user = @environment.user
    @message = options[:message]
    @attributes = options[:attributes]
  end

  def execute
  end
end