local websocket = require("websocket")

print("LuaWebSocket loaded!")
-- MAIN

local input = [[
Welcome to the web scraper, what would you like to do?
1. Scrape a webpage
2. Extract links
3. Extract images
4. Extract text
5. Extract tables
6. Extract all
7. Help
8. Exit
]]

repeat
    io.write(input)
    io.write("Enter your option: ")
    local option = io.read("*number")
    local _ = io.read()
    if option == 1 then
        print("Scraping a webpage")
        io.write("Enter URL: ")
        local url = io.read()
        print("Scraping " .. url .. "...")
    elseif option == 2 then
        print("Extracting links")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting links from " .. url .. "...")
        -- Here you would implement the logic to extract links from the webpage
    elseif option == 3 then
        print("Extracting images")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting images from " .. url .. "...")
        -- Here you would implement the logic to extract images from the webpage
    elseif option == 4 then
        print("Extracting text")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting text from " .. url .. "...")
        -- Here you would implement the logic to extract text from the webpage
    elseif option == 5 then
        print("Extracting tables")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting tables from " .. url .. "...")
        -- Here you would implement the logic to extract tables from the webpage
    elseif option == 6 then
        print("Extracting all")
        io.write("Enter URL: ")
        local url = io.read()
        print("Extracting all from " .. url .. "...")
        -- Here you would implement the logic to extract all data from the webpage
    elseif option == 7 then
        print("Help")
        print("1. Scrape a webpage: Enter a URL to scrape the webpage.")
        print("2. Extract links: Enter a URL to extract all links from the webpage.")
        print("3. Extract images: Enter a URL to extract all images from the webpage.")
        print("4. Extract text: Enter a URL to extract all text from the webpage.")
        print("5. Extract tables: Enter a URL to extract all tables from the webpage.")
        print("6. Extract all: Enter a URL to extract all data from the webpage.")
        print("7. Help: Show this help message ")
        print("8. Exit: Exit the program.")
    elseif option == 8 then
        print("Exiting the program.")
    else
        print("Invalid option, please try again.")
    end
until option == 8 or option == nil
