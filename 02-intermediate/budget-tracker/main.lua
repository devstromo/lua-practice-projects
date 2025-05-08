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
    file:write(string.format("%s,%s,%s\n", amount, string.upper(category), date))
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

local function isValidDate(date_str)
    -- First, match the format
    local y, m, d = date_str:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
    if not y or not m or not d then return false end

    -- Convert to numbers
    y, m, d = tonumber(y), tonumber(m), tonumber(d)

    -- Try to create a valid timestamp
    local timestamp = os.time({ year = y, month = m, day = d })
    if not timestamp then return false end

    -- Convert back to date to verify correctness
    local real_y, real_m, real_d = os.date("*t", timestamp).year, os.date("*t", timestamp).month, os.date("*t", timestamp).day

    return y == real_y and m == real_m and d == real_d
end

-- MAIN
local input = [[
Welcome to the budget tracker?
1. Add a new transaction
2. View all transactions
3. View transactions by category
4. View transactions by date
5. Total spent
6. Total spent by category
7. Total spent by date
8. Total spent by date range
9. Total spent by category and date
10. Total spent by category and date range
11. Help
12. Exit
]]

init()

while true do
    io.write(input)
    io.write("Enter your option: ")
    local option = io.read("*number")
    local _ = io.read()
    ::continue::
    if option == 1 then
        print("Adding a new transaction")
        io.write("Enter the amount: ")
        local amount = io.read("*number")
        local _ = io.read()
        io.write("Enter the category: ")
        local category = io.read()
        io.write("Enter the date (YYYY-MM-DD): ")
        local date = io.read()
        local check_date = checkDateFormat(date)
        if not check_date then
            print("Invalid date format. Please use YYYY-MM-DD.")
            goto continue
        end
        if not isValidDate(date) then
            print("Invalid date.")
            goto continue
        end
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
            if amount and string.upper(cat) == string.upper(category) and date then
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
        if not isValidDate(star_date) or not isValidDate(end_date) then
            print("One or both dates are invalid or incorrectly formatted.")
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
                if checkDateInRange(date, star_date, end_date) then
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
    elseif option == 12 then
        print("Help")
        print("1. Add a new transaction: Enter the amount, category, and date.")
        print("2. View all transactions: Displays all transactions in the register.")
        print("3. View transactions by category: Enter a category to filter transactions.")
        print("4. View transactions by date: Enter a start and end date to filter transactions.")
        print("5. Total spent: Displays the total amount spent.")
        print("6. Total spent by category: Enter a category to filter total amount spent.")
        print("7. Total spent by date: Enter a date to filter total amount spent.")
        print("8. Total spent by date range: Enter a start and end date to filter total amount spent.")
        print("9. Total spent by category and date: Enter a category and date to filter total amount spent.")
        print("10. Total spent by category and date range: Enter a category, start date, and end date to filter total amount spent.")
        print("11. Help: Displays this help message.")
        print("12. Exit: Exits the program.")
        print("Note: Dates should be in the format YYYY-MM-DD.")
        print("Note: Amounts should be numeric.")
        print("Note: Categories can be any string.")
        print("Note: The program will check for valid date formats and ranges.")
    elseif option == 12 then
        print("Exiting...")
        break
    else
        print("Invalid option, please try again.")
    end
    io.write("Press Enter to continue...")

end
