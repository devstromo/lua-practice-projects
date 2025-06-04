-- analyzer/plugins/endpoint_filter.lua
local M = {}
local endpoints = {}
M.filter = ""

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
