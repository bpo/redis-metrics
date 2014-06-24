-- fradd 

local res = KEYS[1]
local targetsize = tonumber(ARGV[1])

local ressize = 0

for i=2,#ARGV do
  ressize = redis.call('lpush', res, ARGV[i])
end

if ressize > targetsize then
  redis.call('ltrim', res, 0, targetsize - 1)
end
