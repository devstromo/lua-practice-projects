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
        print("Transaction added: " .. amount .. " " .. category .. " " .. date)
    elseif option == 2 then
        print("Viewing all transactions")
        local file = io.open("register.csv", "r")
        if file == nil then
            print("Error: Unable to open register.csv.")
            return
        end
        local header = file:read("*line") -- Read the header line
        print("Transactions:")
        print(header)
        -- Read each line and print the transaction details
        for line in file:lines() do
            local amount, category, date = line:match("([^,]+),([^,]+),([^,]+)")
            if amount and category and date then
                print(string.format("Amount: %s, Category: %s, Date: %s", amount, category, date))
            end
        end
        file:close()
        print("End of transactions")
    elseif option == 3 then
        print("Viewing transactions by category")
        -- Here you would implement the logic to view transactions by category
    elseif option == 4 then
        print("Viewing transactions by date")
        -- Here you would implement the logic to view transactions by date
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
