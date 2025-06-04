-- analyzer/plugins/endpoint_filter.lua
local M = {}
local endpoints = {}

function M.process_line(line)
    local endpoint = line:match("%s(/[^%s]+)%s")
    if endpoint then
        endpoints[endpoint] = (endpoints[endpoint] or 0) + 1
    end
end

function M.report()
    print("\nEndpoint counts:")
    local max = 0
    local max_endpoint = ""
    for endpoint, count in pairs(endpoints) do
        print("  " .. endpoint .. ": " .. count)
        if count > max then
            max = count
            max_endpoint = endpoint
        end
    end
    if max > 0 then
        print("Most common endpoint: " .. max_endpoint .. " (" .. max .. " occurrences)")
    else
        print("No endpoints found.")
    end
end
