class RecordParser
  attr_reader :message_text
  def initialize message_text
    @message_text = message_text
  end

  def parse
    AddRecordCommand.parse message_text
  end
end