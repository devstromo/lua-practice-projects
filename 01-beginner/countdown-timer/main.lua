local function sleep(seconds_to_wait)
    local anchor_time = os.time()
    local now = os.time()

    while now < (anchor_time + seconds_to_wait) do
        now = os.time()
    end
end

local function draw_progress_bar(current, total, bar_length)
    local percent = current / total
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
            for i = countdown_time, 0, -1 do
                local elapsed = countdown_time - i
                local bar = draw_progress_bar(elapsed, countdown_time, 20)
                io.write("\r" .. bar .. " Countdown: " .. i .. "   ") -- "\r" brings cursor back
                io.flush()                                            -- ensures output appears immediately
                sleep(1)
            end
            print("\nTime's up!")
        else
            print("Invalid input. Please enter a positive number.")
        end
    elseif option == 2 then
        print("\n=== Help ===")
        print("1. Start Countdown:")
        print("   - Choose option 1 to start a countdown.")
        print("   - You will be asked to enter the time in seconds.")
        print("   - A progress bar and countdown will appear.")
        print("   - When it reaches 0, you'll see 'Time's up!'\n")

        print("2. Help:")
        print("   - Displays this message to explain how the timer works.\n")

        print("3. Exit:")
        print("   - Choose option 3 to exit the application.\n")
    elseif option == 3 then
        print("Exit\n")
    else
        print("Invalid option. Please try again.")
    end
until option == 3 or option == nil
