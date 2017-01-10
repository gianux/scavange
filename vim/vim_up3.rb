#!/usr/bin/env ruby

pid = 0 ; pse = proc { `ps -ef | grep #{pid}` } ; rse = proc {|str| raise str } 

FILE_RB = "lib/" + %w[ 
finder.rb 
configs.rb
api_confs.rb
drb_confs.rb
redis_confs.rb
start_rolling.rb
start_xclient.rb
start_detector.rb
start_server_run.rb
].inject { |s,rb| s += " lib/#{rb} " }

puts FILE_RB

( pid = Process.spawn "vim -p #{FILE_RB}" )  &&  pse.call  || ( ( rse.call "vim error #{pid}" ) && exit )

Process.wait(pid)

processed_text = File.read(FILE_RB)
