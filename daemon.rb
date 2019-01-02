require 'daemons'
pwd = Dir.pwd
options = {
	monitor: true,
	log_output: true,
	backtrace: true,
	output_logfilename: File.join(File.dirname(__FILE__),'log','output.txt'),
	logfilename: File.join(File.dirname(__FILE__),'log','logfile.log')
}
Daemons.run_proc(File.join(File.dirname(__FILE__),'main.rb'), options) do
	exec "ruby -C#{pwd} main.rb"
end