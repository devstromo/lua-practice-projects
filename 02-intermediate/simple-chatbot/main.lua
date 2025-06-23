-- A simple chatbot that responds to user input with predefined answers.
local MAX_HISTORY = 50
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

math.randomseed(os.time())

local function normalize(text)
    return text:lower():gsub("%p", ""):gsub("^%s*(.-)%s*$", "%1")
end

local function get_formatted_timestamp()
    local now = os.time()
    local formatted = os.date("[%Y/%m/%d %H:%M:%S", now)

    local millis = math.floor((os.clock() % 1) * 10000) -- 4 digits for .ssss

    return string.format("%s.%04d]", formatted, millis)
end

local ok, response_data = pcall(require, "responses")
if not ok then
    print("Error loading responses:", response_data)
    return
end

local function bot(input, response_data)
    local msg = normalize(input)

    -- Check slash commands first
    if response_data.slash_commands and response_data.slash_commands[input] then
        return response_data.slash_commands[input]
    end

    for _, category in pairs(response_data) do
        if category.keywords then
            for _, keyword in ipairs(category.keywords) do
                if msg:find(keyword) then
                    local responses = category.replies
                    return responses[math.random(#responses)]
                end
            end
        end
    end

    -- Fallback
    local fallback = response_data.fallback
    if fallback and fallback.replies then
        return fallback.replies[math.random(#fallback.replies)]
    else
        return "Sorry, I don't understand."
    end
end

local function load_log_file()
    local date_str = os.date("%Y_%m_%d")
    local default_filename = date_str .. "_chat_log.txt"

    local log_file_path = cli_args.log_file or default_filename

    local file, err = io.open(log_file_path, "a+")
    if not file then
        print("Error opening log file:", err)
        return nil
    end

    print("Logging to:", log_file_path)
    return file
end

local log_file = load_log_file()
if not log_file then
    print("Exiting due to log file error.")
    return
end

local chat_history = {}

local function save_chat_history_to_file()
    if #chat_history == 0 then
        return
    end

    local timestamp = os.date("%Y%m%d_%H%M%S")
    local filename = string.format("session_%s.txt", timestamp)
    local file, err = io.open(filename, "w")
    if not file then
        print("Error saving session:", err)
        return
    end

    for _, entry in ipairs(chat_history) do
        file:write(string.format("User: %s\nBot: %s\n\n", entry.user, entry.bot))
    end
    file:close()
    print("✅ Chat history saved to:", filename)
end

local function show_summary()
    local total_lines = #chat_history
    local unique_user_inputs = {}
    local keywords_used = {}

    for _, entry in ipairs(chat_history) do
        unique_user_inputs[entry.user] = true

        -- extract basic keywords (split by space, you can improve later)
        for word in entry.user:lower():gmatch("%w+") do
            keywords_used[word] = (keywords_used[word] or 0) + 1
        end
    end

    local keyword_list = {}
    for k, v in pairs(keywords_used) do
        table.insert(keyword_list, {
            word = k,
            count = v
        })
    end
    table.sort(keyword_list, function(a, b)
        return a.count > b.count
    end)

    print("\n📊 Chat Summary:")
    print("Total exchanges:", total_lines)
    print("Unique user inputs:", tostring(#(function(tbl)
        local count = 0
        for _ in pairs(tbl) do
            count = count + 1
        end
        return {count}
    end)(unique_user_inputs)))
    print("Top keywords used:")
    for i = 1, math.min(5, #keyword_list) do
        print("  " .. keyword_list[i].word .. " (" .. keyword_list[i].count .. ")")
    end
    print()
end

-- Chat loop
print("ChatBot is running. Type 'exit' or 'bye' to quit.")
while true do
    io.write("You: ")
    local user_input = io.read()
    if not user_input then
        break
    end -- handle Ctrl+D or EOF

    local msg = normalize(user_input)
    print("Log message:", msg)
    if msg == "/exit" or msg == "bye" or msg == "exit" then
        print("Bot: Goodbye!")
        break
    end

    if user_input == "/log" then
        print("Chat History:")
        for _, entry in ipairs(chat_history) do
            print("You: " .. entry.user)
            print("Bot: " .. entry.bot)
        end
        goto continue
    end

    if user_input == "/clear" then
        if #chat_history > 0 then
            show_summary()
            save_chat_history_to_file()
        end
        chat_history = {}
        print("Chat history cleared and saved.")
        goto continue
    end

    local reply = bot(user_input, response_data)
    print("Bot:", reply)
    table.insert(chat_history, {
        user = user_input,
        bot = reply
    })
    while #chat_history > MAX_HISTORY do
        table.remove(chat_history, 1)
    end
    if cli_args["save-chat"] then
        local formatted_time = get_formatted_timestamp()
        log_file:write(string.format("%s User: %s\n%s Bot: %s\n", formatted_time, user_input, formatted_time, reply))
        log_file:flush()
    end
    ::continue::
end
log_file:close()