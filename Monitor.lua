local lfs = require("lfs")  -- Import the LuaFileSystem (lfs) library for directory manipulation


local sourceFolder = arg[1]  -- Set sourceFolder to the first argument passed to the script

-- Function to ensure the specified folder exists, and create it if it doesn't
local function ensureFoldersExist()
    -- Check if the sourceFolder exists
    if not lfs.attributes(sourceFolder, "mode") then
        os.execute('mkdir "' .. sourceFolder .. '"')  -- Create sourceFolder if it doesn't exist
    end
end

-- Call the function to ensure folders exist
ensureFoldersExist()

-- Define target folders for various file extensions 
local targetFolders = {
    [".pdf"] = sourceFolder .. "\\Documents\\PDFs",
    [".txt"] = sourceFolder .. "\\Documents\\TextDoc",
    [".jpg"] = sourceFolder .. "\\Pictures",
    [".jpeg"] = sourceFolder .. "\\Pictures",
    [".docx"] = sourceFolder .. "\\Documents\\WordDocs",
    [".doc"] = sourceFolder .. "\\Documents\\WordDocs",
    [".png"] = sourceFolder .. "\\Pictures",
    [".gif"] = sourceFolder .. "\\Pictures",
    [".mp3"] = sourceFolder .. "\\Music",
    [".wav"] = sourceFolder .. "\\Music",
    [".mp4"] = sourceFolder .. "\\Videos",
    [".avi"] = sourceFolder .. "\\Videos",
    [".mkv"] = sourceFolder .. "\\Videos",
    [".pptx"] = sourceFolder .. "\\Documents\\Powerpoint",
    [".ppt"] = sourceFolder .. "\\Documents\\Powerpoint",
    [".xls"] = sourceFolder .. "\\Documents\\Excel",
    [".xlsx"] = sourceFolder .. "\\Documents\\Excel",
    [".zip"] = sourceFolder .. "\\Archives",
    [".rar"] = sourceFolder .. "\\Archives",
    [".7z"] = sourceFolder .. "\\Archives",
    [".html"] = sourceFolder .. "\\WebPages",
    [".css"] = sourceFolder .. "\\WebPages",
    [".js"] = sourceFolder .. "\\WebPages",
    [".json"] = sourceFolder .. "\\DataFiles",
    [".xml"] = sourceFolder .. "\\DataFiles",
    [".exe"] = sourceFolder .. "\\Applications",
    [".msi"] = sourceFolder .. "\\Applications",
    [".py"] = sourceFolder .. "\\Scripts",
    [".java"] = sourceFolder .. "\\Code\\Java",
    [".class"] = sourceFolder .. "\\Code\\Java",
    [".md"] = sourceFolder .. "\\Documents\\Markdown",
    [".log"] = sourceFolder .. "\\Logs",
    [".rtf"] = sourceFolder .. "\\Documents\\TextDoc",
    [".svg"] = sourceFolder .. "\\Pictures\\Illustrator",
    [".iso"] = sourceFolder .. "\\Images\\DiscImages"
}

-- Function for moving a file to its corresponding folder based on extension
local function moveFile(filePath)
    local fileName = string.match(filePath, "[^\\]+$")  -- Extract the file name from the file path
    local fileExt = string.match(fileName, "%..+$")  -- Extract the file extension from the file name
    local targetFolder = targetFolders[fileExt]  -- Look up the target folder for the file extension
    if targetFolder then  -- If a target folder is defined for this extension
        -- Check if the target folder exists, create it if not
        if not lfs.attributes(targetFolder, "mode") then
            os.execute('mkdir "' .. targetFolder .. '"')  -- Create the target folder if it doesn't exist
        end
        -- Attempt to move the file to the target folder
        local targetPath = targetFolder .. "\\" .. fileName  -- Construct the target file path
        local success, err = os.rename(filePath, targetPath)  -- Move the file
        if success then
            print("Moved " .. fileName .. " to " .. targetFolder)  -- Print a success message
        else
            -- Handle error if the move fails (e.g., permission issue)
            print("Error moving " .. fileName .. ": " .. err)  -- Print an error message
        end
    end
end

-- Function to scan the specified folder for new files
local function scanFolder()
    for file in lfs.dir(sourceFolder) do  -- Iterate over all files in the sourceFolder
        if file ~= "." and file ~= ".." then  -- Ignore the current and parent directory entries
            local filePath = sourceFolder .. "\\" .. file  -- Construct the full file path
            local attr = lfs.attributes(filePath)  -- Get the file attributes
            if attr and attr.mode == "file" then  -- If the item is a file
                moveFile(filePath)  -- Move the file to the corresponding folder
            end
        end
    end
end

-- Initial scan to move existing files
scanFolder()

-- Polling loop to check for new files every 1 second
while true do
    scanFolder()  -- Scan the folder for new files
    os.execute("timeout /t 1 /nobreak >nul")  -- Wait for 1 second before the next scan (Windows-specific)
end
