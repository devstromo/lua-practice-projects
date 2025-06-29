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

print("Markdown to HTML Converter is running...")
if not cli_args.source then
    io.write("Input file route: ")
    local user_input = io.read()
else
    print("Input file:", cli_args.source)
end

print("Output file:", cli_args.output or "output.html")

local source_file = cli_args.source or "input.md"
local output_file = cli_args.output or "output.html"
convert_markdown_to_html(source_file, output_file)
