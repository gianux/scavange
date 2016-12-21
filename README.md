#after clone run in the command line:

bundle install

# run the test

rake spec     

#run the first 100 of the alexa1M file

rake 100by10 

#to see waths going on open the irb console an write:

laod 'irb/monitorize.rb'

Monitorize.now


#to run the 1000000 write:

rake run1000000
