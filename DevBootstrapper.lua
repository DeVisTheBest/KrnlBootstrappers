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
local KrnlFiles = {
    ["Folders"] = {
        "krnl",
        "krnl/bin",
        "krnl/scripts",
        "krnl/workspace",
        "krnl/autoexec"
    },
    ["Files"] = {
        [1] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/7z.NET.dll", "krnl"},
        [2] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/7za.exe", "krnl"},
        [3] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/Bunifu_UI_v1.5.3.dll", "krnl"},
        [4] = {"https://github.com/DeVisTheBest/KrnlFiles/blob/main/KrnlAPI.dll", "krnl"},
        [5] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/Monaco.zip", "krnl/bin"},
        [6] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/ScintillaNET.dll", "krnl"},
        [7] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/injector.dll", "krnl"},
        [8] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/krnl.dll", "krnl"},
        [9] = {"https://github.com/DeVisTheBest/KrnlFiles/raw/main/krnlss.exe", "krnl"}
    }
}
print("[+] Creating krnl folders")
if (exists("./krnl/")) then 
    print("[-] Krnl seems to be already installed... so uninstalling it")
    os.remove("./krnl") 
end
for i, v in pairs(KrnlFiles["Folders"]) do
    if (not exists("./"..v.."/")) then
        os.execute("powershell.exe mkdir \"".. io.popen("cd"):read() .. "/" .. v .. "\" > BootstrapperLogs.log")
        if i == 1 then 
            os.execute("powershell.exe explorer.exe ".. io.popen("cd"):read() .. "/" .. v"")
        end
    end
end
print("[+] Downloading krnl dependencies")
for i, v in pairs(KrnlFiles["Files"]) do
    FileName = string.split(v[1], "/")[#string.split(v[1], "/")]
    if (not exists(io.popen("cd"):read() .. "/" .. v[2] .. "/" .. FileName)) then
        downloadFile(v[1], io.popen("cd"):read() .. "/" ..  v[2] .. "/" .. FileName)
    end
end
print("[+] Downloading source files")
downloadFile("https://github.com/DeVisTheBest/KrnlFiles/raw/main/src2.7z", "./krnl/bin/src.7z")
print("[+] Extracting source files")
os.execute("powershell.exe ./krnl/7za.exe x \"" ..io.popen("cd"):read() .. "/krnl/bin/src.7z".."\" -y -o\"".. io.popen("cd"):read() .. "/krnl/bin" .."\" > BootstrapperLogs.log")
print("[+] Extracting monaco")
os.execute("powershell.exe ./krnl/7za.exe x \"".. io.popen("cd"):read() .. "/krnl/bin/Monaco.zip" .."\" -y -o\"".. io.popen("cd"):read() .. "/krnl/bin" .."\" > BootstrapperLogs.log")
print("[+] Downloading libcef (This may take a while depending on your internet speed since libcef is 100mb)")
downloadFile("https://cdn-127.anonfiles.com/r5m5u8f4y5/f044883a-1652287372/libcef.dll", "./krnl/bin/src/libcef.dll")