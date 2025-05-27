-- analyzer/plugins/requests_by_time.lua
local M = {}
local time_buckets = {}
M.granularity = "minute"  -- can be: "hour", "minute", "second"

-- Allow CLI arg like --granularity=second
function M.set_args(args)
    if args.granularity and (args.granularity == "second" or args.granularity == "minute" or args.granularity == "hour") then
        M.granularity = args.granularity
    end
end

local function extract_bucket(datetime_str, granularity)
    -- Expected input: 12/May/2025:21:14:59 (Apache-style)
    local d, m, y, h, min, s = datetime_str:match("(%d%d)/(%a+)/(%d%d%d%d):(%d%d):(%d%d):(%d%d)")
    if not (d and m and y and h and min and s) then return nil end

    local month_map = {
        Jan = "01", Feb = "02", Mar = "03", Apr = "04", May = "05", Jun = "06",
        Jul = "07", Aug = "08", Sep = "09", Oct = "10", Nov = "11", Dec = "12"
    }

    m = month_map[m]
    if not m then return nil end

    if granularity == "hour" then
        return string.format("%s-%s-%s %s:00", y, m, d, h)
    elseif granularity == "minute" then
        return string.format("%s-%s-%s %s:%s", y, m, d, h, min)
    elseif granularity == "second" then
        return string.format("%s-%s-%s %s:%s:%s", y, m, d, h, min, s)
    end
end

function M.process_line(line)
    local timestamp = line:match("%[(.-)%]")  -- Match date in square brackets
    if not timestamp then return end

    local bucket = extract_bucket(timestamp, M.granularity)
    if not bucket then return end

    time_buckets[bucket] = (time_buckets[bucket] or 0) + 1
end

function M.report()
    print("\nRequests grouped by " .. M.granularity .. ":")
    local sorted_keys = {}

    for k in pairs(time_buckets) do
        table.insert(sorted_keys, k)
    end

    table.sort(sorted_keys)

    for _, key in ipairs(sorted_keys) do
        print(string.format("  %s -> %d", key, time_buckets[key]))
    end
end

return M
