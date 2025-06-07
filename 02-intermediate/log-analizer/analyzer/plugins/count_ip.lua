-- analyzer/plugins/count_ip.lua
local M = {}
local ip_counts = {}
M.limit = 5 -- default number of top IPs to show

function M.process_line(line)
    local ip = line:match("(%d+%.%d+%.%d+%.%d+)")
    if ip then
        ip_counts[ip] = (ip_counts[ip] or 0) + 1
    end
end

function M.set_args(args)
    if args.top_ips then
        M.limit = tonumber(args.top_ips) or M.limit
    end
end

function M.report()
    print("\nTop IP address counts:")

    -- Convert to array for sorting
    local sorted = {}
    for ip, count in pairs(ip_counts) do
        table.insert(sorted, {
            ip = ip,
            count = count
        })
    end

    table.sort(sorted, function(a, b)
        return a.count > b.count
    end)

    local limit = math.min(M.limit, #sorted)
    for i = 1, limit do
        print(string.format("%2d. %-15s %5d", i, sorted[i].ip, sorted[i].count))
    end

    if limit == 0 then
        print("No IP addresses found.")
    end
end

function M.export_csv(f)
    f:write("Plugin: Count IPs\n")
    f:write("IP,Count\n")
    for ip, count in pairs(ip_counts) do
        f:write(string.format("%s,%d\n", ip, count))
    end
    f:write("\n") -- blank line between sections
end

return M
