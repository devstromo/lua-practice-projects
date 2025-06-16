-- A simple chatbot that responds to user input with predefined answers.
local cli_args = {}
for _, arg_str in ipairs(arg or {}) do
    local key, val = arg_str:match("^%-%-(.-)=(.+)$")
    if key and val then
        cli_args[key] = val
    end
end

local function normalize(text)
    return text:lower():gsub("%p", ""):gsub("^%s*(.-)%s*$", "%1")
end

-- Bot logic
local responses = {
    hello = "Hi there!",
    hi = "Hello!",
    how = "I'm just a bot, but I'm doing fine!",
    thanks = "You're welcome!",
    ["whats your name"] = "I'm LuaBot!"
}

local function bot(input)
    local msg = normalize(input)
    for keyword, reply in pairs(responses) do
        if msg:find(keyword) then
            return reply
        end
    end
    return "Sorry, I don't understand."
end

local function load_log_file()
    local log_file_path = cli_args.log_file or "chat_log.txt"
    local file, err = io.open(log_file_path, "a+")
    if not file then
        print("Error opening log file:", err)
        return nil
    end
    return file
end

local log_file = load_log_file()
if not log_file then
    print("Exiting due to log file error.")
    return
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
    if msg == "exit" or msg == "bye" then
        print("Bot: Goodbye!")
        break
    end

    local reply = bot(user_input)
    print("Bot:", reply)
    if cli_args.save_chat then
        f:write(string.format("User: %s\nBot: %s\n", user_input, reply))
    end
end
