local ReplicatedStorage=game:GetService("ReplicatedStorage")
local folder=ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
folder.Name="Remotes"; folder.Parent=ReplicatedStorage
local names={"Play","Interact","Buy","EquipPet","Transform","Emote","Event","Announcement","State","Panel","Secret","Minigame","Effect","Rebirth"}
local Remotes={Folder=folder}
for _,name in ipairs(names) do local r=folder:FindFirstChild(name) or Instance.new("RemoteEvent"); r.Name=name; r.Parent=folder; Remotes[name]=r end
return Remotes
