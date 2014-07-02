-- naiveadd

local res = KEYS[1]

for i=1,#ARGV do
  redis.call('LPUSH', res, ARGV[i])
end
