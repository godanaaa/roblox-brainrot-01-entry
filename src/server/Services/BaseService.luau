local BaseService={}
function BaseService.Init(ctx) BaseService.Context=ctx; BaseService.ByPlayer={}; BaseService.ByModel={}; BaseService.Owned={}; BaseService.Locks={}; BaseService.SlotCounts={};
 local plots=workspace:WaitForChild("BrainrotMap"):WaitForChild("Plots"):GetChildren(); table.sort(plots,function(a,b)return a.Name<b.Name end)
 for i,plot in ipairs(plots) do BaseService.ByModel[plot]=i end
 local function assign(p)
  p:SetAttribute("BaseReady",false)
  for _,plot in ipairs(plots) do
   local i=BaseService.ByModel[plot]
   if not BaseService.ByPlayer[i] then
    BaseService.ByPlayer[i]=p; BaseService.Owned[p]={}; BaseService.SlotCounts[p]=4
    plot:SetAttribute("OwnerUserId",p.UserId); plot:SetAttribute("OwnerName",p.Name); p:SetAttribute("PlotIndex",i)
    task.spawn(function()
     for _=1,600 do local data=ctx.Data and ctx.Data.Data[p]; if data then BaseService.SlotCounts[p]=math.clamp(tonumber(data.BaseSlots) or 4,4,8); while not ctx.Brainrot do task.wait(.1) end; ctx.Brainrot.RestoreOwned(p,data.Brainrots or {}); p:SetAttribute("BaseReady",true); return end; task.wait(.1) end
    end)
    return
   end
  end
  p:SetAttribute("BaseReady",true)
 end
 game:GetService("Players").PlayerAdded:Connect(assign)
 for _,p in ipairs(game:GetService("Players"):GetPlayers()) do assign(p) end
 game:GetService("Players").PlayerRemoving:Connect(function(p) local i=BaseService.ByPlayer and table.find(BaseService.ByPlayer,p); if i then BaseService.ByPlayer[i]=nil end; BaseService.Owned[p]=nil; BaseService.SlotCounts[p]=nil; BaseService.Locks[p]=nil; if BaseService.LockUntil then BaseService.LockUntil[p]=nil end end)
 task.spawn(function() while true do task.wait(1); for p,rots in pairs(BaseService.Owned) do if p.Parent then local rate=0; for _,r in ipairs(rots) do rate+=r.Rate end; if ctx.Rebirth then rate=ctx.Rebirth.ApplyRebirthMultiplier(p,rate) end; if ctx.Upgrade then rate*=ctx.Upgrade.GetIncomeBoost(p) end; if ctx.Chaos and ctx.Chaos.DoubleIncomeUntil and ctx.Chaos.DoubleIncomeUntil>os.clock() then rate*=2 end; if p:GetAttribute("SusCoins") then rate*=2 end; rate=math.floor(rate); ctx.Remotes.State:FireClient(p,{IncomeRate=rate,LockSeconds=BaseService.GetLockSeconds(p),Upgrades=ctx.Upgrade and ctx.Upgrade.GetUpgrades(p) or {}}); if rate>0 then ctx.Coin:Add(p,rate); for _,entry in ipairs(rots) do if entry.Model and entry.Model.Parent then ctx.Remotes.Effect:FireClient(p,{Kind="IncomeTick",Model=entry.Model,Amount=entry.Rate>0 and math.max(1,math.floor(entry.Rate*(ctx.Rebirth and ctx.Rebirth.GetIncomeMultiplier(p) or 1)*(ctx.Upgrade and ctx.Upgrade.GetIncomeBoost(p) or 1)*((ctx.Chaos and ctx.Chaos.DoubleIncomeUntil or 0)>os.clock() and 2 or 1)*(p:GetAttribute("SusCoins") and 2 or 1))) or 0}) end end end end end end end)
