#clone for Linux/Ubuntu

git clone https://github.com/gianux/scavange.git

#install the gems:

bundle install

#run the spec

rake spec     

#change the file/fwords.txt or give a new one 

vim file/fwords.txt

#run scavate with aguments( head, tail, division, file_sites, file_words ), example:

rake www:scavate[1,100,10,"file/alexa1M.txt","file/fwords.txt"]

( arg division=10 to fragment file_sites in http requests )

#to scavate 1000000:

rake www:scavate1M

( implicit arguments: head = 1, tail = 1000000, division = 3500, file_sites = file/alexa1M.txt, file_words = file/fwords.txt )

#to scavate 100:

rake www:scavate100by10

( implicit arguments: head = 1, tail = 100, division = 10, file_sites = file/alexa1M.txt, file_words = file/fwords.txt )

#to monitorize results, open the irb console an write:

laod 'irb/monitorize.rb' ; Monitorize.now
