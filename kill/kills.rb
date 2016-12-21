#!/usr/bin/env ruby

TMP_KILL = "/tmp/kill"
TMP_NOTKILL = "/tmp/notkill"

pids = proc {|path| 

   begin
       lines = File.readlines path
   rescue => e
       p e ; exit
   end
}

`rm #{TMP_KILL} 2>/dev/null` ; Process.spawn "rm #{TMP_NOTKILL} 2>/dev/null"   

KILL = proc { pids.call( TMP_KILL ).inject([]) { |a,l| a << l.chomp } - NOT_KILL.call }

NOT_KILL = proc {  pids.call( TMP_NOTKILL ).inject([]) { |a,l| a << l.chomp } }

%w[gvim vim].map { |name| 

  `ps -ef|grep #{name} 2>/dev/null |sed -n '1,100 p'| awk '{print $2}' >> #{TMP_NOTKILL}`

  sleep 0.2
}

%w[ start_rinda_service start_server_run start_detector ].map {|name| 

  `ps -ef|grep #{name} 2>/dev/null |sed -n '1,100 p'| awk '{print $2}' >> #{TMP_KILL}`

  sleep 0.2 
}

KILL.call.map { |l| `kill #{l}` }
