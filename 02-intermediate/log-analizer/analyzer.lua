-- analyzer.lua
local M = {}

-- Counters
local line_count = 0
local status_codes = {}

function M.process_line(line)
    line_count = line_count + 1

    -- Example: match HTTP status codes like " 200 " or " 404 "
    local code = line:match("%s(%d%d%d)%s")
    if code then
        status_codes[code] = (status_codes[code] or 0) + 1
    end
end

function M.report()
    print("\n--- Report ---")
    print("Total lines:", line_count)

    print("Status codes:")
    for code, count in pairs(status_codes) do
        print("  " .. code .. ": " .. count)
    end
end

return M