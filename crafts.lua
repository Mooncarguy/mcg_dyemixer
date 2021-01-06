if minetest.get_modpath("dye") then
	local dye_recipes = {
		-- src1, src2, dst
		-- RYB mixes
		{"red", "blue", "violet"}, -- "purple"
		{"yellow", "red", "orange"},
		{"yellow", "blue", "green"},	
		-- RYB complementary mixes
		{"yellow", "violet", "dark_grey"},
		{"blue", "orange", "dark_grey"},
		-- CMY mixes - approximation
		{"cyan", "yellow", "green"},
		{"cyan", "magenta", "blue"},
		{"yellow", "magenta", "red"},
		-- other mixes that result in a color we have
		{"red", "green", "brown"},
		{"magenta", "blue", "violet"},
		{"green", "blue", "cyan"},
		{"pink", "violet", "magenta"},
		-- mixes with black
		{"white", "black", "grey"},
		{"grey", "black", "dark_grey"},
		{"green", "black", "dark_green"},
		{"orange", "black", "brown"},
		-- mixes with white
		{"white", "red", "pink"},
		{"white", "dark_grey", "grey"},
		{"white", "dark_green", "green"},
	}

	for _, mix in pairs(dye_recipes) do
		minetest.clear_craft({
			type = "shapeless",
			recipe = {"dye:" .. mix[1], "dye:" .. mix[2]}
		})
		mcg_dyemixer.register_mix("dye:" .. mix[1], "dye:" .. mix[2], {name="dye:"..mix[3], count = 2})
	end
end

if minetest.get_modpath("wool") then
	local dyes = dye.dyes

	for i = 1, #dyes do
		local name, desc = unpack(dyes[i])
		minetest.clear_craft{
			type = "shapeless",
			recipe = {"group:dye,color_" .. name, "group:wool"}
		}
	
		mcg_dyemixer.register_mix("dye:" .. name, "wool:white", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:grey", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:dark_grey", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:black", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:violet", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:blue", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:cyan", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:dark_green", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:green", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:yellow", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:brown", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:orange", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:red", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:magenta", {name = "wool:" .. name, count = 1})
		mcg_dyemixer.register_mix("dye:" .. name, "wool:pink", {name = "wool:" .. name, count = 1})
	end
end
