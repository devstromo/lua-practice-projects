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
    local indent = "    " -- 4 spaces for indentation

    for line in markdown:gmatch("[^\r\n]+") do
        local converted = line

        -- Headers
        converted = converted:gsub("^#%s*(.+)", "<h1>%1</h1>")
        converted = converted:gsub("^##%s*(.+)", "<h2>%1</h2>")
        converted = converted:gsub("^###%s*(.+)", "<h3>%1</h3>")

        -- Bold
        converted = converted:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")

        -- Italic
        converted = converted:gsub("%*(.-)%*", "<em>%1</em>")

        -- Inline code
        converted = converted:gsub("`(.-)`", "<code>%1</code>")

        -- If not converted to header, wrap as paragraph
        if not (converted:match("^<h[1-3]>")) then
            converted = "<p>" .. converted .. "</p>"
        end

        table.insert(body_lines, indent .. converted)
    end

    -- Wrap with basic HTML structure with indentation
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
