local ItemPrototypes = {
	Armor = "power-armor-mk2",
	Robot = "construction-robot",
	Fuel = "",
	Reactor = "fusion-reactor-equipment", --4x4
	Exoskeleton = "exoskeleton-equipment", --2x4
	Shield = "energy-shield-mk2-equipment", --2x2
	Roboport = "personal-roboport-mk2-equipment", --2x2
	Battery = "battery-mk2-equipment", --1x2
	LaserDefense = "personal-laser-defense-equipment", --2x2	
	Nightvision = "night-vision-equipment", --2x2
}

local Items
local ArmorModules = {
	--Vanilla, 10x10 grid
	{Name = ItemPrototypes["Reactor"], Count = 4},
	{Name = ItemPrototypes["Roboport"], Count = 4},
	{Name = ItemPrototypes["Battery"], Count = 2},
	{Name = ItemPrototypes["Shield"], Count = 4},
}

--Personal Equipment gives upgraded options, lets use a few.
if script.active_mods["bobequipment"] then
	ItemPrototypes["Reactor"] = "fusion-reactor-equipment-4" --Reactor 4 4x4
	ItemPrototypes["Shield"] = "energy-shield-mk6-equipment" --Shield 6 2x2
	ItemPrototypes["Roboport"] = "personal-roboport-mk4-equipment" --Roboport 4 2x2
	ItemPrototypes["Battery"] = "battery-mk6-equipment" --Battery 6 1x2
	ItemPrototypes["LaserDefense"] = "personal-laser-defense-equipment-6" --Laser Defense 6 2x2
	ItemPrototypes["Exoskeleton"] = "exoskeleton-equipment-3" --Exoskeleton 3 2x4
	ItemPrototypes["Nightvision"] = "night-vision-equipment-3" --2x2
end

--Logistics gives us upgraded bots
if script.active_mods["boblogistics"] then
	ItemPrototypes["Robot"] = "bob-construction-robot-5"
end

--Freeplay
script.on_init(function(event)
	if game.active_mods["Krastorio2"] then
		--Krastorio, mk 4, 12x12
		ItemPrototypes["Armor"] = "power-armor-mk4"
		--Reactors require fuel
		ItemPrototypes["Fuel"] = "dt-fuel"

		ArmorModules = {
			{Name = ItemPrototypes["Reactor"], Count = 4},
			{Name = ItemPrototypes["Roboport"], Count = 4},
			{Name = ItemPrototypes["Shield"], Count = 4},
			{Name = ItemPrototypes["Battery"], Count = 2},
			{Name = ItemPrototypes["Nightvision"], Count = 1},
			{Name = ItemPrototypes["Exoskeleton"], Count = 4},
		}

	elseif game.active_mods["bobwarfare"] then
		--Bob's Warfare, mk 5, 16x16 grid
		ItemPrototypes["Armor"] = "bob-power-armor-mk5"

		ArmorModules = {
			{Name = ItemPrototypes["Reactor"], Count = 8},
			{Name = ItemPrototypes["Roboport"], Count = 4},
			{Name = ItemPrototypes["Shield"], Count = 4},
			{Name = ItemPrototypes["Battery"], Count = 2},
			{Name = ItemPrototypes["Nightvision"], Count = 1},
			{Name = ItemPrototypes["Battery"], Count = 4},
			{Name = ItemPrototypes["Exoskeleton"], Count = 5},
			{Name = ItemPrototypes["LaserDefense"], Count = 16},
		}
	end

	Items = {{ItemPrototypes["Robot"], settings.global["starting robot count"].value}}

	if not (ItemPrototypes["Fuel"] == "") then
		table.insert(Items, {ItemPrototypes["Fuel"], 80})
	end

	

	if not(settings.global["faster robots"].value == 0) then
		for k,v in pairs(game.forces) do
			for z = 1, settings.global["faster robots"].value, 1 do
				v.technologies["worker-robots-speed-" .. tostring(z)].researched = true
			end
		end
	end
	
end)

function EquipArmor(event)
	local Player = game.players[event.player_index]
	local ArmorInventory = Player.get_inventory(defines.inventory.character_armor)
	
	if not(ArmorInventory == nil) then --If the player doesn't have armor inventory, the player hasn't spawned, so we can skip this round.
		for i, v in pairs(Items) do
			Player.insert{name = v[1], count = v[2]}
		end
		if not(ArmorInventory.is_empty()) then
			--We want to remove whatever armor they had to slot in what we want.
			local CurrentArmor = ArmorInventory[1].name
			ArmorInventory.clear()
			--Then for good measure we destroy it from the inventory.
			local PlayerInventory = Player.get_inventory(defines.inventory.character_main)
			PlayerInventory.remove(CurrentArmor);
		end
		local n = 0
		n = ArmorInventory.insert{name=ItemPrototypes["Armor"],count=1}
		if(n > 0)then -- we actually equipped the armor
			local grid=ArmorInventory[1].grid
			for i,module in pairs(ArmorModules) do
				for y = 1, module.Count, 1 do
					grid.put({name=module.Name})
				end
			end
		end
	end
end	

--Classic start/no cutscene/multiplayer addition
script.on_event(defines.events.on_player_created, function(event)
	EquipArmor(event)
end)

--Freeplay/Cutscene start
script.on_event(defines.events.on_cutscene_cancelled, function(event)
	EquipArmor(event)
end)
