local BrainrotService={}
local Config=require(game:GetService("ReplicatedStorage").Modules.Config)
local function makePart(model,name,size,offset,color,shape)
 local p=Instance.new("Part"); p.Name=name; p.Size=size; p.Color=color; p.Anchored=true; p.CanCollide=false; p.Position=offset; if shape then p.Shape=shape end; p.Parent=model; return p
end
local function build(def,mutation)
 local m=Instance.new("Model"); m.Name=def.Name
 local color=(mutation and mutation.Color) or Config.Rarities[def.Rarity].Color
 local body=makePart(m,"Body",Vector3.new(2.5,2.2,1.8),Vector3.new(0,2,0),color,Enum.PartType.Ball); m.PrimaryPart=body
 makePart(m,"Head",Vector3.new(1.7,1.5,1.5),Vector3.new(0,3.3,0),color,Enum.PartType.Ball)
 for _,x in ipairs({-.4,.4}) do local eye=makePart(m,"Eye",Vector3.new(.22,.22,.12),Vector3.new(x,3.5,-.7),Color3.new(1,1,1),Enum.PartType.Ball); makePart(m,"Pupil",Vector3.new(.1,.1,.06),eye.Position+Vector3.new(0,0,-.07),Color3.new(.05,.05,.05),Enum.PartType.Ball) end
 makePart(m,"Silly Mouth",Vector3.new(.45,.12,.08),Vector3.new(0,3,-.79),Color3.fromRGB(70,25,25))
 for _,x in ipairs({-.7,.7}) do makePart(m,"Leg",Vector3.new(.35,1,.35),Vector3.new(x,.45,0),Color3.fromRGB(60,50,70)) end
 if def.Kind=="Pigeon" or def.Kind=="Router" then local hat=makePart(m,"Top Hat",Vector3.new(1.2,.5,1),Vector3.new(0,4.2,0),Color3.fromRGB(28,30,45)); makePart(m,"Hat Crown",Vector3.new(.7,.8,.7),Vector3.new(0,4.8,0),Color3.fromRGB(28,30,45)) end
 if def.Kind=="Banana" then makePart(m,"Banana Peel",Vector3.new(.5,2.6,.5),Vector3.new(0,2.4,0),Color3.fromRGB(255,225,15)) end
 if def.Kind=="Toaster" or def.Kind=="Fridge" or def.Kind=="Printer" or def.Kind=="Microwave" or def.Kind=="Washer" then body.Shape=Enum.PartType.Block; body.Size=Vector3.new(2.5,2.4,2); makePart(m,"Button",Vector3.new(.25,.25,.1),Vector3.new(.6,2.2,-1),Color3.fromRGB(255,70,70),Enum.PartType.Ball) end
 if def.Kind=="Lamp" then makePart(m,"Lampshade",Vector3.new(2.7,1.4,2.7),Vector3.new(0,4,0),color,Enum.PartType.Cylinder) end
 local billboard=Instance.new("BillboardGui"); billboard.Name="BrainrotLabel"; billboard.Size=UDim2.fromOffset(220,68); billboard.StudsOffset=Vector3.new(0,2.4,0); billboard.AlwaysOnTop=true; billboard.Parent=body
 local label=Instance.new("TextLabel"); label.Size=UDim2.fromScale(1,1); label.BackgroundColor3=Color3.fromRGB(25,20,37); label.BackgroundTransparency=.15; label.TextColor3=Color3.new(1,1,1); label.TextStrokeTransparency=.35; label.TextScaled=true; label.Font=Enum.Font.FredokaOne; label.Text=(mutation and mutation.Name.." " or "")..def.Name.."\n"..def.Rarity.." • $"..math.floor(def.Rate*(mutation and mutation.Multiplier or 1)).."/sec"; label.Parent=billboard
 local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,9); corner.Parent=label
 if mutation then local light=Instance.new("PointLight"); light.Color=mutation.Color; light.Brightness=1.5; light.Range=10; light.Parent=body; if mutation.Name=="Shadow" then local particles=Instance.new("ParticleEmitter"); particles.Color=ColorSequence.new(mutation.Color); particles.Rate=4; particles.Lifetime=NumberRange.new(.5,1); particles.Parent=body end end
 return m
