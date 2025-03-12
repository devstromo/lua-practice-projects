io.write("Convert F into Celsius: ")
local f = io.read("*number")
local c = (f - 32) * 5 / 9
print("Celsius: " .. c)