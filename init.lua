--All contents of this file are licensed under MIT. See LICENSE.txt for more information.

mcg_dyemixer = {}
mcg_dyemixer.mixes = {}

function mcg_dyemixer.register_mix(input_a, input_b, result)
	local mix_id = string.gsub(input_a, ":", "-")..string.gsub(input_b, ":", "-")
	mcg_dyemixer.mixes[mix_id] = {name = result.name, count = result.count}
end

local modpath = minetest.get_modpath("mcg_dyemixer")
dofile(modpath.."/crafts.lua")

local function mcg_dyemixer_mixdye(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	local input_a = inv:get_stack("input_a", 1)
	local input_b = inv:get_stack("input_b", 1)
	local mix_id = string.gsub(input_a:get_name(), ":", "-")..string.gsub(input_b:get_name(), ":", "-")
	local mix_id_b = string.gsub(input_b:get_name(), ":", "-")..string.gsub(input_a:get_name(), ":", "-")
	local output = inv:get_stack("output", 1)
	local mixnum = 0
	
	--Predefining number of mixes calculated by the input stack counts
	if input_a:get_count() < input_b:get_count() then
		mixnum = input_a:get_count()
	else
		mixnum = input_b:get_count()
	end
	
	--Checking which way around the dyes are placed and return if not a valid recipes
	if not mcg_dyemixer.mixes[mix_id] then
		mix_id = mix_id_b
	end
	if not mcg_dyemixer.mixes[mix_id] then
		return false
	end
	
	--Redefining according to max stack
	local stack_to_check = ItemStack(mcg_dyemixer.mixes[mix_id].name)
	for i=mixnum, 0, -1 do 
		if  mcg_dyemixer.mixes[mix_id].count*mixnum > stack_to_check:get_stack_max() then
			mixnum = mixnum - 1
		end
	end

	--Redefining according to space in output area
	for i=mixnum, 0, -1 do
		if inv:room_for_item ("output", {name = mcg_dyemixer.mixes[mix_id].name, count = mcg_dyemixer.mixes[mix_id].count*mixnum}) ~= true then
			mixnum = mixnum - 1
		end
	end

	--Setting the new stacks
	local newstack_a = {name = input_a:get_name(), count = input_a:get_count() - mixnum}
	local newstack_b = {name = input_b:get_name(), count = input_b:get_count() - mixnum}
	local newstack_output = {name = mcg_dyemixer.mixes[mix_id].name, count = mcg_dyemixer.mixes[mix_id].count*mixnum + 
	output:get_count()}
	if mixnum >= 1 and (input_a:get_count() - mixnum) >= 0 and (input_b:get_count() - mixnum) >= 0 then
		inv:set_stack("input_a", 1, newstack_a)
		inv:set_stack("input_b", 1, newstack_b)
		inv:set_stack("output", 1, newstack_output)
	end
end

minetest.register_node("mcg_dyemixer:dye_mixer", {
	description = "Dye Mixer",
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	tiles = {
		"mcg_dyemixer_dye_mixer_bottom_top_underlay.png^mcg_dyemixer_dye_mixer_top.png^[transformR270", 
		"mcg_dyemixer_dye_mixer_bottom_top_underlay.png", 
		"mcg_dyemixer_dye_mixer_side_underlay.png^mcg_dyemixer_dye_mixer_side_a.png",
		"mcg_dyemixer_dye_mixer_side_underlay.png^mcg_dyemixer_dye_mixer_side_b.png", 
		"mcg_dyemixer_dye_mixer_side_underlay.png^mcg_dyemixer_dye_mixer_side_c.png", 
		"mcg_dyemixer_dye_mixer_side_underlay.png^mcg_dyemixer_dye_mixer_side_d.png"
	},
	after_place_node = function(pos) 
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		meta:set_string("infotext", "Dye Mixer")
		inv:set_size("input_a", 1)
		inv:set_size("input_b", 1)
		inv:set_size("output", 1)
		meta:set_string("formspec", [[
			size[8,4.8]
			box[-0.01,0;1.84,0.9;#555555]
			image[0,0;1,1;mcg_dyemixer_mixicon_underlay.png^mcg_dyemixer_mixicon.png]
			label[1.2,0.25;Mix]
			list[context;input_a;2,0;1,1;]
			list[context;input_b;3,0;1,1;]
			image[2,0;1,1;mcg_dyemixer_dye_layout.png]
			image[3,0;1,1;mcg_dyemixer_dye_layout.png]
			image[4,0;1,1;gui_furnace_arrow_bg.png^[transformR270]
			list[context;output;5,0;1,1;]
			image[5,0;1,1;mcg_dyemixer_dye_layout.png]
			list[current_player;main;0,1.1;8,4;]
		]].. default.gui_bg .. default.gui_bg_img .. default.gui_slots .. default.get_hotbar_bg(0, 1.1))
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local stackname = stack:get_name()
		if (listname == "input_a" or listname == "input_b") and string.sub(stackname, 1, 4) == "dye:" then
			print ("duh")
			return stack:get_count()
		end
		return 0
	end,
	on_metadata_inventory_put = function(pos)
		mcg_dyemixer_mixdye(pos)
	end,
	on_metadata_inventory_take = function(pos)
		mcg_dyemixer_mixdye(pos)
	end,
	on_metadata_inventory_move = function(pos)
		mcg_dyemixer_mixdye(pos)
	end,
	can_dig = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		if inv:is_empty("input_a") and inv:is_empty("input_b") and inv:is_empty("output") then
			return true
		else
			return false
		end
end})

minetest.register_craft({
	output = "mcg_dyemixer:dye_mixer",
	recipe = {
		{"bucket:bucket_empty", "group:stick", "bucket:bucket_empty"},
		{"group:wood", "bucket:bucket_empty", "group:wood"},
		{"vessels:steel_bottle", "vessels:steel_bottle", "vessels:steel_bottle"}
	}
})

if minetest.get_modpath("xdecor") then
	minetest.register_craft({
	output = "mcg_dyemixer:dye_mixer",
	recipe = {
		{"xdecor:bowl", "group:stick", "xdecor:bowl"},
		{"group:wood", "bucket:bucket_empty", "group:wood"},
		{"vessels:steel_bottle", "vessels:steel_bottle", "vessels:steel_bottle"}
	}
})
end
