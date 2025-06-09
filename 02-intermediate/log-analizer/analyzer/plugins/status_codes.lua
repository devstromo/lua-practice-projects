-- analyzer/plugins/status_codes.lua
local M = {}
local codes = {}

local html = require("analyzer.plugins.html_report")

function M.process_line(line)
    local code = line:match("%s(%d%d%d)%s")
    if code then
        codes[code] = (codes[code] or 0) + 1
    end
end

function M.report()
    print("\nStatus code counts:")
    local html_data = {}
    local max = 0
    local max_code = ""
    for code, count in pairs(codes) do
        print("  " .. code .. ": " .. count)
        local line = "  " .. code .. ": " .. count
        table.insert(html_data, line)
        if count > max then
            max = count
            max_code = code
        end
    end
    if max > 0 then
        print("Most common status code: " .. max_code .. " (" .. max .. " occurrences)")
        html.add_summary("Status Code Counts", html_data)
    else
        print("No status codes found.")
    end
end

function M.export_csv(f)
    f:write("Plugin: Status Codes\n")
    f:write("Status Code,Count\n")
    for code, count in pairs(codes) do
        f:write(string.format("%s,%d\n", code, count))
    end
    f:write("\n") -- blank line between sections
end

return M
