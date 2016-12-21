#!/usr/bin/env ruby

pid = 0 ; pse = proc { `ps -ef | grep #{pid}` } ; rse = proc {|str| raise str } 

FICH_RB = "lib/" + %w[ 
match_objects.rb 
match_classs.rb 
match_context.rb 
match_tables.rb 
base_and_monit_tables.rb 
loaded.rb 
load.rb
finder_helper.rb 
detector.rb 
].inject { |s,rb| s += " lib/#{rb} " } + "irb/monitorize.rb"

puts FICH_RB

( pid = Process.spawn "vim -p #{FICH_RB}" )  &&  pse.call || ( ( rse.call "vim error #{pid}" ) && exit )

Process.wait(pid)

processed_text = File.read(FICH_RB)
