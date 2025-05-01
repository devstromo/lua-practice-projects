local function init()

    -- Check if the file exists
    local file = io.open("register.csv", "r")
    if file then
        -- File exists, close it
        file:close()
    else
        -- File does not exist, create it
        createFile()
    end
end

local function createFile()
    -- Create the file and write the header
    local file = io.open("register.csv", "w")
    if file == nil then
        print("Error: Unable to register.csv.")
        return
    end
    file:write("amount,category,date\n")
    file:close()
end

local function addTransaction(amount, category, date)
    local file = io.open("register.csv", "a")
    if file == nil then
        print("Error: Unable to open register.csv.")
        return
    end
    file:write(string.format("%s,%s,%s\n", amount, category, date))
    file:close()
end

local function checkDateFormat(date)
    -- Check if the date is in the correct format (YYYY-MM-DD)
    local pattern = "%d%d%d%d%-%d%d%-%d%d"
    return date:match(pattern) ~= nil
end
local function checkDateRange(start_date, end_date)
    -- Check if the start date is before the end date
    local start_year, start_month, start_day = start_date:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
    local end_year, end_month, end_day = end_date:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
    return os.time({
        year = start_year,
        month = start_month,
        day = start_day
    }) < os.time({
        year = end_year,
        month = end_month,
        day = end_day
    })
end
local function checkDateInRange(date, start_date, end_date)
    -- Check if the date is within the specified range
    return date >= start_date and date <= end_date
end

-- MAIN
local input = [[
Welcome to the budget tracker?
1. Add a new transaction
2. View all transactions
3. View transactions by category
4. View transactions by date
5. Help
6. Exit
]]

init()

repeat
    io.write(input)
    io.write("Enter your option: ")
    local option = io.read("*number")
    local _ = io.read()
    if option == 1 then
        print("Adding a new transaction")
        io.write("Enter the amount: ")
        local amount = io.read("*number")
        local _ = io.read()
        io.write("Enter the category: ")
        local category = io.read()
        io.write("Enter the date (YYYY-MM-DD): ")
        local date = io.read()
        addTransaction(amount, category, date)
        print("Transaction added: " .. amount .. " " .. category .. " " .. date .. "\n")
    elseif option == 2 then
        print("Viewing all transactions")
        local file = io.open("register.csv", "r")
        if file == nil then
            print("Error: Unable to open register.csv.")
            return
        end
        local header = file:read("*line") -- Read the header line
        print("\n---- Transactions ----\n")
        -- Read each line and print the transaction details
        for line in file:lines() do
            local amount, category, date = line:match("([^,]+),([^,]+),([^,]+)")
            if amount and category and date then
                print(string.format("Amount: %s, Category: %s, Date: %s", amount, category, date))
            end
        end
        file:close()
        print("\n---- End of transactions ----\n")

    elseif option == 3 then
        print("Viewing transactions by category")
        io.write("Enter the category: ")
        local category = io.read()
        local file = io.open("register.csv", "r")
        if file == nil then
            print("Error: Unable to open register.csv.")
            return
        end
        local header = file:read("*line") -- Read the header line
        print("\n---- Transactions ----\n")
        -- Read each line and print the transaction details
        local found = false
        for line in file:lines() do
            local amount, cat, date = line:match("([^,]+),([^,]+),([^,]+)")
            if amount and cat == category and date then
                found = true
                print(string.format("Amount: %s, Category: %s, Date: %s", amount, cat, date))
            end
        end
        if not found then
            print("No transactions found for category: " .. category)
        end
        file:close()
        print("\n---- End of transactions ----\n")
    elseif option == 4 then
        print("Viewing transactions by date")
        -- Here you would implement the logic to view transactions by date
        io.write("Enter the start date (YYYY-MM-DD): ")
        local star_date = io.read()
        io.write("Enter the end date (YYYY-MM-DD): ")
        local end_date = io.read()
        local check_start_date = checkDateFormat(star_date)
        local check_end_date = checkDateFormat(end_date)
        if not check_start_date or not check_end_date then
            print("Invalid date format. Please use YYYY-MM-DD.")
            return
        end
        -- Check if the start date is before the end date
        if not checkDateRange(star_date, end_date) then
            print("Start date must be before end date.")
            return
        end
      
        local file = io.open("register.csv", "r")
        if file == nil then
            print("Error: Unable to open register.csv.")
            return
        end
        local header = file:read("*line") -- Read the header line
        print("\n---- Transactions ----\n")
        -- Read each line and print the transaction details
        local found = false
        for line in file:lines() do
            local amount, category, date = line:match("([^,]+),([^,]+),([^,]+)")
            if amount and category and date then
                -- Check if the date is within the specified range
                if checkDateInRange(date, star_date, end_date)  then
                    found = true
                    print(string.format("Amount: %s, Category: %s, Date: %s", amount, category, date))
                end
            end
        end
        -- If no transactions were found, print a message
        if not found then
            print("No transactions found between " .. star_date .. " and " .. end_date)
        end
        file:close()
        print("\n---- End of transactions ----\n")
    elseif option == 5 then
        print("Help")
        -- Here you would implement the help section
    elseif option == 6 then
        print("Exiting...")
    else
        print("Invalid option, please try again.")
    end
    io.write("Press Enter to continue...")

until option == 6
