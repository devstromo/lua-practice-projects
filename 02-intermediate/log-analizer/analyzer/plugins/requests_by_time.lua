-- analyzer/plugins/requests_by_time.lua
local M = {}
local time_buckets = {}
M.granularity = "minute" -- can be: "hour", "minute", "second"

-- Allow CLI arg like --granularity=second
function M.set_args(args)
    if args.granularity and (args.granularity == "second" or args.granularity == "minute" or args.granularity == "hour") then
        M.granularity = args.granularity
    end
end

local function parse_timestamp(line)
    -- Try ISO format: 2015-07-31 00:16:12,152
    local y, m, d, h, min, s = line:match("(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d)")
    if y then
        return {
            year = y,
            month = m,
            day = d,
            hour = h,
            min = min,
            sec = s
        }
    end

    -- Try Apache: [Mon Dec 05 13:41:58 2005]
    local mon, day, h, min, s, y = line:match("%[%a+ (%a+) (%d+) (%d+):(%d+):(%d+) (%d+)%]")
    if mon then
        local month_map = {
            Jan = 1,
            Feb = 2,
            Mar = 3,
            Apr = 4,
            May = 5,
            Jun = 6,
            Jul = 7,
            Aug = 8,
            Sep = 9,
            Oct = 10,
            Nov = 11,
            Dec = 12
        }
        return {
            year = y,
            month = month_map[mon],
            day = day,
            hour = h,
            min = min,
            sec = s
        }
    end

    -- Try Android format: 03-17 16:13:47.631
    local mon, day, h, min, s = line:match("(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d)")
    if mon then
        return {
            year = os.date("*t").year, -- assume current year
            month = mon,
            day = day,
            hour = h,
            min = min,
            sec = s
        }
    end

    return nil
end

function M.process_line(line)
    local t = parse_timestamp(line)
    if not t then
        return
    end

    local timestamp = os.time({
        year = tonumber(t.year),
        month = tonumber(t.month),
        day = tonumber(t.day),
        hour = tonumber(t.hour),
        min = tonumber(t.min),
        sec = tonumber(t.sec)
    })

    if not timestamp then
        return
    end

    local bucket
    if M.granularity == "hour" then
        bucket = os.date("%Y-%m-%d %H:00", timestamp)
    elseif M.granularity == "minute" then
        bucket = os.date("%Y-%m-%d %H:%M", timestamp)
    elseif M.granularity == "second" then
        bucket = os.date("%Y-%m-%d %H:%M:%S", timestamp)
    end

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

function M.export_csv(f)
    f:write("Plugin: Request by time \n")
    f:write("Timestamp,Count\n")
    local sorted_keys = {}

    for k in pairs(time_buckets) do
        table.insert(sorted_keys, k)
    end

    table.sort(sorted_keys)
    for _, key in ipairs(sorted_keys) do
        f:write(string.format("%s,%d\n", key, time_buckets[key]))
    end
    f:write("\n")
end

return M
