class CommandHandler
  def initialize options={command_name: nil, attributes: nil, environment: nil}
    @command_name = options[:command_name]
    @attributes = options[:attributes]
    @environment = options[:environment]
    @message = options[:message]
  end

  def execute
    @command_object = Object.const_get("#{@command_name.to_s.camelize}Command").new attributes: @attributes, environment: @environment, message: @message
    @command_object.execute
  end
end