end
function BrainrotService.Init(ctx)
 BrainrotService.Context=ctx; BrainrotService.Active={}
 local zones={
  COMMON={Vector3.new(-145,1,-70),Vector3.new(-155,1,-130),Vector3.new(0,1,72)},
  UNCOMMON={Vector3.new(92,1,-72),Vector3.new(155,1,100)},
  RARE={Vector3.new(-95,1,115),Vector3.new(-55,1,155)},
  EPIC={Vector3.new(130,1,155),Vector3.new(155,22,105),Vector3.new(95,24,-100)},
  LEGENDARY={Vector3.new(-145,1,-70),Vector3.new(92,1,-72),Vector3.new(-20,1,155),Vector3.new(130,1,190)},
 }
 local function spawn()
  local def=require(game:GetService("ReplicatedStorage").Modules.Util).WeightedPick(Config.Brainrots,function(entry) local weight=Config.Rarities[entry.Rarity].Weight; local active=ctx.Chaos and ctx.Chaos.Current; if active and (active=="Giant Chicken" or active=="Meteor Shower" or active=="BRAINROT") and (entry.Rarity=="EPIC" or entry.Rarity=="LEGENDARY") then weight*=4 end; return weight end); local roll=math.random(); local mutation=nil
  if roll<.04 then mutation={Name="Shadow",Multiplier=5,Color=Config.Mutations.Shadow.Color} elseif roll<.07 then mutation={Name="Golden",Multiplier=3,Color=Config.Mutations.Golden.Color} elseif roll<.10 then mutation={Name="Neon",Multiplier=2,Color=Config.Mutations.Neon.Color} end
  local points=zones[def.Rarity] or zones.COMMON; local m=build(def,mutation); m:PivotTo(CFrame.new(points[math.random(1,#points)]+Vector3.new(math.random(-12,12),0,math.random(-12,12)))); m.Parent=workspace:WaitForChild("Brainrots")
  local prompt=Instance.new("ProximityPrompt"); prompt.ActionText="Catch"; prompt.ObjectText=def.Name; prompt.KeyboardKeyCode=Enum.KeyCode.E; prompt.HoldDuration=1; prompt.MaxActivationDistance=12; prompt.Parent=m.PrimaryPart
  prompt.Triggered:Connect(function(player) if not player:GetAttribute("Playing") then return end; if (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and (player.Character.HumanoidRootPart.Position-m.PrimaryPart.Position).Magnitude<=14) then if ctx.Base.Add(player,def,mutation,m) then prompt:Destroy(); table.remove(BrainrotService.Active,table.find(BrainrotService.Active,m)) else ctx.Remotes.Announcement:FireClient(player,"Your base is full. Unlock a slot at the shop!") end end end)
  table.insert(BrainrotService.Active,m)
 end
 task.spawn(function() while true do task.wait(7); for i=#BrainrotService.Active,1,-1 do local m=BrainrotService.Active[i]; if not m or not m.Parent then table.remove(BrainrotService.Active,i) end end; if #BrainrotService.Active<12 then spawn() end end end)
end
function BrainrotService.SpawnLegendary()
 local def=Config.Brainrots[11]; local m=build(def,nil); m:PivotTo(CFrame.new(0,3,0)); m.Parent=workspace:WaitForChild("Brainrots")
 local prompt=Instance.new("ProximityPrompt"); prompt.ActionText="Catch"; prompt.ObjectText=def.Name; prompt.HoldDuration=2; prompt.MaxActivationDistance=12; prompt.Parent=m.PrimaryPart
 prompt.Triggered:Connect(function(player) if player:GetAttribute("Playing") and BrainrotService.Context.Base.Add(player,def,nil,m) then prompt:Destroy() end end)
 table.insert(BrainrotService.Active,m)
end
function BrainrotService.Purchase(player,name)
 local price=Config.BrainrotBuyPrices[name]; if not price then return false end
 local def
 for _,entry in ipairs(Config.Brainrots) do if entry.Name==name then def=entry; break end end
 if not def or not BrainrotService.Context.Coin.Spend(player,price) then return false end
 local model=build(def,nil); model:PivotTo(CFrame.new(0,4,0)); model.Parent=workspace:WaitForChild("Brainrots")
 if not BrainrotService.Context.Base.Add(player,def,nil,model) then model:Destroy(); BrainrotService.Context.Coin.Add(player,price); return false end
 return true
end
function BrainrotService.RestoreOwned(player,saved)
 for _,entry in ipairs(saved)do
  if #BrainrotService.Context.Base.GetOwned(player)>=(BrainrotService.Context.Base.SlotCounts[player] or 4) then break end
  local def; for _,candidate in ipairs(Config.Brainrots)do if candidate.Name==entry.Name then def=candidate; break end end
  if def then local mutation=entry.Mutation and Config.Mutations[entry.Mutation] and {Name=entry.Mutation,Multiplier=Config.Mutations[entry.Mutation].Multiplier,Color=Config.Mutations[entry.Mutation].Color} or nil; local model=build(def,mutation); model:PivotTo(CFrame.new(0,4,0)); model.Parent=workspace:WaitForChild("Brainrots"); BrainrotService.Context.Base.Add(player,def,mutation,model) end
 end
end
return BrainrotService
