-- analyzer/plugins/html_report.lua
local M = {}
local summary_lines = {}

function M.add_summary(title, data)
    table.insert(summary_lines, { title = title, data = data })
end

function M.report()
    print("\nHTML report will be generated if --html=output.html is provided.")
end

function M.set_args(args)
    M.output_file = args.html
end

function M.export_html()
    if not M.output_file then return end

    local file = io.open(M.output_file, "w")
    if not file then
        print("Failed to write HTML report.")
        return
    end

    file:write("<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Log Report</title></head><body>")
    file:write("<h1>Log Analysis Report</h1>")

    for _, section in ipairs(summary_lines) do
        file:write(string.format("<h2>%s</h2><ul>", section.title))
        for _, line in ipairs(section.data) do
            file:write("<li>" .. line .. "</li>")
        end
        file:write("</ul>")
    end

    file:write("</body></html>")
    file:close()
    print("✅ HTML report written to: " .. M.output_file)
end

return M
