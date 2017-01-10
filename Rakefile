#require 'bundler/setup'

begin
      require 'yard'

      YARD::Rake::YardocTask.new do |t|
          t.options += ['--title', "Talkdesk Project"]
      end
rescue LoadError
      puts "Yardoc not available."
end

monit_results_message = <<EOF

... open a irb console in the project dir then write:

    load 'irb/monitorize.rb' ; Monitorize.now

to see what's going on!

EOF

namespace :www do

    mon = lambda { puts monit_results_message }

    task :scavate, [:head, :tail, :divi, :fsites, :fwords, :tconf] do |t, args|
        mon.call

        Rake::Task["www:scavate"].invoke(   h = args[:head] ,
                                            t = args[:tail] ,
                                            d = args[:divi] ,
                                            f1 = args[:fsites] ,
                                            f2 = args[:fwords] ,
                                            tconf = args[:tconf] )
#        p instance_eval "{#{tconf}}".gsub(";",",")
        system "ruby lib/start_rolling.rb #{h} #{t} #{d} #{f1} #{f2}"
    end

    task :kill do
        system "sudo ruby kill/kills.rb"
    end
    task :ps do
        system "ps -ef|grep ruby"
    end

    task :run100by10 do
        system "ruby lib/start_rolling.rb 1 100 10 'file/alexa1M.txt' 'file/fwords.txt'"
    end
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
