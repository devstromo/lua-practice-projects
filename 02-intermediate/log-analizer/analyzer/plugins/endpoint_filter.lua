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

    if M.filter ~= "" then
        print("Total matching endpoints: " .. #endpoints .. " (filtered by: " .. M.filter .. ")" .. " (" .. max ..
                  " occurrences)")
    else
        print("\nMost common endpoint:")
        if max > 0 then
            print("Most common endpoint: " .. max_endpoint .. " (" .. max .. " occurrences)")
        else
            print("No endpoints found.")
        end
    end

end
