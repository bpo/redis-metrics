-- rradd 
math.randomseed(ARGV[1])

local res = KEYS[1]
local counter = KEYS[2]
local targetsize = tonumber(ARGV[2])

local ressize = redis.call('llen', res)
local totalsize = redis.call('get', counter)

for i=3,#ARGV do

  if ressize < targetsize then
    ressize = redis.call('rpush', res, ARGV[i])
  else
    local r = math.random(totalsize)
    if r < ressize then
      redis.call('lset', res, r, ARGV[i])
    end
  end

  totalsize = redis.call('incr', counter)
end
