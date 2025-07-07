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

-- ✅ Determine indent level
local indent_level = tonumber(cli_args.indent)
if not indent_level or indent_level < 1 or indent_level > 10 then
    indent_level = 4
end

local indent_unit = string.rep(" ", indent_level)
print(string.format("Indentation set to %d spaces.", indent_level))

local function parse_inline_formatting(text)
    text = text:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")
    text = text:gsub("%*(.-)%*", "<em>%1</em>")
    text = text:gsub("`(.-)`", "<code>%1</code>")
    return text
end

local function parse_headers(line)
    line = line:gsub("^####%s*(.+)", "<h4>%1</h4>")
    line = line:gsub("^###%s*(.+)", "<h3>%1</h3>")
    line = line:gsub("^##%s*(.+)", "<h2>%1</h2>")
    line = line:gsub("^#%s*(.+)", "<h1>%1</h1>")
    return line
end

local function parse_ordered_list(lines, start_index)
    local result = {}
    local i = start_index
    table.insert(result, "        <ol>")

    while i <= #lines do
        local line = lines[i]
        local list_item = line:match("^%d+%.%s+(.+)")
        if not list_item then
            break
        end

        list_item = parse_inline_formatting(list_item)
        table.insert(result, "            <li>" .. list_item)

        -- Check for indented continuation lines
        i = i + 1
        while i <= #lines do
            local next_line = lines[i]
            if next_line:match("^%s") and not next_line:match("^%d+%.%s+") then
                local para = parse_inline_formatting(next_line)
                table.insert(result, "                <p>" .. para .. "</p>")
                i = i + 1
            else
                break
            end
        end

        table.insert(result, "            </li>")
    end

    table.insert(result, "        </ol>")
    return result, i
end

local function parse_unordered_list(lines, start_index)
    local result = {}
    local i = start_index
    table.insert(result, "        <ul>")

    while i <= #lines do
        local line = lines[i]
        local list_item = line:match("^%-[%s]+(.+)")
        if not list_item then
            break
        end

        list_item = parse_inline_formatting(list_item)
        table.insert(result, "            <li>" .. list_item .. "</li>")
        i = i + 1
    end

    table.insert(result, "        </ul>")
    return result, i
end

local function parse_paragraph(line)
    line = parse_inline_formatting(line)
    return "    <p>" .. line .. "</p>"
end

local function parse_blockquotes(lines, start_index, base_indent)
    local result = {}
    local i = start_index
    local blockquote_stack = {}

    base_indent = base_indent or "" -- default to empty string if not passed

    while i <= #lines do
        local line = lines[i]
        local level, content = line:match("^(>+)%s*(.*)")
        if not level then
            break
        end

        local depth = #level
        content = parse_inline_formatting(content)

        -- Close deeper blockquotes
        while #blockquote_stack > depth do
            table.insert(result, base_indent .. string.rep("    ", #blockquote_stack - 1) .. "</blockquote>")
            table.remove(blockquote_stack)
        end

        -- Open new blockquotes
        while #blockquote_stack < depth do
            table.insert(result, base_indent .. string.rep("    ", #blockquote_stack) .. "<blockquote>")
            table.insert(blockquote_stack, true)
        end

        -- Add content inside current depth
        table.insert(result, base_indent .. string.rep("    ", #blockquote_stack) .. "<p>" .. content .. "</p>")

        i = i + 1
    end

    -- Close any remaining open blockquotes
    while #blockquote_stack > 0 do
        table.insert(result, base_indent .. string.rep("    ", #blockquote_stack - 1) .. "</blockquote>")
        table.remove(blockquote_stack)
    end

    return result, i
end

local function markdown_to_html(markdown)
    local body_lines = {}
    local lines = {}

    -- Helper function for repeated indentation
    local function indent(level)
        return string.rep(indent_unit, level)
    end

    -- Split markdown into lines
    for line in markdown:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Process each line
    local i = 1
    while i <= #lines do
        local line = lines[i]
        if line:match("^%d+%.%s+") then
            local list_block, next_index = parse_ordered_list(lines, i)
            for _, l in ipairs(list_block) do
                table.insert(body_lines, indent(2) .. l) -- indent inside <body>
            end
            i = next_index
        elseif line:match("^%-[%s]+") then
            local ul_block, next_index = parse_unordered_list(lines, i)
            for _, l in ipairs(ul_block) do
                table.insert(body_lines, indent(2) .. l)
            end
            i = next_index
        elseif line:match("^>+") then
            local parsed_blockquotes, next_index = parse_blockquotes(lines, i, indent(2))
            for _, bq_line in ipairs(parsed_blockquotes) do
                table.insert(body_lines, bq_line)
            end
            i = next_index
        else
            local header = parse_headers(line)
            if header == line then
                table.insert(body_lines, indent(2) .. parse_paragraph(line))
            else
                table.insert(body_lines, indent(2) .. header)
            end
            i = i + 1
        end
    end

    -- Assemble HTML with correct nested indentation
    local html_lines = {}
    table.insert(html_lines, "<!DOCTYPE html>")
    table.insert(html_lines, "<html lang=\"en\">")
    table.insert(html_lines, indent(1) .. "<head>")
    table.insert(html_lines, indent(2) .. "<meta charset=\"UTF-8\">")
    table.insert(html_lines, indent(2) .. "<title>Markdown Output</title>")
    table.insert(html_lines, indent(2) .. "<style>")
    table.insert(html_lines, indent(3) .. "body { font-family: Arial, sans-serif; line-height: 1.6; margin: 40px; }")
    table.insert(html_lines, indent(3) .. "code { background: #f4f4f4; padding: 2px 4px; border-radius: 3px; }")
    table.insert(html_lines, indent(2) .. "</style>")
    table.insert(html_lines, indent(1) .. "</head>")
    table.insert(html_lines, indent(1) .. "<body>")

    -- Insert parsed body content
    for _, line in ipairs(body_lines) do
        table.insert(html_lines, line)
    end

    table.insert(html_lines, indent(1) .. "</body>")
    table.insert(html_lines, "</html>")

    return table.concat(html_lines, "\n")
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
