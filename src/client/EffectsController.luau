local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Effects={}
function Effects.Init(player)
 local remotes=ReplicatedStorage:WaitForChild("Remotes"); local camera=workspace.CurrentCamera; local shakeUntil=0
 remotes.Event.OnClientEvent:Connect(function(event)
  if event.Name=="BRAINROT" or event.Name=="Meteor Shower" or event.Name=="Giant Chicken" then shakeUntil=os.clock()+math.min(event.Duration or 2,8) end
  if event.Name=="BRAINROT" then local color=Instance.new("ColorCorrectionEffect"); color.Name="TemporaryBrainrotTint"; color.TintColor=Color3.fromRGB(215,145,255); color.Saturation=.3; color.Parent=game.Lighting; task.delay(event.Duration or 45,function()if color.Parent then color:Destroy()end end) end
 end)
 remotes.Effect.OnClientEvent:Connect(function(effect)
  if type(effect)~="table" then return end
  if effect.Kind=="IncomeTick" then
   local model=effect.Model; local adornee=model and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")); if not adornee or not adornee:IsDescendantOf(workspace) then return end
   local character=player.Character; local root=character and character:FindFirstChild("HumanoidRootPart"); if not root or (root.Position-adornee.Position).Magnitude>20 then return end
   local tag=Instance.new("BillboardGui"); tag.Name="IncomeTick"; tag.Size=UDim2.fromOffset(110,38); tag.StudsOffset=Vector3.new(0,4,0); tag.AlwaysOnTop=true; tag.Adornee=adornee; tag.Parent=player:WaitForChild("PlayerGui")
   local text=Instance.new("TextLabel"); text.Size=UDim2.fromScale(1,1); text.BackgroundTransparency=1; text.Text="+$"..tostring(effect.Amount or 0); text.TextColor3=Color3.fromRGB(115,255,140); text.TextStrokeTransparency=.2; text.TextScaled=true; text.Font=Enum.Font.FredokaOne; text.Parent=tag
   local tween=game:GetService("TweenService"):Create(tag,TweenInfo.new(1.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{StudsOffset=Vector3.new(0,7,0)}); tween:Play(); game:GetService("TweenService"):Create(text,TweenInfo.new(1.5),{TextTransparency=1,TextStrokeTransparency=1}):Play(); task.delay(1.6,function()if tag.Parent then tag:Destroy()end end); return
  end
  if effect.Kind~="Rebirth" then return end
  local target=game:GetService("Players"):GetPlayerByUserId(effect.UserId or 0); local character=target and target.Character; local root=character and character:FindFirstChild("HumanoidRootPart")
  if root then local burst=Instance.new("ParticleEmitter"); burst.Name="RebirthConfettiBurst"; burst.Texture="rbxasset://textures/particles/sparkles_main.dds"; burst.Color=ColorSequence.new(Color3.fromRGB(255,215,70),Color3.fromRGB(255,70,190)); burst.Lifetime=NumberRange.new(.5,1.1); burst.Speed=NumberRange.new(8,16); burst.SpreadAngle=Vector2.new(180,180); burst.Rate=0; burst.Parent=root; burst:Emit(55); task.delay(2,function()if burst.Parent then burst:Destroy()end end) end
  if target==player then task.spawn(function() local soundConfig=require(ReplicatedStorage.Modules.SoundConfig); for _,pitch in ipairs({1,1.25,1.5}) do pcall(function() local sound=Instance.new("Sound"); sound.SoundId=soundConfig.Ping; sound.PlaybackSpeed=pitch; sound.Volume=.7; sound.Parent=game:GetService("SoundService"); sound:Play(); task.delay(2,function()sound:Destroy()end) end); task.wait(.14) end end) end
 end)
 local elapsed=0; RunService.RenderStepped:Connect(function(dt) if os.clock()<shakeUntil and camera then elapsed+=dt; camera.CFrame=camera.CFrame*CFrame.new(math.sin(elapsed*55)*.07,math.cos(elapsed*45)*.05,0) end end)
end
return Effects
