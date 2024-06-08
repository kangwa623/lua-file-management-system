-- Lua script for organizing the downloads folder by moving similar files
-- from the downloads folder to a subfolder within the downloads folder.
-- Each type of file is based on a specific set of file extensions.

local os = require("os")

-- Function to get the user's Downloads folder
local function getDownloadsFolder()
    local homeDrive = os.getenv("HOMEDRIVE") or "C:"
    local homePath = os.getenv("HOMEPATH") or "\\Users\\Default"
    return homeDrive .. homePath .. "\\Downloads"
end

local downloadFolder = getDownloadsFolder()
local moveFolder = downloadFolder

-- Target folders relative to the downloads folder
local fileExtensions = {
    [".pdf"] = downloadFolder .. "\\Documents\\PDFs",
    [".txt"] = downloadFolder .. "\\Documents\\TextDoc",
    [".jpg"] = downloadFolder .. "\\Pictures",
    [".jpeg"] = downloadFolder .. "\\Pictures",
    [".png"] = downloadFolder .. "\\Pictures",
    [".gif"] = downloadFolder .. "\\Pictures",
    [".bmp"] = downloadFolder .. "\\Pictures",
    [".doc"] = downloadFolder .. "\\Documents\\WordDocs",
    [".docx"] = downloadFolder .. "\\Documents\\WordDocs",
    [".xls"] = downloadFolder .. "\\Documents\\ExcelDocs",
    [".xlsx"] = downloadFolder .. "\\Documents\\ExcelDocs",
    [".ppt"] = downloadFolder .. "\\Documents\\PowerPointDocs",
    [".pptx"] = downloadFolder .. "\\Documents\\PowerPointDocs",
    [".zip"] = downloadFolder .. "\\Archives",
    [".rar"] = downloadFolder .. "\\Archives",
    [".7z"] = downloadFolder .. "\\Archives",
    [".tar"] = downloadFolder .. "\\Archives",
    [".gz"] = downloadFolder .. "\\Archives",
    [".mp3"] = downloadFolder .. "\\Music",
    [".wav"] = downloadFolder .. "\\Music",
    [".aac"] = downloadFolder .. "\\Music",
    [".flac"] = downloadFolder .. "\\Music",
    [".mp4"] = downloadFolder .. "\\Videos",
    [".avi"] = downloadFolder .. "\\Videos",
    [".mkv"] = downloadFolder .. "\\Videos",
    [".mov"] = downloadFolder .. "\\Videos",
    [".wmv"] = downloadFolder .. "\\Videos",
    [".exe"] = downloadFolder .. "\\Applications",
    [".msi"] = downloadFolder .. "\\Applications",
    [".html"] = downloadFolder .. "\\WebPages",
    [".htm"] = downloadFolder .. "\\WebPages",
    [".css"] = downloadFolder .. "\\WebPages",
    [".js"] = downloadFolder .. "\\WebPages",
    [".json"] = downloadFolder .. "\\WebPages",
    [".xml"] = downloadFolder .. "\\WebPages",
    [".csv"] = downloadFolder .. "\\Documents\\CSVs",
    [".log"] = downloadFolder .. "\\Documents\\Logs",
    [".ini"] = downloadFolder .. "\\Configurations",
    [".cfg"] = downloadFolder .. "\\Configurations",
    [".conf"] = downloadFolder .. "\\Configurations"
}

-- Function for checking extension and moving files
local function moveFile(filePath)
    local fileName = string.match(filePath, "[^\\]+$")
    local fileExt = string.match(fileName, "%..+$")
    local targetFolder = fileExtensions[fileExt]
    if targetFolder then
        -- Check if target folder exists, create it if not
        local folderPath = targetFolder:gsub("\\", "\\\\")
        local mkdirCommand = 'mkdir "' .. folderPath .. '"'
        os.execute(mkdirCommand)

        -- Attempt to move the file
        local success, err = os.rename(filePath, targetFolder .. "\\" .. fileName)
        if success then
            print("Moved " .. fileName .. " to " .. targetFolder)
        else
            -- Handle error if move fails (e.g., permission issue)
            print("Error moving " .. fileName .. ": " .. err)
        end
    else
        print("No target folder defined for extension " .. (fileExt or "unknown"))
    end
end

-- Loop for going through the download folder
local files = io.popen('dir "'..downloadFolder..'" /b'):lines()
for fileName in files do
    if not fileName:match("^%.") then -- Ignore hidden files starting with "."
        local filePath = downloadFolder .. "\\" .. fileName
        moveFile(filePath)
    end
end

print("Download folder organization completed!")
