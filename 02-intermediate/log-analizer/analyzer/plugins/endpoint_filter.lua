-- analyzer/plugins/endpoint_filter.lua
local M = {}
local endpoints = {}
M.filter = ""

local html = require("analyzer.plugins.html_report")

-- Allow CLI arg like --endpoint-filter="/api/v1/users"
local function is_valid_endpoint(endpoint)
    return endpoint:match("^/[^%s]+$") ~= nil
end

function M.set_args(args)

    if args.endpoint_filter and is_valid_endpoint(args.endpoint_filter) then
        M.filter = args.endpoint_filter
    else
        print("Invalid endpoint filter. Must be in the format: /path/to/endpoint")
    end
end

function M.process_line(line)
    local endpoint = line:match("%s(/[^%s]+)%s")
    if M.filter ~= "" and endpoint and not endpoint:find(M.filter) then
        return -- Skip this line if it doesn't match the filter
    end
    if not endpoint then
        endpoint = line:match("%s(/[^%s]+)$") -- Try to match at the end of the line
    end
    if endpoint then
        endpoints[endpoint] = (endpoints[endpoint] or 0) + 1
    end
end

function M.report()
    if M.filter ~= "" then
        print("\nEndpoints matching filter: " .. M.filter)
    else
        print("\nAll endpoints:")
    end

    if next(endpoints) == nil then
        print("No endpoints found.")
        return
    end

    local html_data = {}
    print("\nEndpoint counts:")
    local max = 0
    local max_endpoint = ""

    for endpoint, count in pairs(endpoints) do
        local line = "  " .. endpoint .. ": " .. count
        print(line)
        table.insert(html_data, line)
        if count > max then
            max = count
            max_endpoint = endpoint
        end
    end

    -- Print console message
    if M.filter ~= "" then
        print("Total matching endpoints: " .. #html_data .. " (filtered by: " .. M.filter .. ")")
    else
        print("Most common endpoint: " .. max_endpoint .. " (" .. max .. " occurrences)")
    end

    -- Always add HTML summary if we have data
    html.add_summary("Filtered Endpoint Counts", html_data)

end

function M.export_csv(f)
    f:write("Plugin: Endpoint filter\n")
    f:write("Endpoint,Count\n")
    for endpoint, count in pairs(endpoints) do
        f:write(string.format("%s,%d\n", endpoint, count))
    end
    f:write("\n") -- blank line between sections
end

return M
