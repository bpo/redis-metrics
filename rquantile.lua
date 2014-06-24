-- rquantile

local res = KEYS[1]
local quantile = tonumber(ARGV[1])

redis.call('SORT', res, 'STORE', res)

local index = math.ceil( quantile * redis.call('LLEN', res) ) - 1

return redis.call('LINDEX', res, index)
