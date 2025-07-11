-- Parse CLI arguments into a table
local cli_args = {}
for _, arg_str in ipairs(arg or {}) do
    local key, val = arg_str:match("^%-%-(.-)=(.+)$")
    if key and val then
        cli_args[key] = val
    end
end

local plugins = {}

local function load_plugins()
    local plugin_list = {}

    if cli_args.plugins then
        for name in cli_args.plugins:gmatch("[^,]+") do
            table.insert(plugin_list, name)
        end
    else
        -- default plugins if none specified
        plugin_list = {
            "count_lines", 
            "status_codes", 
            "count_ip", 
            "requests_by_time", 
            "endpoint_filter",
            "error_type_tracker"
        }
    end

    for _, name in ipairs(plugin_list) do
        local ok, plugin = pcall(require, "analyzer.plugins." .. name)
        if ok and plugin and plugin.process_line then
            -- ✅ Pass CLI args to plugin if it wants them
            if plugin.set_args then
                plugin.set_args(cli_args)
            end

            table.insert(plugins, plugin)
        else
            print("Failed to load plugin:", name)
        end
    end
end

local input = [[
Welcome to the log analyzer!
This is a simple log analyzer that will help you analyze your logs.
Please enter the path to the log file you want to analyze:
]]

-- Function to print the welcome message
local function print_welcome_message()
    print(input)
end
-- Function to read the log file path from the user
local function read_log_file_path()
    print("Please enter the path to the log file you want to analyze:")
    local log_file_path = io.read()
    return log_file_path
end
-- Function to read the log file
local function read_log_file(log_file_path)
    local file = io.open(log_file_path, "r")
    if not file then
        print("Error: Could not open log file at " .. log_file_path)
        return nil
    end
    local log_data = file:read("*a")
    file:close()
    return log_data
end

local function analyze_file(path)
    local file = io.open(path, "r")
    if not file then
        print("Could not open file:", path)
        return
    end

    for line in file:lines() do
        for _, plugin in ipairs(plugins) do
            plugin.process_line(line)
        end
    end
    for _, plugin in ipairs(plugins) do
        if plugin.report then
            plugin.report()
        end
    end
    if cli_args.export then
        local f = io.open(cli_args.export, "w")
        if not f then
            print("Error: Could not open CSV export file:", cli_args.export)
            return
        end
        for _, plugin in ipairs(plugins) do
            if plugin.export_csv then
                plugin.export_csv(f)
            end
        end
        f:close()
        print("Summary exported to " .. cli_args.export)
    end
    if cli_args.html then
        local f = io.open(cli_args.html, "w")
        if not f then
            print("Error: Could not open HTML export file:", cli_args.html)
            return
        end
        for _, plugin in ipairs(plugins) do
            if plugin.export_html then
                plugin.export_html(f) -- ✅ pass file handle
            end
        end
        f:close()
        print("Summary exported to " .. cli_args.html)
    end

end

print_welcome_message()

local log_file_path = cli_args.file
if not log_file_path then
    log_file_path = read_log_file_path()
end

local log_data = read_log_file(log_file_path)
if not log_data then
    print("Error: Could not read log file.")
    return
end

load_plugins()
analyze_file(log_file_path)

