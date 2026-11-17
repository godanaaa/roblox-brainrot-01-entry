local CoinService={}
function CoinService.Init(ctx) CoinService.Context=ctx; CoinService.Balances={} end
function CoinService.Set(player,value) local n=math.max(0,math.floor(value)); CoinService.Balances[player]=n; player:SetAttribute("Coins",n); local ls=player:FindFirstChild("leaderstats"); local v=ls and ls:FindFirstChild("Meme Coins"); if v then v.Value=n end; CoinService.Context.Remotes.State:FireClient(player,CoinService.Context.Snapshot(player)) end
function CoinService.Get(player) return CoinService.Balances[player] or 0 end
function CoinService.Add(player,amount,reason) if player and player.Parent then CoinService.Set(player,CoinService.Get(player)+amount); if reason then CoinService.Context.Remotes.Announcement:FireClient(player,"+"..amount.." Meme Coins • "..reason) end end end
function CoinService.Spend(player,amount) if CoinService.Get(player)<amount then return false end; CoinService.Set(player,CoinService.Get(player)-amount); return true end
return CoinService
