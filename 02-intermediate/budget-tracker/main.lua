local function init()
    local file = io.open("register.csv", "w")
    if file == nil then
        print("Error: Unable to register.csv.")
        return
    end
    file:write("amount,category,date\n")	
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
        io.write("Enter the category: ")
        local category = io.read()
        io.write("Enter the date (YYYY-MM-DD): ")
        local date = io.read()
        print("Transaction added: " .. amount .. " " .. category .. " " .. date)
    elseif option == 2 then
        print("Viewing all transactions")
        -- Here you would implement the logic to view all transactions
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
