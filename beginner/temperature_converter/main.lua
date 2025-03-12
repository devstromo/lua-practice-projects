io.write("Convert F into Celsius: ")
local f = io.read("*number")
local c = (f - 32) * 5 / 9
local formatted_result = string.format("%.4f", c)
print("Celsius: " .. formatted_result)