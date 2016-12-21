clone this just for Linux Ubuntu

#run in the command line:

bundle install

#run the spec

rake spec     

#change the lib/finder.rb 
creates a server named "BaseX#{given_name}" whith the results that pass 
the block rules against the @document response, like that :

finder "give_name" { @document.match "word" and @document.match "another word, etc" } 


#run the first 100 of the alexa1M.txt to scavate something

rake 100by10 

#to see waths going on open the irb console an write:

laod 'irb/monitorize.rb'

Monitorize.now


#to run the 1000000 write:

rake run1000000
