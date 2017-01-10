module RedisConfs

    redis = Redis.new

    define_method :set_confs do |&block|  
        redis.set 'cliconf',   "[]"       # change to "[ :values ]" or "[ :values, :counts ]"
        redis.set 'triggconf', "[]"       # for monitorization
        redis.set 'dt200conf', "[]"      
        redis.set 'dt302conf', "[]"      

        redis.set 'react302conf', "false" # change to "true" or "false" for http direction

        block.call self
    end

    define_method :cli do |a|
        redis.set 'cliconf', "#{a}"
    end
    define_method :trigg do |a|
        redis.set 'triggconf', "#{a}"
    end
    define_method :dt200 do |a|
        redis.set 'dt200conf', "#{a}"
    end
    define_method :dt302 do |a|
        redis.set 'dt302conf', "#{a}"
    end

    define_method :react302 do |b|
        redis.set 'react302conf', "#{b}"
    end

    define_method :files do | t|
        redis.set 'wordsfile', t[:wordsfile]
        redis.set 'sitesfile', t[:sitesfile]
    end

    extend self
end
