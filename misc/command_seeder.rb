file = open("/home/fatloris/work/telebot-v2/main.rb").read
ary = []
file.each_line do |line|
  if match_ary = line.match(/command == \'([[:word:]]+)\'/)
    ary.push(match_ary[1])
  end
end
ary.each {|file_name|
  begin
    open("/home/fatloris/work/telebot-v2/lib/commands/#{file_name}_command.rb")
  rescue
    file = open("/home/fatloris/work/telebot-v2/lib/commands/#{file_name}_command.rb","w") do |file|
    file.print <<EOF
class #{file_name.capitalize}Command < Command
  def self.parse attributes_line
    {}
  end

  def execute

  end
end
EOF
    end
  end
}