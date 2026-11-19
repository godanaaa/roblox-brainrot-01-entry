local Steal={}
local Players=game:GetService("Players")
local function rootOf(player) local c=player.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getPlot(ctx,player) for plot,index in pairs(ctx.Base.ByModel) do if index==player:GetAttribute("PlotIndex") then return plot end end end
local function mutationFor(entry)
 if not entry.Mutation then return nil end
 local config=require(game:GetService("ReplicatedStorage").Modules.Config); local m=config.Mutations[entry.Mutation]
 return m and {Name=entry.Mutation,Multiplier=m.Multiplier,Color=m.Color} or nil
end
local function removeModelWelds(model)
 for _,object in ipairs(model:GetDescendants()) do if object:IsA("WeldConstraint") and object.Name=="StolenModelWeld" then object:Destroy() end end
end
function Steal.Init(ctx)
 Steal.Context=ctx; Steal.Carrying={}; Steal.SavedSpeed={}; Steal.Returning={}
 task.spawn(function() while true do task.wait(.25); for _,owned in pairs(ctx.Base.Owned) do for _,entry in ipairs(owned) do local model=entry.Model; local part=model and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")); if part and model.Parent then Steal.AttachPrompt(model,entry) end end end
  for thief,carry in pairs(Steal.Carrying) do local root=rootOf(thief); local plot=getPlot(ctx,thief); if root and plot and (root.Position-plot:GetPivot().Position).Magnitude<=30 then Steal.DeliverStolenBrainrot(thief) elseif root then ctx.Remotes.State:FireClient(thief,{CarryTimer=math.max(0,30-math.floor(os.clock()-carry.Started))}) end end
 end end)
 Players.PlayerRemoving:Connect(function(player) if Steal.Carrying[player] then Steal.DropStolenBrainrot(player,"leave") end end)
end
function Steal.BlockStealWhenLocked(victim)
 local ctx=Steal.Context; local plot=getPlot(ctx,victim)
 return not plot or plot:GetAttribute("Locked")==true or (ctx.Base.Locks[victim] or 0)>os.clock()
end
function Steal.AttachPrompt(model,entry)
 if model:GetAttribute("StealPrompt") then return end; local part=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart"); if not part then return end
 model:SetAttribute("StealPrompt",true); local prompt=Instance.new("ProximityPrompt"); prompt.Name="StealPrompt"; prompt.ActionText="Steal"; prompt.ObjectText=entry.Name; prompt.KeyboardKeyCode=Enum.KeyCode.E; prompt.HoldDuration=2; prompt.MaxActivationDistance=14; prompt.RequiresLineOfSight=false; prompt.Parent=part
 prompt.Triggered:Connect(function(thief) Steal.StealBrainrotFromBase(thief,model) end)
end
function Steal.StealBrainrotFromBase(thief,model)
 local ctx=Steal.Context; local victim,entry
 for owner,list in pairs(ctx.Base.Owned) do for i,value in ipairs(list) do if value.Model==model then victim=owner; entry=value; entry.Index=i; break end end; if victim then break end end
 local root=rootOf(thief); local part=model and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart"))
 if not victim or victim==thief or not root or not part or (root.Position-part.Position).Magnitude>14 or Steal.Carrying[thief] or Steal.BlockStealWhenLocked(victim) then return false end
 table.remove(ctx.Base.Owned[victim],entry.Index); Steal.CarryStolenBrainrot(thief,victim,entry); ctx.Announce.All(thief.Name.." stole "..entry.Name.." from "..victim.Name.."! Catch the thief!"); return true
end
function Steal.CarryStolenBrainrot(thief,victim,entry)
 local model=entry.Model; local root=rootOf(thief); if not model or not root then return false end
 local prompt=model.PrimaryPart and model.PrimaryPart:FindFirstChild("StealPrompt"); if prompt then prompt:Destroy() end; model:SetAttribute("StealPrompt",false)
 local primary=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart"); model.Parent=workspace; model:PivotTo(root.CFrame*CFrame.new(0,5,0))
 for _,obj in ipairs(model:GetDescendants()) do if obj:IsA("BasePart") then obj.Anchored=false; obj.CanCollide=false; if obj~=primary then local pieceWeld=Instance.new("WeldConstraint"); pieceWeld.Name="StolenModelWeld"; pieceWeld.Part0=primary; pieceWeld.Part1=obj; pieceWeld.Parent=obj end end end
 local weld=Instance.new("WeldConstraint"); weld.Name="StolenCarryWeld"; weld.Part0=root; weld.Part1=primary; weld.Parent=primary
 local hum=thief.Character and thief.Character:FindFirstChildOfClass("Humanoid"); if hum then Steal.SavedSpeed[thief]=hum.WalkSpeed; hum.WalkSpeed=10 end
 local tag=Instance.new("BillboardGui"); tag.Name="StolenTag"; tag.Size=UDim2.fromOffset(150,35); tag.StudsOffset=Vector3.new(0,4,0); tag.AlwaysOnTop=true; tag.Parent=primary
 local text=Instance.new("TextLabel"); text.Size=UDim2.fromScale(1,1); text.BackgroundColor3=Color3.fromRGB(220,35,45); text.Text="STOLEN!"; text.TextColor3=Color3.new(1,1,1); text.TextScaled=true; text.Font=Enum.Font.FredokaOne; text.Parent=tag
 Steal.Carrying[thief]={Victim=victim,Entry=entry,Model=model,Started=os.clock()}
 local thiefRoot=root; local touchConnection
 touchConnection=thiefRoot.Touched:Connect(function(hit) local tagged=Players:GetPlayerFromCharacter(hit.Parent); if tagged==victim and Steal.Carrying[thief] then if touchConnection then touchConnection:Disconnect() end; Steal.TagThief(victim,thief) end end)
 task.delay(30,function() if Steal.Carrying[thief] and Steal.Carrying[thief].Entry==entry then Steal.DropStolenBrainrot(thief,"timer") end end)
 return true
