class MessageFacade
  attr_reader :message
  def initialize options={message: nil, type: :telegram}
    @type = options[:type]
    @message = case @type
      when :telegram then TelegramMessage.new(options[:message])
      when :whatsapp then WhatsappMessage.new(options[:message])
    end
  end
end