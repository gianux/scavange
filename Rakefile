#require 'bundler/setup'

begin
      require 'yard'

      YARD::Rake::YardocTask.new do |t|
          t.options += ['--title', "Talkdesk Project"]
      end
rescue LoadError
      puts "Yardoc not available."
end

monit_results_message = "<... open a irb console in the project dir then write: <" +
                        "< load 'irb/monitorize.rb' ; Monitorize.now <" +
                        "<to see what's going on! <zzz< zzz<  zzZ"

mon = lambda { puts monit_results_message.split('<')}

task :run100by10 do
    mon.call
    system "ruby lib/start_rolling.rb 1 100 10 'file/alexa1M.txt'"
end
task :run1000000 do
    mon.call
    system "ruby lib/start_rolling.rb 1 1000000 3400 'file/alexa1M.txt'"
end

task :basekill do
    system "sudo ruby kill/kills.rb"
end
task :baseps do
    system "ps -ef|grep ruby"
end

task :vim1 do
    system "sudo ruby vim/vim_up1.rb"
end
task :vim2 do
    system "sudo ruby vim/vim_up2.rb"
end
task :vim3 do
    system "sudo ruby vim/vim_up3.rb"
end
task :vim4 do
    system "sudo ruby vim/vim_up4.rb"
end


desc 'Run all specs through RSpec'

task :spec do
      system 'bundle exec rspec spec --format d -c'
end
