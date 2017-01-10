module DRBConfs

    HOST = "druby://localhost:"
    DETECTOR = "start_detector.rb"
    CLIENT = "start_xclient.rb"
    BASES = %w[ start_server_run.rb ]

    DTMSG = "from detector.rb to monit" 
    CLIMSG = "from client.rb to monit"

    REACT = "react_server.rb"
    TRIGGMSG = "React.please!"

    LASTMONITMSG = "to monit last"
    JUSTMONITMSG = "just monit"

    X200PORT = 67890 
    X302PORT = 33302 
    MONITPORT = 21212 
    GOOLSPORT = 11111 
    DIVPORT = 88888

    TRIGGPORT = CLIPORT = 99999

    XERRPORT = 98989
end
