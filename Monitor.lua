local lfs = require("lfs")

-- Define download and move folder paths, to be set via the Python interface
local sourceFolder = arg[1] or "downloads"
local moveFolder = sourceFolder

-- Ensure download and move folders exist, create them if they don't
local function ensureFoldersExist()
    if not lfs.attributes(sourceFolder, "mode") then
        os.execute('mkdir "' .. sourceFolder .. '"')
    end
    if not lfs.attributes(moveFolder, "mode") then
        os.execute('mkdir "' .. moveFolder .. '"')
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
    local fileName = string.match(filePath, "[^\\]+$")
    local fileExt = string.match(fileName, "%..+$")
    local targetFolder = targetFolders[fileExt]
    if targetFolder then
        -- Check if target folder exists, create it if not
        if not lfs.attributes(targetFolder, "mode") then
            os.execute('mkdir "' .. targetFolder .. '"')
        end
        -- Attempt to move the file
        local targetPath = targetFolder .. "\\" .. fileName
        local success, err = os.rename(filePath, targetPath)
        if success then
            print("Moved " .. fileName .. " to " .. targetFolder)
        else
            -- Handle error if move fails (e.g., permission issue)
            print("Error moving " .. fileName .. ": " .. err)
        end
    end
end

-- Function to scan the download folder for new files
local function scanFolder()
    for file in lfs.dir(sourceFolder) do
        if file ~= "." and file ~= ".." then
            local filePath = sourceFolder .. "\\" .. file
            local attr = lfs.attributes(filePath)
            if attr and attr.mode == "file" then
                moveFile(filePath)
            end
        end
    end
end

-- Initial scan
scanFolder()

-- Polling loop to check for new files every 1 second
while true do
    scanFolder()
    os.execute("timeout /t 1 /nobreak >nul")
end

print("Download folder organization completed!")
