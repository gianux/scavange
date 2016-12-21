#!/usr/bin/env ruby

pid = 0 ; pse = proc { `ps -ef | grep #{pid}` } ; rse = proc {|str| raise str } 

FILE_RB = %w[ 
    Rakefile
    Gemfile
    vim/vim_up1.rb
    vim/vim_up2.rb
    vim/vim_up3.rb
    vim/vim_up4.rb
    kill/kills.rb
].inject { |s,rb| s += " #{rb} " }

puts FILE_RB

( pid = Process.spawn "vim -p #{FILE_RB}" )  &&  pse.call || ( ( rse.call "vim error #{pid}" ) && exit )

Process.wait(pid)

processed_text = File.read(FILE_RB)
