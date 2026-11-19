local Rebirth={}
local Players=game:GetService("Players")
local Costs={25000,100000,500000,2000000}
local Titles={"Chaos Survivor","Brainrot Baron","Mayhem Royalty","Lord of the Loo"}
function Rebirth.Init(ctx)
 Rebirth.Context=ctx; Rebirth.Counts={}
 for _,player in ipairs(Players:GetPlayers()) do task.spawn(function() for _=1,600 do if ctx.Data.Data[player] then Rebirth.Load(player); return end; task.wait(.1) end; Rebirth.Load(player) end) end
 Players.PlayerAdded:Connect(function(player) task.spawn(function() for _=1,600 do local data=ctx.Data and ctx.Data.Data[player]; if data then Rebirth.Counts[player]=math.max(0,math.floor(data.Rebirths or 0)); player:SetAttribute("Rebirths",Rebirth.Counts[player]); player:SetAttribute("RebirthTitle",data.RebirthTitle or ""); return end; task.wait(.1) end end) end)
 Players.PlayerRemoving:Connect(function(player) Rebirth.Counts[player]=nil end)
 ctx.Remotes.Rebirth.OnServerEvent:Connect(function(player) Rebirth.RequestRebirth(player) end)
end
function Rebirth.Load(player) local data=Rebirth.Context and Rebirth.Context.Data and Rebirth.Context.Data.Data[player]; Rebirth.Counts[player]=math.max(0,math.floor(data and data.Rebirths or 0)); player:SetAttribute("Rebirths",Rebirth.Counts[player]); player:SetAttribute("RebirthTitle",data and data.RebirthTitle or "") end
function Rebirth.GetRebirthCost(player) local count=Rebirth.Counts[player] or player:GetAttribute("Rebirths") or 0; return Costs[count+1] end
function Rebirth.GetIncomeMultiplier(player) return 1+.25*(Rebirth.Counts[player] or player:GetAttribute("Rebirths") or 0) end
function Rebirth.ApplyRebirthMultiplier(player,amount) return math.floor(amount*Rebirth.GetIncomeMultiplier(player)) end
function Rebirth.RequestRebirth(player)
 local ctx=Rebirth.Context; local count=Rebirth.Counts[player] or 0; local cost=Rebirth.GetRebirthCost(player)
 if not cost or ctx.Coin.GetLifetime(player)<cost then ctx.Announce.To(player,"Lifetime earnings needed: "..tostring(cost or "max rebirth reached").." Meme Coins."); return false end
 local title=Titles[count+1]; Rebirth.Counts[player]=count+1; player:SetAttribute("Rebirths",count+1); player:SetAttribute("RebirthTitle",title); ctx.Coin.Set(player,0)
 if ctx.Base then ctx.Base.Clear(player) end
 local data=ctx.Data.Data[player]; if data then data.Rebirths=count+1; data.RebirthTitle=title; data.Titles=data.Titles or {}; data.Titles[title]=true; data.Coins=0; data.Brainrots={} end
 ctx.Announce.All(player.Name.." rebirthed as "..title.."! Income multiplier: x"..string.format("%.2f",Rebirth.GetIncomeMultiplier(player)))
 ctx.Remotes.Effect:FireAllClients({Kind="Rebirth",UserId=player.UserId})
 ctx.Remotes.State:FireClient(player,ctx.Snapshot(player)); return true
end
return Rebirth
