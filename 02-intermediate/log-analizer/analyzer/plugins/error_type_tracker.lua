local html_report = require("analyzer.plugins.html_report")

local M = {
    counts = {
        ["4xx"] = 0,
        ["5xx"] = 0
    }
}

function M.process(status_code)
    local code = tonumber(status_code)
    if code >= 400 and code < 500 then
        M.counts["4xx"] = M.counts["4xx"] + 1
    elseif code >= 500 and code < 600 then
        M.counts["5xx"] = M.counts["5xx"] + 1
    end
end

function M.process_line(line)
    local status = line:match("%s(%d%d%d)%s")
    if status then
        M.process(status)
    end
end

function M.report()
    local lines = {
        string.format("Client Errors (4xx): %d", M.counts["4xx"]),
        string.format("Server Errors (5xx): %d", M.counts["5xx"])
    }
    html_report.add_summary("HTTP Error Type Summary", lines)
end

function M.export_csv(f)
    f:write("Plugin: Error Type Tracker\n")
    f:write(string.format("4xx,%d\n", M.counts["4xx"]))
    f:write(string.format("5xx,%d\n", M.counts["5xx"]))
    f:write("\n") -- blank line between sections
end

return M
