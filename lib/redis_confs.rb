redis = Redis.new

redis.set 'cliconf', "[ :values ]"
redis.set 'triggconf', "[ :values ]"
redis.set 'dt200conf', "[ :values, :counts ]"
redis.set 'dt302conf', "[ :values, :counts ]"
