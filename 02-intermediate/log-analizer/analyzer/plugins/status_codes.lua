-- analyzer/plugins/status_codes.lua
local M = {}
local codes = {}

function M.process_line(line)
    local code = line:match("%s(%d%d%d)%s")
    if code then
        codes[code] = (codes[code] or 0) + 1
    end
end

function M.report()
    print("\nStatus code counts:")
    for code, count in pairs(codes) do
        print("  " .. code .. ": " .. count)
    end
end

return M