end
function Steal.RestoreCarry(thief)
 local hum=thief.Character and thief.Character:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed=Steal.SavedSpeed[thief] or 16 end; Steal.SavedSpeed[thief]=nil
end
function Steal.DeliverStolenBrainrot(thief)
 local carried=Steal.Carrying[thief]; if not carried then return false end
 local root=rootOf(thief); local plot=getPlot(Steal.Context,thief); if not root or not plot or (root.Position-plot:GetPivot().Position).Magnitude>32 then return false end
 local model=carried.Model; removeModelWelds(model); for _,obj in ipairs(model:GetDescendants()) do if obj:IsA("BasePart") then obj.Anchored=true; obj.CanCollide=false end end
 local tag=model:FindFirstChild("StolenTag",true); if tag then tag:Destroy() end
 local weld=model:FindFirstChild("StolenCarryWeld",true); if weld then weld:Destroy() end
 local def; for _,candidate in ipairs(require(game:GetService("ReplicatedStorage").Modules.Config).Brainrots) do if candidate.Name==carried.Entry.Name then def=candidate end end
 local config=require(game:GetService("ReplicatedStorage").Modules.Config); local mutation=carried.Entry.Mutation and config.Mutations[carried.Entry.Mutation] and {Name=carried.Entry.Mutation,Multiplier=config.Mutations[carried.Entry.Mutation].Multiplier,Color=config.Mutations[carried.Entry.Mutation].Color}
 if not def or not Steal.Context.Base.Add(thief,def,mutation,model) then Steal.DropStolenBrainrot(thief,"full"); return false end
 Steal.Carrying[thief]=nil; Steal.RestoreCarry(thief); Steal.Context.Remotes.State:FireClient(thief,{CarryTimer=0})
 Steal.Context.Announce.All(thief.Name.." got home with the stolen "..carried.Entry.Name.."!"); return true
end
function Steal.DropStolenBrainrot(thief,reason)
 local carry=Steal.Carrying[thief]; if not carry then return end; Steal.Carrying[thief]=nil; Steal.RestoreCarry(thief)
 Steal.Context.Remotes.State:FireClient(thief,{CarryTimer=0})
 local model=carry.Model; if not model or not model.Parent then return end
 local weld=model:FindFirstChild("StolenCarryWeld",true); if weld then weld:Destroy() end; local tag=model:FindFirstChild("StolenTag",true); if tag then tag:Destroy() end
 removeModelWelds(model)
 local part=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart"); if part then for _,obj in ipairs(model:GetDescendants()) do if obj:IsA("BasePart") then obj.Anchored=true end end end
 if reason=="tagged" and carry.Victim.Parent then
  local definition; for _,d in ipairs(require(game:GetService("ReplicatedStorage").Modules.Config).Brainrots) do if d.Name==carry.Entry.Name then definition=d end end
  if definition and Steal.Context.Base.Add(carry.Victim,definition,mutationFor(carry.Entry),model) then Steal.Context.Announce.All(carry.Victim.Name.." tagged the thief and recovered "..carry.Entry.Name.."!"); return end
 end
 if reason=="timer" or reason=="full" then
  local victimPlot=getPlot(Steal.Context,carry.Victim); local target=victimPlot and victimPlot:FindFirstChild("Slots") and victimPlot.Slots:FindFirstChild("Slot1")
  if target and part then model:PivotTo(CFrame.new(target.Position+Vector3.new(0,3,0))); model.Parent=workspace; Steal.Returning[model]=true
   task.delay(10,function() if model.Parent and Steal.Returning[model] then Steal.Returning[model]=nil; local def; for _,d in ipairs(require(game:GetService("ReplicatedStorage").Modules.Config).Brainrots) do if d.Name==carry.Entry.Name then def=d end end; if def then Steal.Context.Base.Add(carry.Victim,def,mutationFor(carry.Entry),model) end end end); return
  end
 end
 if carry.Victim.Parent then local def; for _,d in ipairs(require(game:GetService("ReplicatedStorage").Modules.Config).Brainrots) do if d.Name==carry.Entry.Name then def=d end end; if def then Steal.Context.Base.Add(carry.Victim,def,mutationFor(carry.Entry),model); return end end
 model:Destroy()
end
function Steal.TagThief(victim,thief)
 local carry=Steal.Carrying[thief]; if carry and carry.Victim==victim then Steal.DropStolenBrainrot(thief,"tagged"); return true end; return false
end
return Steal