end
function BaseService.Add(player,definition,mutation,model)
 local owned=BaseService.Owned[player]; if not owned then return false end
 if #owned>=BaseService.SlotCounts[player] then return false end
 local slot=#owned+1; table.insert(owned,{Name=definition.Name,Rate=math.floor(definition.Rate*(mutation and mutation.Multiplier or 1)),Mutation=mutation and mutation.Name or nil,Model=model})
 local plotIndex=player:GetAttribute("PlotIndex"); local plot
 for m,index in pairs(BaseService.ByModel) do if index==plotIndex then plot=m end end
 if plot then local pad=plot.Slots:FindFirstChild("Slot"..slot); if pad and model then local target=pad.Position+Vector3.new(0,3,0); local root=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart"); if root then root.Anchored=true; local start=root.Position; for t=1,10 do if not root.Parent then break end; root.Position=start:Lerp(target,t/10); task.wait(.04) end; model:PivotTo(CFrame.new(target)) end; model.Parent=plot end end
 if BaseService.Context.Index then BaseService.Context.Index.MarkBrainrotFound(player,definition.Name) end; BaseService.Context.Remotes.Announcement:FireClient(player,definition.Name.." joined your base!  +"..owned[#owned].Rate.."/sec")
 return true
end
function BaseService.Lock(player) local now=os.clock(); if BaseService.LockUntil and (BaseService.LockUntil[player] or 0)>now then return false end; if not BaseService.Context.Coin.Spend(player,100) then return false end; local duration=60+(BaseService.Context.Upgrade and BaseService.Context.Upgrade.GetLockBonus(player) or 0); BaseService.LockUntil=BaseService.LockUntil or {}; BaseService.LockUntil[player]=now+150; BaseService.Locks[player]=now+duration; local plotIndex=player:GetAttribute("PlotIndex"); for m,index in pairs(BaseService.ByModel) do if index==plotIndex then m:SetAttribute("Locked",true); task.delay(duration,function() if m.Parent and BaseService.Locks[player] and BaseService.Locks[player]<=os.clock()+0.1 then m:SetAttribute("Locked",false) end; if BaseService.Locks[player] and BaseService.Locks[player]<=os.clock()+0.1 then BaseService.Locks[player]=nil end end) end end; return true end
function BaseService.Expand(player) local count=BaseService.SlotCounts[player] or 4; local prices={[4]=500,[5]=1500,[6]=4000}; if count>=8 or not BaseService.Context.Coin.Spend(player,prices[count] or 4000) then return false end; BaseService.SlotCounts[player]=count+1; return true end
function BaseService.ScareUnlocked()
 for player,owned in pairs(BaseService.Owned) do
  if #owned>0 and not BaseService.Locks[player] then
   local lost=table.remove(owned,#owned)
   if lost.Model and lost.Model.Parent then lost.Model:Destroy() end
   BaseService.Context.Announce.To(player,"A brainrot got scared off! Lock your base for 100 coins.")
  end
 end
end
function BaseService.GetIncomeRate(player) local rate=0; for _,entry in ipairs(BaseService.Owned[player] or {}) do rate+=entry.Rate end; if BaseService.Context.Rebirth then rate=BaseService.Context.Rebirth.ApplyRebirthMultiplier(player,rate) end; if BaseService.Context.Upgrade then rate*=BaseService.Context.Upgrade.GetIncomeBoost(player) end; if BaseService.Context.Chaos and BaseService.Context.Chaos.DoubleIncomeUntil and BaseService.Context.Chaos.DoubleIncomeUntil>os.clock() then rate*=2 end; if player:GetAttribute("SusCoins") then rate*=2 end; return math.floor(rate) end
function BaseService.GetLockSeconds(player) return math.max(0,math.ceil((BaseService.Locks[player] or 0)-os.clock())) end
function BaseService.GetOwned(player) return BaseService.Owned[player] or {} end
function BaseService.Clear(player) for _,entry in ipairs(BaseService.Owned[player] or {}) do if entry.Model and entry.Model.Parent then entry.Model:Destroy() end end; BaseService.Owned[player]={} end
return BaseService
