#!/usr/bin/env ruby

pid = 0 ; pse = proc { `ps -ef | grep #{pid}` } ; rse = proc {|str| raise str } 

FICH_RB = "lib/" + %w[ 
take.rb 
write.rb 
server.rb 
base_and_monit.rb
react_server.rb 
server_run.rb 
xclient.rb 
drb_xclient.rb 
rolling.rb 
em_request_detector.rb
].inject { |s,rb| s += " lib/#{rb} " }

puts FICH_RB
sleep 3
( pid = Process.spawn "vim -p #{FICH_RB}" )  &&  pse.call || ( ( rse.call "vim error #{pid}" ) && exit )

Process.wait(pid)

processed_text = File.read(FICH_RB)
