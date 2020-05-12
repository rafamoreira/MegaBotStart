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

--Item Counts

script.on_event(defines.events.on_player_created, function(event)
	local items
	local ArmorModules

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
else
	--Vanilla, 10x10 grid
	ArmorModules = {
		{Name = ItemPrototypes["Reactor"], Count = 4},
		{Name = ItemPrototypes["Roboport"], Count = 4},
		{Name = ItemPrototypes["Battery"], Count = 2},
		{Name = ItemPrototypes["Shield"], Count = 4},
	}
end

items = {{ItemPrototypes["Robot"], settings.global["starting robot count"].value}}
if not (ItemPrototypes["Fuel"] == "") then
	table.insert(items, {ItemPrototypes["Fuel"], 80})
end

	local Player = game.players[event.player_index]
	for i, v in pairs(items) do
		Player.insert{name = v[1], count = v[2]}
	end

	local ArmorInventory = Player.get_inventory(defines.inventory.character_armor)
	if not(ArmorInventory == nil) then
		local n = ArmorInventory.insert{name=ItemPrototypes["Armor"],count=1}
		if(n>0)then -- we actually equipped the armor
			local grid=ArmorInventory[1].grid
			for i,module in pairs(ArmorModules) do
				for y = 1, module.Count, 1 do
					grid.put({name=module.Name})
				end
			end
		end
	end

	if not(settings.global["faster robots"].value == 0) then
		for k,v in pairs(game.forces) do
			for z = 1, settings.global["faster robots"].value, 1 do
				v.technologies["worker-robots-speed-" .. tostring(z)].researched = true
			end
		end
	end

end)
