local input = [[
Choose a convert option number
]] .. "\n\n1. Convert F into Celsius \n"
    .. "2. Convert C into Fahrenheit\n\n"
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
else
    print("Invalid option")
end
