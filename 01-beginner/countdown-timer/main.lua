local function sleep(seconds_to_wait)
    local anchor_time = os.time()
    local now = os.time()

    while now < (anchor_time + seconds_to_wait) do
        now = os.time()
    end
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
                io.write("\rCountdown: " .. i .. "   ")  -- "\r" brings cursor back
                io.flush() -- ensures output appears immediately
                sleep(1)
            end
            print("Time's up!")
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
