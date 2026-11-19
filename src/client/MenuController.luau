local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local Remotes=ReplicatedStorage:WaitForChild("Remotes")
local Config=require(ReplicatedStorage.Modules.Config)
local Menu={}
local function round(obj) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,14); c.Parent=obj end
local function compactCoins(value) local n=tonumber(value); if not n then return "MAX" end; if n>=1000000 then return string.format("%.1fM",n/1000000) elseif n>=1000 then return string.format("%.0fK",n/1000) end; return tostring(n) end
function Menu.Init(player,hud)
 Menu.Player=player; Menu.HUD=hud
 local overlay=Instance.new("Frame"); overlay.Name="MenuOverlay"; overlay.Size=UDim2.fromScale(1,1); overlay.BackgroundColor3=Color3.fromRGB(15,11,30); overlay.BackgroundTransparency=.12; overlay.Visible=false; overlay.Parent=hud.Gui; Menu.Overlay=overlay
 local card=Instance.new("Frame"); card.AnchorPoint=Vector2.new(.5,.5); card.Position=UDim2.fromScale(.5,.5); card.Size=UDim2.new(.82,0,.78,0); card.BackgroundColor3=Color3.fromRGB(34,23,55); card.Parent=overlay; card.Size=UDim2.new(.76,0,.7,0); round(card)
 local title=Instance.new("TextLabel"); title.Name="Title"; title.Position=UDim2.new(.05,0,.03,0); title.Size=UDim2.new(.9,0,.18,0); title.BackgroundTransparency=1; title.Text="BRAINROT\nMAYHEM"; title.TextColor3=Color3.fromRGB(255,230,80); title.Font=Enum.Font.FredokaOne; title.TextScaled=true; title.Parent=card
 local subtitle=Instance.new("TextLabel"); subtitle.Position=UDim2.new(.1,0,.23,0); subtitle.Size=UDim2.new(.8,0,.07,0); subtitle.BackgroundTransparency=1; subtitle.Text="Catch weirdos. Build your base. Survive the chaos."; subtitle.TextColor3=Color3.new(1,1,1); subtitle.TextScaled=true; subtitle.Font=Enum.Font.GothamBold; subtitle.Parent=card
 local content=Instance.new("Frame"); content.Name="PanelContent"; content.Position=UDim2.new(.27,0,.34,0); content.Size=UDim2.new(.68,0,.6,0); content.BackgroundColor3=Color3.fromRGB(48,36,69); content.Parent=card; round(content); Menu.Content=content
 local nav=Instance.new("ScrollingFrame"); nav.Position=UDim2.new(.04,0,.34,0); nav.Size=UDim2.new(.2,0,.6,0); nav.BackgroundTransparency=1; nav.BorderSizePixel=0; nav.ScrollBarThickness=5; nav.CanvasSize=UDim2.new(0,0,0,0); nav.Parent=card
 local list=Instance.new("UIListLayout"); list.Padding=UDim.new(0,7); list.Parent=nav; list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() nav.CanvasSize=UDim2.new(0,0,0,list.AbsoluteContentSize.Y+4) end)
 local function button(name,callback)
  local b=Instance.new("TextButton"); b.Name=name; b.Size=UDim2.new(1,0,0,38); b.BackgroundColor3=Color3.fromRGB(128,65,190); b.Text=name; b.TextColor3=Color3.new(1,1,1); b.TextScaled=true; b.Font=Enum.Font.FredokaOne; b.Parent=nav; round(b); b.Activated:Connect(callback); return b
 end
 local function clear() for _,o in ipairs(content:GetChildren())do if not o:IsA("UICorner") then o:Destroy()end end end
 local function info(text) clear(); local t=Instance.new("TextLabel"); t.Size=UDim2.new(1,-24,1,-20); t.Position=UDim2.new(0,12,0,10); t.BackgroundTransparency=1; t.Text=text; t.TextColor3=Color3.new(1,1,1); t.TextWrapped=true; t.TextYAlignment=Enum.TextYAlignment.Top; t.TextXAlignment=Enum.TextXAlignment.Left; t.TextSize=20; t.Font=Enum.Font.GothamBold; t.Parent=content end
 local function play() Remotes.Play:FireServer(); if hud.OpenMenu then hud.OpenMenu() end; hud.ShowToast("Welcome to the neighborhood. Go catch something weird!") end
 local function shop()
  clear()
  local sc=Instance.new("ScrollingFrame"); sc.Name="ShopItems"; sc.Size=UDim2.fromScale(1,1); sc.BackgroundTransparency=1; sc.BorderSizePixel=0; sc.ScrollBarThickness=8; sc.CanvasSize=UDim2.new(0,0,0,0); sc.Parent=content
  local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,5); layout.Parent=sc
  for _,def in ipairs(Config.Brainrots) do
   local item="Brainrot:"..def.Name; local price=Config.BrainrotBuyPrices[def.Name]
   local b=Instance.new("TextButton"); b.Name="BuyBrainrot"; b.Size=UDim2.new(1,-12,0,42); b.BackgroundColor3=Config.Rarities[def.Rarity].Color; b.BackgroundTransparency=1; b.TextColor3=Color3.fromRGB(25,20,35); b.TextTransparency=1; b.TextScaled=true; b.Font=Enum.Font.FredokaOne; b.Text=def.Name.."  •  "..def.Rarity.."  •  $"..tostring(price); b.Parent=sc; round(b)
   TweenService:Create(b,TweenInfo.new(.18,Enum.EasingStyle.Quad),{BackgroundTransparency=0,TextTransparency=0}):Play()
   b.Activated:Connect(function() Remotes.Buy:FireServer(item); task.delay(.15,function() Remotes.State:FireServer("Request") end) end)
  end
  for _,item in ipairs({"Base Lock","Next Slot","Giant Head","Banana Sword","Chicken Pet","Toilet Mount","Meme Face","Exploding Backpack","Funny Trail","Silly Animations","Transformation"}) do
   local b=Instance.new("TextButton"); b.Size=UDim2.new(1,-12,0,38); b.BackgroundColor3=Color3.fromRGB(100,57,150); b.TextColor3=Color3.new(1,1,1); b.TextScaled=true; b.Font=Enum.Font.FredokaOne; b.Text=item.."  •  BUY"; b.Parent=sc; round(b); b.Activated:Connect(function() Remotes.Buy:FireServer(item); Remotes.State:FireServer("Request") end)
  end
  task.defer(function() sc.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+8) end)
 end
 local function pets() local owned=(Menu.State and Menu.State.OwnedPets) or {}; info("PETS\n\nOwned companions follow you around. Equip one here or unequip your current buddy."); for i,name in ipairs({"Chicken","Banana","Potato","Toilet","Mini NPC","Giant Hamster","Dancing Frog","Floating Head"})do local isOwned=owned[name]; local col=(i-1)%2; local row=math.floor((i-1)/2); local b=Instance.new("TextButton"); b.Position=UDim2.new(.04+col*.48,0,.39+row*.105,0); b.Size=UDim2.new(.44,0,.085,0); b.Text=isOwned and "Equip "..name or "Buy "..name; b.TextScaled=true; b.Font=Enum.Font.FredokaOne; b.BackgroundColor3=Color3.fromRGB(80,120,170); b.TextColor3=Color3.new(1,1,1); b.Parent=content; round(b); b.Activated:Connect(function()if isOwned then Remotes.EquipPet:FireServer(name)else Remotes.Buy:FireServer("Pet:"..name)end end)end; local off=Instance.new("TextButton"); off.Position=UDim2.new(.3,0,.84,0); off.Size=UDim2.new(.4,0,.08,0); off.Text="Unequip pet"; off.TextScaled=true; off.Font=Enum.Font.FredokaOne; off.BackgroundColor3=Color3.fromRGB(90,75,110); off.TextColor3=Color3.new(1,1,1); off.Parent=content; round(off); off.Activated:Connect(function()Remotes.EquipPet:FireServer("__UNEQUIP__")end) end
 local function lockPanel()
  local seconds=(Menu.State and Menu.State.LockSeconds) or 0
  info("BASE LOCK\n\nProtect your plot from steals for a short time. Current lock: "..tostring(seconds).." seconds.")
  local buy=Instance.new("TextButton"); buy.Position=UDim2.new(.12,0,.72,0); buy.Size=UDim2.new(.76,0,.13,0); buy.Text="LOCK BASE  •  100 COINS"; buy.TextScaled=true; buy.Font=Enum.Font.FredokaOne; buy.TextColor3=Color3.new(1,1,1); buy.BackgroundColor3=Color3.fromRGB(70,155,105); buy.Parent=content; round(buy)
  buy.Activated:Connect(function() Remotes.Buy:FireServer("Base Lock"); task.delay(.2,function() Remotes.State:FireServer("Request") end) end)
 end
 local function inventory() local st=Menu.State or {}; local owned=st.Owned or {}; local text="YOUR BRAINROT COLLECTION\n\n"; if #owned==0 then text..="No brainrots yet. Explore and hold E near one!" else for _,r in ipairs(owned)do text..="• "..(r.Mutation and r.Mutation.." " or "")..r.Name.."  +"..r.Rate.."/sec\n" end end; info(text) end
 local function daily() Remotes.Panel:FireServer("Daily"); task.delay(.25,function() local state=Menu.State or {}; local progress=state.Progress or {}; local lines={"DAILY CHALLENGES"}; for _,challenge in ipairs(state.Daily or {})do table.insert(lines,"\n"..challenge.Name.."  ["..math.min(progress[challenge.Key] or 0,challenge.Goal).."/"..challenge.Goal.."]  •  "..challenge.Reward.." coins")end; info(table.concat(lines,"\n"))end) end
 local function indexPanel() local st=Menu.State or {}; local found=st.FoundBrainrots or {}; local rows={"BRAINROT INDEX", "INDEX  "..tostring(st.IndexFound or 0).."/"..tostring(st.IndexTotal or #Config.Brainrots).." found", ""}; for _,entry in ipairs(Config.Brainrots) do local name=entry.Name; table.insert(rows,(found[name] and "✓  " or "□  ")..name.."  •  "..entry.Rarity) end; info(table.concat(rows,"\n")) end
 local function emotes() info("EMOTES\n\nPress G to spin, dance, point, cry, flop, or shake your head. Emotes are purely for chaos.") end
 local function rebirthPanel()
  local st=Menu.State or {}
  info("REBIRTH LADDER\n\nKeep pets and cosmetics, reset coins and base brainrots, and gain +25% income permanently.\n\nCurrent multiplier: x"..string.format("%.2f",st.RebirthMultiplier or 1).."\nLifetime earned needed: "..tostring(st.RebirthCost or "MAX").." coins")
  local buy=Instance.new("TextButton"); buy.Position=UDim2.new(.08,0,.72,0); buy.Size=UDim2.new(.84,0,.14,0); buy.Text="REBIRTH NOW"; buy.TextScaled=true; buy.Font=Enum.Font.FredokaOne; buy.TextColor3=Color3.new(1,1,1); buy.BackgroundColor3=Color3.fromRGB(185,55,115); buy.Parent=content; round(buy)
  buy.Activated:Connect(function() Remotes.Rebirth:FireServer(); Remotes.State:FireServer("Request") end)
 end
 local function upgrades()
  clear()
  local levels=(Menu.State and Menu.State.Upgrades) or { ["Income Boost"]=0, ["Base Shield"]=0 }
  local rows={
   {"Income Boost",levels["Income Boost"] or 0,5,{1000,2500,6000,15000,40000},"+10% income per level"},
   {"Base Shield",levels["Base Shield"] or 0,3,{500,1500,4000},"+30s base lock per level"},
  }
  local heading=Instance.new("TextLabel"); heading.Size=UDim2.new(1,-24,0,52); heading.Position=UDim2.new(0,12,0,6); heading.BackgroundTransparency=1; heading.Text="UPGRADES"; heading.TextColor3=Color3.fromRGB(255,230,80); heading.TextSize=28; heading.Font=Enum.Font.FredokaOne; heading.Parent=content
  for index,row in ipairs(rows) do
   local y=72+(index-1)*108
   local text=Instance.new("TextLabel"); text.Position=UDim2.new(0,14,0,y); text.Size=UDim2.new(.62,-12,0,88); text.BackgroundTransparency=1; text.TextXAlignment=Enum.TextXAlignment.Left; text.TextYAlignment=Enum.TextYAlignment.Center; text.TextWrapped=true; text.TextColor3=Color3.new(1,1,1); text.TextSize=18; text.Font=Enum.Font.GothamBold
   local cost=row[2]<row[3] and row[4][row[2]+1] or nil
   text.Text=row[1].."  Lv "..row[2].."/"..row[3].."\n"..row[5]..(cost and ("\nNext: "..cost.." coins") or "\nMAX LEVEL")
   text.Parent=content
   if cost then
    local buy=Instance.new("TextButton"); buy.Position=UDim2.new(.66,0,0,y+22); buy.Size=UDim2.new(.29,0,0,48); buy.Text="UPGRADE"; buy.TextScaled=true; buy.Font=Enum.Font.FredokaOne; buy.TextColor3=Color3.new(1,1,1); buy.BackgroundColor3=Color3.fromRGB(70,155,105); buy.Parent=content; round(buy)
    buy.Activated:Connect(function() Remotes.Buy:FireServer("Upgrade:"..row[1]); task.delay(.2,function() Remotes.State:FireServer("Request") end) end)
   end
  end
 end
 button("▶ START PLAYING",play); button("🛒 SHOP",shop); button("🐣 PETS",pets); button("🎒 INVENTORY",inventory); button("📚 INDEX",indexPanel); button("🔒 LOCK",lockPanel); button("💃 EMOTES",emotes); button("📅 MISSIONS",daily); button("🏆 LEADERBOARD",function() local rows=(Menu.State and Menu.State.Leaderboard) or {}; local lines={"TOP MEME EARNERS"}; for i,row in ipairs(rows) do table.insert(lines,tostring(i)..". "..row.Name.."  •  "..tostring(row.Coins)) end; info(table.concat(lines,"\n")) end); button("♻ REBIRTH",rebirthPanel); button("⚙ SETTINGS",function()info("SETTINGS\n\nMusic: built-in game sounds only\nSFX: enabled\nCamera shake: subtle event shake\n\nSettings are local to this play session.")end)
 info("Welcome to the most normal neighborhood on Roblox.\n\nCatch brainrots, fill your base, collect Meme Coins, and brace for events every 20–40 seconds. Five hidden buttons are scattered around town. Rarity ladder: COMMON → UNCOMMON → RARE → EPIC → LEGENDARY → MYTHIC.")
 local close=Instance.new("TextButton"); close.Name="CloseMenu"; close.Position=UDim2.new(.91,0,.025,0); close.Size=UDim2.new(.06,0,.08,0); close.Text="×"; close.TextScaled=true; close.Font=Enum.Font.FredokaOne; close.TextColor3=Color3.new(1,1,1); close.BackgroundColor3=Color3.fromRGB(175,65,105); close.Parent=card; round(close); close.Activated:Connect(function() if hud.OpenMenu then hud.OpenMenu() end end)
 local opened=false
 local function showMenu(show)
  if show==opened then return end
  opened=show
  if show then overlay.Visible=true; card.Size=UDim2.new(.72,0,.66,0); TweenService:Create(card,TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(.82,0,.78,0)}):Play()
  else local tween=TweenService:Create(card,TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(.72,0,.66,0)}); tween:Play(); tween.Completed:Once(function() if not opened then overlay.Visible=false end end) end
 end
 hud.OpenMenu=function() showMenu(not opened) end
 Remotes.State.OnClientEvent:Connect(function(s) if type(s)=="table" then Menu.State=s end end)
 local CAS=game:GetService("ContextActionService")
 local function openPanel(panel) showMenu(true); if panel=="Lock" then lockPanel() elseif panel=="Index" then indexPanel() elseif panel=="Shop" then shop() elseif panel=="Pets" then pets() elseif panel=="Emotes" then emotes() elseif panel=="Upgrades" then upgrades() elseif panel=="Rebirth" then rebirthPanel() end end
 local entries={{"Shop",Enum.KeyCode.B},{"Pets",Enum.KeyCode.P},{"Emotes",Enum.KeyCode.G},{"Rebirth",Enum.KeyCode.R},{"Upgrades",Enum.KeyCode.U},{"Lock",Enum.KeyCode.L}}
 for _,pair in ipairs(entries) do CAS:BindAction("Quick"..pair[1],function(_,state) if state==Enum.UserInputState.Begin then openPanel(pair[1]); return Enum.ContextActionResult.Sink end; return Enum.ContextActionResult.Pass end,false,pair[2]) end
 showMenu(true)
end
return Menu
