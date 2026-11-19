local Upgrade = {}
local TRACKS = {
	["Income Boost"] = {Max = 5, Costs = {1000, 2500, 6000, 15000, 40000}},
	["Base Shield"] = {Max = 3, Costs = {500, 1500, 4000}},
}

function Upgrade.Init(ctx)
	Upgrade.Context = ctx
	Upgrade.Levels = {}
	local function load(player)
		local data = ctx.Data.Data[player]
		if data then
			local saved = type(data.Upgrades) == "table" and data.Upgrades or {}
			Upgrade.Levels[player] = {
				["Income Boost"] = math.clamp(math.floor(tonumber(saved["Income Boost"]) or 0), 0, TRACKS["Income Boost"].Max),
				["Base Shield"] = math.clamp(math.floor(tonumber(saved["Base Shield"]) or 0), 0, TRACKS["Base Shield"].Max),
			}
			ctx.Remotes.State:FireClient(player, {Upgrades = Upgrade.GetUpgrades(player)})
		end
	end
	game:GetService("Players").PlayerAdded:Connect(function(player)
		task.spawn(function()
			for _ = 1, 600 do
				if ctx.Data.Data[player] then load(player); return end
				task.wait(0.1)
			end
		end)
	end)
	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		task.spawn(function()
			for _ = 1, 600 do
				if ctx.Data.Data[player] then load(player); return end
				task.wait(0.1)
			end
		end)
	end
	game:GetService("Players").PlayerRemoving:Connect(function(player) Upgrade.Levels[player] = nil end)
end

function Upgrade.GetUpgrades(player)
	local levels = Upgrade.Levels[player] or { ["Income Boost"] = 0, ["Base Shield"] = 0 }
	return { ["Income Boost"] = levels["Income Boost"] or 0, ["Base Shield"] = levels["Base Shield"] or 0 }
end

function Upgrade.BuyUpgrade(player, track)
	local definition = TRACKS[track]
	if not definition or not player.Parent then return false end
	local levels = Upgrade.Levels[player]
	if not levels then return false end
	local level = levels[track] or 0
	if level >= definition.Max then return false end
	if not Upgrade.Context.Coin.Spend(player, definition.Costs[level + 1]) then return false end
	levels[track] = level + 1
	local data = Upgrade.Context.Data.Data[player]
	if data then data.Upgrades = Upgrade.GetUpgrades(player) end
	Upgrade.Context.Remotes.State:FireClient(player, {Upgrades = Upgrade.GetUpgrades(player), IncomeRate = Upgrade.Context.Base.GetIncomeRate(player)})
	Upgrade.Context.Announce.To(player, track .. " upgraded to level " .. tostring(level + 1) .. "!")
	return true
end

function Upgrade.GetIncomeBoost(player)
	return 1 + (Upgrade.GetUpgrades(player)["Income Boost"] * 0.1)
end

function Upgrade.GetLockBonus(player)
	return Upgrade.GetUpgrades(player)["Base Shield"] * 30
end

return Upgrade
