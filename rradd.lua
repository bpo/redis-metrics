-- rradd 

-- our reservoir key
local res = KEYS[1]
-- key with a counter incremented for each value seen
local counter = KEYS[2]

-- seed the random number generator on every invocation
math.randomseed(ARGV[1])

-- the maximum size of our reservoir
local maxsize = tonumber(ARGV[2])
-- the current size of our reservoir
local ressize = redis.call('LLEN', res)
-- the total number of values that have been seen.
local totalsize = redis.call('GET', counter)

-- iterate over the remaining arguments, which contain values to be added.
for i=3,#ARGV do

  -- until the reservoir is full, just add values.
  if ressize < maxsize then
    ressize = redis.call('RPUSH', res, ARGV[i])
  else
    -- as the total number of values seen increases, the likelihood of one being
    -- chosen for our reservoir decreases.
    local r = math.random(totalsize)
    if r < ressize then
      redis.call('LSET', res, r, ARGV[i])
    end
  end

  totalsize = redis.call('INCR', counter)
end
