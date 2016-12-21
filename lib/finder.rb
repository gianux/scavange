require_relative "finder_helper.rb"

#finder("g0") { @document.match "search" }

#finder("g1") { @document.match "search" }
#finder("cr7") { @document.match "CR7" }
#finder("europa") { @document.match "europa" }
#finder("portuga") { @document.match "portuga" }
finder( word = "portuga" ) { @document =~ /#{word}/i }
