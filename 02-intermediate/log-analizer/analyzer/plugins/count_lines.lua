-- analyzer/plugins/count_lines.lua
local M = {}
local count = 0

function M.process_line(_)
    count = count + 1
end

function M.report()
    print("Total lines processed: " .. count)
end

return M
