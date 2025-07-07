local cli_args = {}
for _, arg_str in ipairs(arg or {}) do
    local key, val = arg_str:match("^%-%-(.-)=(.+)$")
    if key and val then
        cli_args[key] = val
    else
        key = arg_str:match("^%-%-(.+)$")
        if key then
            cli_args[key] = true
        end
    end
end

local function markdown_to_html(markdown)
    local body_lines = {}
    local indent = "    "
    local in_ol = false
    local inside_li = false

    local lines = {}
    for line in markdown:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local i = 1
    while i <= #lines do
        local line = lines[i]
        local converted = line

        -- Check for ordered list item
        local list_item = line:match("^%d+%.%s+(.+)")
        if list_item then
            -- Start <ol> if not already
            if not in_ol then
                table.insert(body_lines, indent .. "<ol>")
                in_ol = true
            end

            -- Process formatting in list item
            list_item = list_item:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")
            list_item = list_item:gsub("%*(.-)%*", "<em>%1</em>")
            list_item = list_item:gsub("`(.-)`", "<code>%1</code>")

            table.insert(body_lines, indent .. indent .. "<li>" .. list_item)

            inside_li = true
            i = i + 1

            -- Check following indented lines as part of this list item
            while i <= #lines do
                local next_line = lines[i]
                if next_line:match("^%s") and not next_line:match("^%d+%.%s+") then
                    -- Format next_line and append as paragraph within <li>
                    local para = next_line:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")
                    para = para:gsub("%*(.-)%*", "<em>%1</em>")
                    para = para:gsub("`(.-)`", "<code>%1</code>")
                    table.insert(body_lines, indent .. indent .. indent .. "<p>" .. para .. "</p>")
                    i = i + 1
                else
                    break
                end
            end

            table.insert(body_lines, indent .. indent .. "</li>") -- Close <li> after paragraphs
            inside_li = false

        else
            -- Close </ol> if we leave list block
            if in_ol then
                table.insert(body_lines, indent .. "</ol>")
                in_ol = false
            end

            -- Process as normal paragraph or header
            converted = converted:gsub("^###%s*(.+)", "<h3>%1</h3>")
            converted = converted:gsub("^##%s*(.+)", "<h2>%1</h2>")
            converted = converted:gsub("^#%s*(.+)", "<h1>%1</h1>")

            converted = converted:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")
            converted = converted:gsub("%*(.-)%*", "<em>%1</em>")
            converted = converted:gsub("`(.-)`", "<code>%1</code>")

            if not (converted:match("^<h[1-3]>")) then
                converted = "<p>" .. converted .. "</p>"
            end

            table.insert(body_lines, indent .. converted)
            i = i + 1
        end
    end

    -- Close open <ol> if still open
    if in_ol then
        table.insert(body_lines, indent .. "</ol>")
    end

    -- Build final HTML
    local html = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Markdown Output</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; margin: 40px; }
        code { background: #f4f4f4; padding: 2px 4px; border-radius: 3px; }
    </style>
</head>
<body>
]] .. table.concat(body_lines, "\n") .. [[
</body>
</html>
]]

    return html
end

-- Mardown to HTML conversion function
local function convert_markdown_to_html(input_file, output_file)
    local input = io.open(input_file, "r")
    if not input then
        print("Error: Could not open input file:", input_file)
        return
    end

    local markdown = input:read("*all")
    input:close()

    local html = markdown_to_html(markdown)

    local output = io.open(output_file, "w")
    if not output then
        print("Error: Could not open output file:", output_file)
        return
    end

    output:write(html)
    output:close()

    print("Conversion complete. Output written to:", output_file)
end

local source_file = ""
print("Markdown to HTML Converter is running...")
if not cli_args.source then
    io.write("Input file route: ")
    local user_input = io.read()
    if not user_input or user_input == "" then
        print("No input file provided. Exiting.")
        return
    end
    source_file = user_input -- assign if valid input
else
    print("Input file:", cli_args.source)
    source_file = cli_args.source
end

print("Output file:", cli_args.output or "output.html")

local source_file = source_file or "input.md"
local output_file = cli_args.output or "output.html"
convert_markdown_to_html(source_file, output_file)
