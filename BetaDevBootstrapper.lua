local CurrentDirectory = io.popen("cd"):read()
function string.split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
function downloadFile(url, path)
    os.execute("powershell.exe Invoke-WebRequest " .. url .. " -OutFile " .. path)
end
local file = {}
function exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
       if code == 13 then
          return true
       end
    end
    return ok, err
end
function ExtractFile(path, destination)
    os.execute("powershell.exe ".. CurrentDirectory .. "/7za.exe" .." x \"" .. path .."\" -y -o\"".. destination .."\" > BootstrapperLogs.log")
end
local KrnlFiles = {
    ["Folders"] = {
        os.getenv("APPDATA") .. "/krnl/Scripts",
        os.getenv("APPDATA") .. "/krnl/Recent"
    },
    ["Files"] = {
        [1] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/7za.exe", CurrentDirectory},
        [2] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/7z.NET.dll", CurrentDirectory},
        [3] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/Krnl.7z", os.getenv("APPDATA")},
        [4] = {"https://cdn-108.anonfiles.com/TaA9u4ffy6/ed7af911-1652288188/libcef.dll", os.getenv("APPDATA") .. "/Krnl"},
        [5] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/Monaco.7z", os.getenv("APPDATA") .. "/Krnl"},
        [6] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/swiftshader.7z", os.getenv("APPDATA") .. "/Krnl"},
        [7] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/locales.7z", os.getenv("APPDATA") .. "/Krnl"},
        [8] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/GPUCache.7z", os.getenv("APPDATA") .. "/Krnl"},
        [9] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/Data.7z", os.getenv("APPDATA") .. "/Krnl"},
        [10] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/Community.7z", os.getenv("APPDATA") .. "/Krnl"},
        [11] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/KrnlUI.exe", os.getenv("APPDATA") .. "/Krnl"},
        [12] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/7za.exe", os.getenv("APPDATA") .. "/Krnl"},
        [13] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/7z.NET.dll", os.getenv("APPDATA") .. "/Krnl"},
    },
    ["Extract"] = {
        os.getenv("APPDATA") .. "/Krnl/Monaco.7z",
        os.getenv("APPDATA") .. "/Krnl/swiftshader.7z",
        os.getenv("APPDATA") .. "/Krnl/locales.7z",
        os.getenv("APPDATA") .. "/Krnl/GPUCache.7z",
        os.getenv("APPDATA") .. "/Krnl/Data.7z",
        os.getenv("APPDATA") .. "/Krnl/Community.7z"
    }
}   
-- yes
-- im actually done listing the files in the table
if (exists(os.getenv("APPDATA") .. "/Krnl")) then
    print("[-] Krnl is already installed so removing it")
    os.remove(os.getenv("APPDATA") .. "/Krnl")
end
print("[+] Downloading krnl beta dependencies")
for i, v in pairs(KrnlFiles["Files"]) do
    FileName = string.split(v[1], "/")[#string.split(v[1], "/")]
    if (not exists(v[2] .. "/" .. FileName)) then
        downloadFile(v[1], v[2] .. "/" .. FileName)
        if (i == 3) then
            ExtractFile(os.getenv("APPDATA") .. "/Krnl.7z", os.getenv("APPDATA"))
        end
    end
end
print("[+] Creating krnl beta folders")
for i, v in pairs(KrnlFiles["Folders"]) do
    os.execute("powershell.exe mkdir ".. v .. " > BootstrapperLogs.log")
end
print("[+] Extracting dependencies")
for i,v in pairs(KrnlFiles["Extract"]) do
    ExtractFile(v, os.getenv("APPDATA") .. "/Krnl")
end
print("[+] Done!")
os.execute("powershell.exe New-Item -Type SymbolicLink -Path ".. CurrentDirectory .. "/krnl_beta.exe" .." -Target " .. os.getenv("APPDATA") .. "/Krnl/KrnlUI.exe")
os.execute("powershell.exe " .. os.getenv("APPDATA") .. "/Krnl/KrnlUI.exe")
