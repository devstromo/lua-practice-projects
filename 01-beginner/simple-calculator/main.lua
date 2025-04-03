

-- MAIN

local input = [[
Welcome to the simple calculator, what would you like to do?
1. Add
2. Subtract
3. Multiply
4. Divide
5. Help
6. Exit
]]

repeat
    io.write(input)
    local option = io.read("*number")
    local _ = io.read()
    if option == 1 then
        print("Addition")
        io.write("Enter first number: ")
        local num1 = io.read("*number")
        io.write("Enter second number: ")
        local num2 = io.read("*number")
        print("Result: " .. (num1 + num2))
    elseif option == 2 then
        print("Subtraction")
        io.write("Enter first number: ")
        local num1 = io.read("*number")
        io.write("Enter second number: ")
        local num2 = io.read("*number")
        print("Result: " .. (num1 - num2))
    elseif option == 3 then
        print("Multiplication")
        io.write("Enter first number: ")
        local num1 = io.read("*number")
        io.write("Enter second number: ")
        local num2 = io.read("*number")
        print("Result: " .. (num1 * num2))
    elseif option == 4 then
        print("Division")
        io.write("Enter first number: ")
        local num1 = io.read("*number")
        io.write("Enter second number: ")
        local num2 = io.read("*number")
        if num2 == 0 then
            print("Error: Division by zero is not allowed.")
        else
            print("Result: " .. (num1 / num2))
        end
    elseif option == 5 then
        print("\n=== Help ===")
        print("1. Add:")
        print("   - Choose option 1 to add two numbers.")
        print("   - You will be asked to enter the two numbers.\n")

        print("2. Subtract:")
        print("   - Choose option 2 to subtract two numbers.")
        print("   - You will be asked to enter the two numbers.\n")

        print("3. Multiply:")
        print("   - Choose option 3 to multiply two numbers.")
        print("   - You will be asked to enter the two numbers.\n")

        print("4. Divide:")
        print("   - Choose option 4 to divide two numbers.")
        print("   - You will be asked to enter the two numbers.")
        print("   - Division by zero is not allowed.\n")

        print("5. Help:")
        print("   - Displays this message to explain how the calculator works.\n")

        print("6. Exit:")
        print("   - Choose option 6 to exit the application.\n")
    elseif option == 6 then
        print("Exit\n")
    else
        print("Invalid option. Please try again.")
    end
    
until option == 6 or option == nil