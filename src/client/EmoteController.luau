local CAS=game:GetService("ContextActionService")
local TweenService=game:GetService("TweenService")
local Emotes={}
local names={"Spin","Victory Dance","Dramatic Pointing","Fake Crying","Falling Over","Head Shake","Chicken Dance","Moonwalk","NPC Walk","Floor Flop"}
function Emotes.Init(player,hud)
 local busy=false
 local function play()
  if busy then return end; local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid"); if not root or not hum then return end; busy=true
  local choice=names[math.random(1,#names)]; hud.ShowToast("EMOTE: "..choice)
  if choice=="Falling Over" or choice=="Floor Flop" then hum.Sit=true; task.delay(2,function()if hum.Parent then hum.Sit=false end; busy=false end)
  elseif choice=="Victory Dance" or choice=="Chicken Dance" then hum.Jump=true; local tw=TweenService:Create(root,TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,5,true),{CFrame=root.CFrame*CFrame.Angles(0,math.pi/2,0)}); tw:Play(); tw.Completed:Wait(); busy=false
  elseif choice=="Spin" then local tw=TweenService:Create(root,TweenInfo.new(1,Enum.EasingStyle.Linear),{CFrame=root.CFrame*CFrame.Angles(0,math.pi*4,0)}); tw:Play(); tw.Completed:Wait(); busy=false
  else hum.Jump=true; task.delay(1.2,function()busy=false end) end
 end
 CAS:BindAction("BrainrotEmote",function(_,state)if state==Enum.UserInputState.Begin then play()end; return Enum.ContextActionResult.Sink end,false,Enum.KeyCode.G)
 hud.EmoteButton.Activated:Connect(play)
end
return Emotes
