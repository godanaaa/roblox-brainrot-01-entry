local Index={}
local Config=require(game:GetService("ReplicatedStorage").Modules.Config)
function Index.Init(ctx)
 Index.Context=ctx; Index.Found={}
 game:GetService("Players").PlayerAdded:Connect(function(player) task.spawn(function() for _=1,600 do local data=ctx.Data.Data[player]; if data then Index.Found[player]=type(data.FoundBrainrots)=="table" and data.FoundBrainrots or {}; return end; task.wait(.1) end; Index.Found[player]={} end) end)
 for _,player in ipairs(game:GetService("Players"):GetPlayers()) do task.spawn(function() for _=1,600 do local data=ctx.Data.Data[player]; if data then Index.Found[player]=type(data.FoundBrainrots)=="table" and data.FoundBrainrots or {}; return end; task.wait(.1) end; Index.Found[player]={} end) end
 game:GetService("Players").PlayerRemoving:Connect(function(player) Index.Found[player]=nil end)
end
function Index.MarkBrainrotFound(player,name)
 if not player or not player.Parent or type(name)~="string" then return false end
 local valid=false; for _,def in ipairs(Config.Brainrots) do if def.Name==name then valid=true; break end end; if not valid then return false end
 local found=Index.Found[player]; if not found then return false end; if found[name] then return false end; found[name]=true
 local count=Index.GetFoundCount(player); Index.Context.Announce.To(player,"NEW BRAINROT! "..count.." found!"); return true
end
function Index.GetFoundCount(player) local n=0; for _,def in ipairs(Config.Brainrots) do if Index.Found[player] and Index.Found[player][def.Name] then n+=1 end end; return n end
function Index.GetFoundTotal() return #Config.Brainrots end
return Index
