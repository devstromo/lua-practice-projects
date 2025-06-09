-- analyzer/plugins/html_report.lua

local M = {}

local sections = {}

function M.add_summary(title, lines)
    table.insert(sections, {
        title = title or "Untitled",
        lines = type(lines) == "table" and lines or {}
    })
end

function M.export(f)
    f:write("<html><body>\n")
    for _, section in ipairs(sections) do
        f:write("<h2>" .. section.title .. "</h2>\n")
        f:write("<pre>\n")
        for _, line in ipairs(section.lines) do
            f:write(line .. "\n")
        end
        f:write("</pre>\n")
    end
    f:write("</body></html>\n")
end

return M
