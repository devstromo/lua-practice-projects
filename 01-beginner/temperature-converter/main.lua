local input = [[
Choose a convert option number
]] .. "\n\n1. Convert F into Celsius \n"
    .. "2. Convert C into Fahrenheit\n"
    .. "3. Convert K into C\n"
    .. "4. Convert C into K\n"
    .. "5. Convert K into F\n"
    .. "6. Convert F into K\n"
    .. "Enter your option: "
io.write(input)
local option = io.read("*number")
if option == 1 then
    io.write("Enter Fahrenheit: ")
    local f = io.read("*number")
    local c = (f - 32) * 5 / 9
    local formatted_result = string.format("%.4f", c)
    print("Celsius: " .. formatted_result)
elseif option == 2 then
    io.write("Enter Celsius: ")
    local c = io.read("*number")
    local f = c * 9 / 5 + 32
    local formatted_result = string.format("%.4f", f)
    print("Fahrenheit: " .. formatted_result)
elseif option == 3 then
    io.write("Enter Kelvin: ")
    local k = io.read("*number")
    local c = k - 273.15
    local formatted_result = string.format("%.4f", c)
    print("Celsius: " .. formatted_result)
elseif option == 4 then
    io.write("Enter Celsius: ")
    local c = io.read("*number")
    local k = c + 273.15
    local formatted_result = string.format("%.4f", k)
    print("Kelvin: " .. formatted_result)
elseif option == 5 then
    io.write("Enter Kelvin: ")
    local k = io.read("*number")
    local f = (k - 273.15) * 9 / 5 + 32
    local formatted_result = string.format("%.4f", f)
    print("Fahrenheit: " .. formatted_result)
elseif option == 6 then
    io.write("Enter Fahrenheit: ")
    local f = io.read("*number")
    local k = ((f - 32) * 5 / 9) + 273.15
    local formatted_result = string.format("%.4f", k)
    print("Kelvin: " .. formatted_result)
else
    print("Invalid option")
end
