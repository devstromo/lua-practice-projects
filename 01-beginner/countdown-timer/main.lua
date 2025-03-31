local function sleep(seconds_to_wait)
    local anchor_time = os.time()
    local now = os.time()

    while now < (anchor_time + seconds_to_wait) do
        now = os.time()
    end
end

local function draw_progress_bar(elapsed, total, bar_length)
    local percent = elapsed / total
    local filled = math.floor(percent * bar_length)
    local empty = bar_length - filled
    local bar = "<" .. string.rep("=", filled) .. string.rep("-", empty) .. ">"
    return bar
end

-- MAIN
local input = [[
Welcome to the countdown timer, what would you like to do?
1. Start countdown
2. Help
3. Exit
]]

repeat
    io.write(input)

    local option = io.read("*number")
    local _ = io.read()
    if option == 1 then
        print("Starting countdown...")
        io.write("Enter the countdown time in seconds: ")
        local countdown_time = io.read("*number")
        if countdown_time and countdown_time > 0 then
            sleep(1)
            for i = countdown_time, 1, -1 do
                local bar = draw_progress_bar(countdown_time - i, countdown_time, 20)
                io.write("\r" .. bar .. " Countdown: " .. i .. "   ") -- "\r" brings cursor back
                io.flush() -- ensures output appears immediately
                sleep(1)
            end
            print("\nTime's up!")
        else
            print("Invalid input. Please enter a positive number.")
        end
    elseif option == 2 then
        print("Help\n")
    elseif option == 3 then
        print("Exit\n")
    else
        print("Invalid option. Please try again.")
    end
until option == 3 or option == nil
