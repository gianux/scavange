require_relative "finder_helper.rb"

finder( w1 = "zagreb") { @document =~ /#{w1}/i }

finder( w2 = "portuga" ) { @document =~ /#{w2}/i }
