class TelegramMessage
  extend Forwardable
  def_delegator :@message, :message_id 
  def_delegator :@message, :from
  def_delegator :@message, :chat
  def_delegator :@message, :text
  def_delegator :@message, :date
  def initialize message
    @message = message
  end
end