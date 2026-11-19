local Shop={}
local Config=require(game:GetService("ReplicatedStorage").Modules.Config)
local function applyGiantHead(character)
 local head=character:FindFirstChild("Head"); if head and not head:GetAttribute("GiantHeadApplied") then head:SetAttribute("GiantHeadApplied",true); head.Size*=2 end
end
local function ensureGiantHead(player)
 if player.Character then applyGiantHead(player.Character) end
 if not Shop.HeadConnection[player] then Shop.HeadConnection[player]=player.CharacterAdded:Connect(applyGiantHead) end
end
function Shop.Init(ctx) Shop.Context=ctx; Shop.Owned={}; Shop.HeadConnection={}; game:GetService("Players").PlayerAdded:Connect(function(player) task.spawn(function() for _=1,300 do local data=ctx.Data.Data[player]; if data then Shop.Owned[player]=data.Cosmetics or {}; if Shop.Owned[player]["Giant Head"] then ensureGiantHead(player) end; return end; task.wait(.1) end end) end); ctx.Remotes.Buy.OnServerEvent:Connect(function(player,item)
 if type(item)~="string" then return end
 if item=="Base Lock" then if ctx.Base.Lock(player) then ctx.Announce.To(player,"BASE LOCKED • 60 seconds") end; return end
 if string.sub(item,1,8)=="Upgrade:" then ctx.Upgrade.BuyUpgrade(player,string.sub(item,9)); return end
 if item=="Next Slot" then if ctx.Base.Expand(player) then ctx.Announce.To(player,"Your base expanded!") end; return end
 if item=="Transformation" then if ctx.Coin.Spend(player,150) then ctx.Transform.Apply(player,Config.Transformations[math.random(1,#Config.Transformations)],30) end; return end
 if string.sub(item,1,4)=="Pet:" then local name=string.sub(item,5); local price=Config.PetPrices[name]; if not price or not table.find(Config.Pets,name) then return end; ctx.Pet.Owned[player]=ctx.Pet.Owned[player] or {}; if ctx.Pet.Owned[player][name] then ctx.Pet.Equip(player,name) elseif ctx.Coin.Spend(player,price) then ctx.Pet.Owned[player][name]=true; ctx.Pet.Equip(player,name); ctx.Announce.To(player,name.." pet unlocked!") end; return end
 if string.sub(item,1,9)=="Brainrot:" then local name=string.sub(item,10); if ctx.Brainrot.Purchase(player,name) then ctx.Announce.To(player,name.." bought and placed on your base!") else ctx.Announce.To(player,"Not enough coins, no free slot, or that brainrot is not for sale.") end; return end
 local entry=Config.Shop[item]; if not entry then return end
 Shop.Owned[player]=Shop.Owned[player] or {}; if Shop.Owned[player][item] then ctx.Announce.To(player,"You already own "..item.."."); return end
 if not ctx.Coin.Spend(player,entry.Price) then return end
 Shop.Owned[player][item]=true
 if item=="Giant Head" then ensureGiantHead(player) end
 if item=="Chicken Pet" then ctx.Pet.Owned[player]=ctx.Pet.Owned[player] or {}; ctx.Pet.Owned[player].Chicken=true; ctx.Pet.Equip(player,"Chicken") elseif item=="Meme Face" then ctx.Transform.MemeFace(player) elseif item=="Funny Trail" then ctx.Transform.Trail(player) elseif item=="Banana Sword" then ctx.Transform.Sword(player) elseif item=="Toilet Mount" then ctx.Transform.ToiletMount(player) end
 if item=="Exploding Backpack" then ctx.Transform.ExplodingBackpack(player) end
 ctx.Remotes.Announcement:FireClient(player,item.." unlocked!")
 end)
end
function Shop.GetOwned(player) return Shop.Owned[player] or {} end
return Shop
