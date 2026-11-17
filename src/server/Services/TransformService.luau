local Transform={}
local Players=game:GetService("Players")
local Config=require(game:GetService("ReplicatedStorage").Modules.Config)
function Transform.Init(ctx)
 Transform.Context=ctx; Transform.Tokens={}; Transform.Active={}
 ctx.Remotes.Transform.OnServerEvent:Connect(function(player,name)
  if type(name)~="string" or not table.find(Config.Transformations,name) then return end
  if ctx.Coin.Spend(player,150) then Transform.Apply(player,name,30) end
 end)
 Players.PlayerRemoving:Connect(function(player) Transform.Restore(player) end)
end
function Transform.Restore(player)
 local active=Transform.Active[player]; if not active then return end
 Transform.Active[player]=nil
 for value,original in pairs(active.Scales) do if value.Parent then value.Value=original end end
 if active.Humanoid and active.Humanoid.Parent then active.Humanoid.WalkSpeed=active.WalkSpeed end
 for _,object in ipairs(active.Objects) do if object.Parent then object:Destroy() end end
end
function Transform.Apply(player,name,duration)
 local char=player.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
 Transform.Restore(player)
 local token=(Transform.Tokens[player] or 0)+1; Transform.Tokens[player]=token
 local active={Humanoid=hum,WalkSpeed=hum.WalkSpeed,Scales={},Objects={}}; Transform.Active[player]=active
 local scale=(name=="Giant Baby" or name=="Giant NPC") and 2.2 or name=="Tiny Human" and .55 or nil
 if scale then for _,key in ipairs({"BodyHeightScale","BodyWidthScale","BodyDepthScale","HeadScale"}) do local value=hum:FindFirstChild(key); if value then active.Scales[value]=value.Value; value.Value=active.Scales[value]*scale end end end
 local head=char:FindFirstChild("Head")
 local accessory=Instance.new("Part"); accessory.Name="Temporary "..name; accessory.Size=Vector3.new(1.6,1.2,1.6); accessory.Anchored=false; accessory.CanCollide=false; accessory.Color=({Chicken=Color3.fromRGB(255,220,40),Banana=Color3.fromRGB(255,235,15),Toilet=Color3.fromRGB(245,245,255),Potato=Color3.fromRGB(140,85,45),Frog=Color3.fromRGB(30,210,85),["Traffic Cone"]=Color3.fromRGB(255,90,20)})[name] or Color3.fromRGB(240,120,180); accessory.Parent=char; table.insert(active.Objects,accessory)
 if head then accessory.CFrame=head.CFrame*CFrame.new(0,1.5,0); local weld=Instance.new("WeldConstraint"); weld.Part0=head; weld.Part1=accessory; weld.Parent=accessory end
 local gui=Instance.new("BillboardGui"); gui.Name="TransformationLabel"; gui.Size=UDim2.fromOffset(160,34); gui.StudsOffset=Vector3.new(0,2.5,0); gui.Parent=head; table.insert(active.Objects,gui)
 local text=Instance.new("TextLabel"); text.Size=UDim2.fromScale(1,1); text.BackgroundTransparency=1; text.Text=name.." MODE"; text.TextScaled=true; text.Font=Enum.Font.FredokaOne; text.TextColor3=Color3.new(1,1,1); text.Parent=gui
 task.delay(duration or 30,function() if Transform.Tokens[player]==token then Transform.Restore(player) end end)
end
function Transform.MemeFace(player)
 local head=player.Character and player.Character:FindFirstChild("Head"); if head then local gui=Instance.new("BillboardGui"); gui.Name="Meme Face"; gui.Size=UDim2.fromOffset(90,40); gui.StudsOffset=Vector3.new(0,1,0); gui.Parent=head; local text=Instance.new("TextLabel"); text.Size=UDim2.fromScale(1,1); text.BackgroundTransparency=1; text.Text="ಠ_ಠ"; text.TextScaled=true; text.Parent=gui; task.delay(60,function()gui:Destroy()end) end
end
function Transform.Trail(player)
 local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if root then local a=Instance.new("Attachment",root); local b=Instance.new("Attachment",root); a.Position=Vector3.new(-1,0,0); b.Position=Vector3.new(1,0,0); local trail=Instance.new("Trail"); trail.Attachment0=a; trail.Attachment1=b; trail.Lifetime=.4; trail.Color=ColorSequence.new(Color3.fromRGB(255,80,220),Color3.fromRGB(20,230,255)); trail.Parent=root; task.delay(120,function()trail:Destroy();a:Destroy();b:Destroy()end) end
end
function Transform.Sword(player)
 local tool=Instance.new("Tool"); tool.Name="Banana Sword"; tool.RequiresHandle=true; local handle=Instance.new("Part"); handle.Name="Handle"; handle.Size=Vector3.new(.5,4,.5); handle.Color=Color3.fromRGB(255,220,20); handle.Parent=tool
 tool.Activated:Connect(function()
  local emitter=Instance.new("ParticleEmitter"); emitter.Texture="rbxasset://textures/particles/sparkles_main.dds"; emitter.Color=ColorSequence.new(Color3.fromRGB(255,235,30)); emitter.Lifetime=NumberRange.new(.25,.6); emitter.Speed=NumberRange.new(4,9); emitter.Rate=0; emitter.Parent=handle; emitter:Emit(18); task.delay(1,function()emitter:Destroy()end)
  pcall(function()local sound=Instance.new("Sound"); sound.SoundId=require(game:GetService("ReplicatedStorage").Modules.SoundConfig).Impact; sound.PlaybackSpeed=1.4; sound.Parent=handle; sound:Play(); task.delay(2,function()sound:Destroy()end)end)
 end)
 tool.Parent=player:FindFirstChildOfClass("Backpack")
end
function Transform.ExplodingBackpack(player)
 local function wire(character)
  local root=character:FindFirstChild("HumanoidRootPart"); local hum=character:FindFirstChildOfClass("Humanoid"); if not root or not hum then return end
  local emitter=Instance.new("ParticleEmitter"); emitter.Name="Jump Explosion Burst"; emitter.Texture="rbxasset://textures/particles/sparkles_main.dds"; emitter.Color=ColorSequence.new(Color3.fromRGB(255,90,40),Color3.fromRGB(255,220,40)); emitter.Rate=0; emitter.Lifetime=NumberRange.new(.3,.8); emitter.Speed=NumberRange.new(5,12); emitter.Parent=root
  hum.StateChanged:Connect(function(_,state)if state==Enum.HumanoidStateType.Jumping then emitter:Emit(24)end end)
 end
 if player.Character then wire(player.Character) end
 player.CharacterAdded:Connect(wire)
end
function Transform.ToiletMount(player)
 local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return end
 local seat=Instance.new("Seat"); seat.Name="Toilet Mount"; seat.Size=Vector3.new(3,1,3); seat.Color=Color3.fromRGB(245,245,255); seat.CFrame=root.CFrame*CFrame.new(0,-2,0); seat.Parent=workspace; seat:Sit(char:FindFirstChildOfClass("Humanoid")); task.delay(45,function()seat:Destroy()end)
end
return Transform
