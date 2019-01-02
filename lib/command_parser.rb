class CommandParser
  attr_reader :message_text, :command_name
  def initialize message_text
    @message_text = message_text
  end

  def parse
    @command_name = pull_first_word message_text
    if command_class_exists?
      result_hash = {
        command_attributes: get_attributes_depending_on_class,
        command_name: command_name
      }
    else
      raise NoCommandError
    end
  end

  def pull_first_word message_text
    match_ary = message_text.match(/^\/([[:word:]]+)/)
    if match_ary
      match_ary[1].to_s
    else 
      nil
    end
  end

  def command_class_exists?
    begin
      Object.const_get("#{command_name.to_s.camelize}Command")
    rescue
      false
    end
  end

  def get_attributes_depending_on_class
    attributes_line = message_text.gsub("/#{command_name}",'').strip!
    parse_attribute_line_depending_on_command attributes_line
  end

  def parse_attribute_line_depending_on_command attributes_line
    attributes_hash = Object.const_get("#{command_name.to_s.camelize}Command").parse(attributes_line)
  end
end