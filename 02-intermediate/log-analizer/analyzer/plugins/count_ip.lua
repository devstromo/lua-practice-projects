-- analyzer/plugins/count_ip.lua
local M = {}
local ip_counts = {}

function M.process_line(line)
    local ip = line:match("(%d+%.%d+%.%d+%.%d+)")
    if ip then
        ip_counts[ip] = (ip_counts[ip] or 0) + 1
    end
end

function M.report()
    print("\nIP address counts:")
    local max = 0
    local max_ip = ""
    for ip, count in pairs(ip_counts) do
        print("  " .. ip .. ": " .. count)
        if count > max then
            max = count
            max_ip = ip
        end
    end
    if max > 0 then
        print("Most common IP address: " .. max_ip .. " (" .. max .. " occurrences)")
    else
        print("No IP addresses found.")
    end
end

return M

