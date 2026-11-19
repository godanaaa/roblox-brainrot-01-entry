local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Remotes=ReplicatedStorage:WaitForChild("Remotes")
local HUD={}
local function round(instance,radius) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,radius or 12); c.Parent=instance end
local function label(parent,name,size,pos,text,fontSize)
 local t=Instance.new("TextLabel"); t.Name=name; t.Size=size; t.Position=pos; t.BackgroundTransparency=1; t.Text=text; t.TextColor3=Color3.new(1,1,1); t.TextScaled=false; t.TextSize=fontSize or 18; t.Font=Enum.Font.FredokaOne; t.TextXAlignment=Enum.TextXAlignment.Left; t.Parent=parent; return t
end
local function coinsText(value) return "🪙 "..tostring(value or 0) end
function HUD.Init(player)
 local gui=Instance.new("ScreenGui"); gui.Name="BrainrotMayhemHUD"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=false; gui.Parent=player:WaitForChild("PlayerGui"); HUD.Gui=gui
 local top=Instance.new("Frame"); top.Name="StatusBar"; top.AnchorPoint=Vector2.new(.5,0); top.Position=UDim2.new(.5,0,0,18); top.Size=UDim2.new(.58,0,0,116); top.BackgroundColor3=Color3.fromRGB(34,23,54); top.BackgroundTransparency=.03; top.Parent=gui; round(top,18)
 local stroke=Instance.new("UIStroke"); stroke.Color=Color3.fromRGB(255,220,72); stroke.Thickness=3; stroke.Parent=top
 HUD.Coins=label(top,"Coins",UDim2.new(1,-32,0,62),UDim2.new(0,18,0,5),"🪙 0",48); HUD.Coins.TextColor3=Color3.fromRGB(255,239,122); HUD.Coins.TextXAlignment=Enum.TextXAlignment.Center
 HUD.Income=label(top,"Income",UDim2.new(.34,0,0,30),UDim2.new(.03,0,0,73),"+$0 / sec",21); HUD.Income.TextXAlignment=Enum.TextXAlignment.Center
 HUD.Rebirth=label(top,"Rebirth",UDim2.new(.39,0,0,30),UDim2.new(.35,0,0,73),"×1.00 ACTIVE",21); HUD.Rebirth.TextXAlignment=Enum.TextXAlignment.Center; HUD.Rebirth.TextColor3=Color3.fromRGB(125,255,205)
 HUD.RebirthCount=label(top,"RebirthCount",UDim2.new(.23,0,0,30),UDim2.new(.75,0,0,73),"REBIRTHS 0",18); HUD.RebirthCount.TextXAlignment=Enum.TextXAlignment.Center
 HUD.Event=label(gui,"EventState",UDim2.new(0,260,0,22),UDim2.new(0,18,0,194),"EVENT: neighborhood behaving",15)
 HUD.Timer=label(gui,"EventTimer",UDim2.new(0,60,0,22),UDim2.new(0,278,0,194),"",15)
 local meter=Instance.new("Frame"); meter.Name="ChaosTrack"; meter.Position=UDim2.new(0,18,0,220); meter.Size=UDim2.new(0,270,0,16); meter.BackgroundColor3=Color3.fromRGB(40,35,50); meter.Parent=gui; round(meter,10)
 HUD.Meter=Instance.new("Frame"); HUD.Meter.Name="Fill"; HUD.Meter.Size=UDim2.fromScale(0,1); HUD.Meter.BackgroundColor3=Color3.fromRGB(255,70,100); HUD.Meter.Parent=meter; round(HUD.Meter,10)
 HUD.Level=label(gui,"ChaosLevel",UDim2.new(0,290,0,22),UDim2.new(0,18,0,239),"NORMAL • chaos meter",15)
 HUD.Index=label(gui,"Index",UDim2.new(0,280,0,24),UDim2.new(0,18,0,263),"INDEX  0/0 found",16)
 HUD.Mission=label(gui,"Mission",UDim2.new(1,-36,0,42),UDim2.new(0,18,1,-76),"MISSION: Survive 10 events  0/10  +500",20); HUD.Mission.BackgroundColor3=Color3.fromRGB(30,104,81); HUD.Mission.BackgroundTransparency=.05; HUD.Mission.TextXAlignment=Enum.TextXAlignment.Center; round(HUD.Mission,12)
 HUD.Lock=label(gui,"Lock",UDim2.new(0,170,0,22),UDim2.new(0,18,0,287),"",14); HUD.Lock.TextColor3=Color3.fromRGB(255,210,95)
 HUD.PlayerCount=label(gui,"PlayerCount",UDim2.new(0,180,0,24),UDim2.new(1,-198,0,218),"Players: 1/20",15); HUD.PlayerCount.TextXAlignment=Enum.TextXAlignment.Right
 HUD.Objective=label(gui,"Objective",UDim2.new(0,390,0,28),UDim2.new(0,18,1,-30),"Catch a brainrot and bring it home!",17)
 HUD.EventBanner=Instance.new("TextLabel"); HUD.EventBanner.Name="EventBanner"; HUD.EventBanner.AnchorPoint=Vector2.new(.5,0); HUD.EventBanner.Position=UDim2.new(.5,0,0,142); HUD.EventBanner.Size=UDim2.new(.5,0,0,42); HUD.EventBanner.BackgroundColor3=Color3.fromRGB(247,72,120); HUD.EventBanner.TextColor3=Color3.new(1,1,1); HUD.EventBanner.TextSize=24; HUD.EventBanner.Font=Enum.Font.FredokaOne; HUD.EventBanner.Visible=false; HUD.EventBanner.Parent=gui; round(HUD.EventBanner,13)
 HUD.Toast=Instance.new("TextLabel"); HUD.Toast.Name="Toast"; HUD.Toast.AnchorPoint=Vector2.new(.5,0); HUD.Toast.Position=UDim2.new(.5,0,0,190); HUD.Toast.Size=UDim2.new(.5,0,0,40); HUD.Toast.BackgroundColor3=Color3.fromRGB(45,32,58); HUD.Toast.TextColor3=Color3.new(1,1,1); HUD.Toast.TextScaled=true; HUD.Toast.Font=Enum.Font.FredokaOne; HUD.Toast.Visible=false; HUD.Toast.Parent=gui; round(HUD.Toast,12)
 local menu=Instance.new("TextButton"); menu.Name="OpenMenu"; menu.Position=UDim2.new(1,-145,0,18); menu.Size=UDim2.fromOffset(125,42); menu.Text="☰ MENU"; menu.TextScaled=true; menu.Font=Enum.Font.FredokaOne; menu.TextColor3=Color3.new(1,1,1); menu.BackgroundColor3=Color3.fromRGB(125,60,190); menu.Parent=gui; round(menu,12); menu.Activated:Connect(function() if HUD.OpenMenu then HUD.OpenMenu() end end)
 HUD.LeaderboardLabel=Instance.new("TextLabel"); HUD.LeaderboardLabel.Name="TopPlayers"; HUD.LeaderboardLabel.Position=UDim2.new(1,-205,0,68); HUD.LeaderboardLabel.Size=UDim2.fromOffset(185,112); HUD.LeaderboardLabel.BackgroundColor3=Color3.fromRGB(28,20,45); HUD.LeaderboardLabel.BackgroundTransparency=.15; HUD.LeaderboardLabel.TextColor3=Color3.new(1,1,1); HUD.LeaderboardLabel.TextSize=15; HUD.LeaderboardLabel.Font=Enum.Font.FredokaOne; HUD.LeaderboardLabel.TextYAlignment=Enum.TextYAlignment.Top; HUD.LeaderboardLabel.Text="TOP MEME EARNERS\nLoading…"; HUD.LeaderboardLabel.Parent=gui; round(HUD.LeaderboardLabel,12)
 local interact=Instance.new("TextButton"); interact.Name="TouchInteract"; interact.AnchorPoint=Vector2.new(1,1); interact.Position=UDim2.new(1,-24,1,-110); interact.Size=UDim2.fromOffset(100,58); interact.Text="HOLD E\nCATCH"; interact.TextScaled=true; interact.Font=Enum.Font.FredokaOne; interact.TextColor3=Color3.new(1,1,1); interact.BackgroundColor3=Color3.fromRGB(35,170,120); interact.Parent=gui; round(interact,18); HUD.InteractButton=interact
 local emote=Instance.new("TextButton"); emote.Name="TouchEmote"; emote.AnchorPoint=Vector2.new(1,1); emote.Position=UDim2.new(1,-24,1,-178); emote.Size=UDim2.fromOffset(100,50); emote.Text="EMOTE G"; emote.TextScaled=true; emote.Font=Enum.Font.FredokaOne; emote.TextColor3=Color3.new(1,1,1); emote.BackgroundColor3=Color3.fromRGB(55,105,205); emote.Parent=gui; round(emote,16); HUD.EmoteButton=emote
 HUD.SetChaos(0)
 Remotes.State.OnClientEvent:Connect(function(state)
  if type(state)~="table" then return end
  if state.Coins~=nil then HUD.Coins.Text=coinsText(state.Coins) end
  if state.IncomeRate~=nil then HUD.Income.Text="+$"..tostring(state.IncomeRate).." / sec" end
  if state.LockSeconds~=nil then HUD.Lock.Text=state.LockSeconds>0 and ("LOCKED "..tostring(state.LockSeconds).."s") or "" end
  if state.Upgrades then HUD.UpgradeLevel=state.Upgrades["Income Boost"] or 0 end
  if state.IndexTotal then HUD.Index.Text="INDEX  "..tostring(state.IndexFound or 0).."/"..tostring(state.IndexTotal).." found" end
  if state.RebirthMultiplier then HUD.ActiveMultiplier=state.RebirthMultiplier; HUD.Rebirths=state.Rebirths or HUD.Rebirths or 0; HUD.Rebirth.Text="×"..string.format("%.2f",HUD.ActiveMultiplier).." ACTIVE"; HUD.RebirthCount.Text="REBIRTHS "..tostring(HUD.Rebirths) end
  if state.Daily and state.Progress then HUD.Daily=state.Daily; HUD.DailyProgress=state.Progress; local c=state.Daily[1]; if c then HUD.Mission.Text="MISSION: "..c.Name.."  "..tostring(state.Progress[c.Key] or 0).."/"..tostring(c.Goal).."  +"..tostring(c.Reward) end end
  if state.CarryTimer~=nil then HUD.Objective.Text=state.CarryTimer>0 and ("STOLEN! Deliver home in "..state.CarryTimer.."s") or "Catch a brainrot and bring it home!" end
  if state.Event then HUD.Event.Text="EVENT: "..state.Event end
  if state.Players then HUD.PlayerCount.Text="Players: "..state.Players.."/20" end
  if state.Chaos then HUD.SetChaos(state.Chaos) end
  if state.Owned and #state.Owned>0 then HUD.Objective.Text="Expand your base, lock it, and survive the next event!" end
  if state.Leaderboard then local rows={"TOP MEME EARNERS"}; for i,row in ipairs(state.Leaderboard) do table.insert(rows,i..". "..row.Name.."  "..row.Coins) end; HUD.LeaderboardLabel.Text=table.concat(rows,"\n") end
  if state.Playing~=nil then HUD.Playing=state.Playing end
 end)
 Remotes.Event.OnClientEvent:Connect(function(event)
  if not event.Name then return end
  HUD.Event.Text="EVENT: "..event.Name
  local untilAt=os.clock()+(event.Duration or 0); local isRush=event.Name=="MEME RUSH x2"
  local effects={ ["MEME RUSH x2"]="INCOME ×2",["Brainrot Tsunami"]="DODGE THE WAVE",["Banana Rain"]="BONUS BANANAS",["Floor Is Lava"]="KEEP MOVING",["Low Gravity"]="JUMP HIGHER",["Meteor Shower"]="DODGE METEORS",["NPC Invasion"]="DEFEND YOUR BASE",["Giant Chicken"]="GIANT CHICKEN ATTACK",["Giant Toilet"]="GIANT TOILET ATTACK",["BRAINROT"]="ABSOLUTE MAYHEM",["Big Head"]="GIANT HEADS",["Tiny People"]="TINY PLAYERS",["Speed Demon"]="TURBO SPEED",["Dance Party"]="EVERYONE DANCE",["Random Teleport"]="WARP AROUND",["Yeet Mode"]="GET LAUNCHED",["Reverse Controls"]="CONTROLS REVERSED",["Giant Player"]="ONE PLAYER GOES GIANT",["Chicken Attack"]="CHICKENS INVADE",["Spinning World"]="THE MAP SPINS",["One Player Is Sus"]="FIND THE IMPOSTOR"}
  HUD.EventBanner.BackgroundColor3=isRush and Color3.fromRGB(255,77,101) or Color3.fromRGB(126,70,218); HUD.EventBanner.Visible=true
  if isRush then HUD.Rebirth.Text="×2.00 ACTIVE" end
  task.spawn(function() while os.clock()<untilAt do local left=math.ceil(untilAt-os.clock()); HUD.Timer.Text=left.."s"; HUD.EventBanner.Text=string.upper(event.Name).."!  "..(effects[event.Name] or "MAYHEM EFFECT").."  —  "..left.."s"; task.wait(.25) end; HUD.Timer.Text=""; HUD.EventBanner.Visible=false; if isRush and HUD.ActiveMultiplier then HUD.Rebirth.Text="×"..string.format("%.2f",HUD.ActiveMultiplier).." ACTIVE" end end)
 end)
 Remotes.Announcement.OnClientEvent:Connect(function(text) HUD.ShowToast(text) end)
end
function HUD.ShowBanner(text,duration) HUD.EventBanner.Text=text; HUD.EventBanner.Visible=true; task.delay(math.max(2,math.min(duration or 4,8)),function() HUD.EventBanner.Visible=false end) end
function HUD.ShowToast(text) HUD.Toast.Text=text; HUD.Toast.Visible=true; task.delay(3.5,function()HUD.Toast.Visible=false end) end
function HUD.SetChaos(value) if not HUD.Meter then return end; local n=math.clamp(tonumber(value) or 0,0,100); HUD.Meter.Size=UDim2.fromScale(n/100,1); local names={{20,"NORMAL"},{45,"CHAOTIC"},{70,"INSANE"},{90,"BRAINROT"},{101,"ABSOLUTE DISASTER"}}; local title="NORMAL"; for _,entry in ipairs(names) do if n<entry[1] then title=entry[2]; break end end; HUD.Level.Text=title.." • chaos "..n.."%" end
return HUD
