--All contents of this file are licensed under MIT. See LICENSE.txt for more information.

local mixbases = {"pink", "magenta", "red", "orange", "brown", "yellow", "green", "dark_green", "cyan", "blue", "violet", "black", "dark_grey", "grey", "white"}

local mixes = {
	--             pink,     magenta,  red,      orange,      brown,       yellow,      green,       dark_green,  cyan,   blue,    violet,  black,      dark_grey,  grey,  white
	white      = {"pink",   "pink",   "pink",   "orange",    "orange",    "yellow",    "green",     "green",     "grey", "cyan",  "violet","grey",     "grey",     "grey","white"},
	grey       = {"pink",   "pink",   "pink",   "orange",    "orange",    "yellow",    "green",     "green",     "grey", "cyan",  "violet","dark_grey","grey",     "grey"},
	dark_grey  = {"brown",  "brown",  "brown",  "brown",     "brown",     "brown",     "dark_green","dark_green","blue", "blue",  "violet","black",    "dark_grey"},
	black      = {"black",  "black",  "black",  "black",     "black",     "black",     "black",     "black",     "black","black", "black", "black"},
	violet     = {"magenta","magenta","magenta","red",       "brown",     "red",       "cyan",      "brown",     "blue", "violet","violet"},
	blue       = {"violet", "violet", "magenta","brown",     "brown",     "dark_green","cyan",      "cyan",      "cyan", "blue"},
	cyan       = {"brown",  "blue",   "brown",  "dark_green","dark_grey", "green",     "cyan",      "dark_green","cyan"},
	dark_green = {"brown",  "brown",  "brown",  "brown",     "brown",     "green",     "green",     "dark_green"},
	green      = {"yellow", "brown",  "yellow", "yellow",    "dark_green","green",     "green"},
	yellow     = {"orange", "red",    "orange", "yellow",    "orange",    "yellow"},
	brown      = {"brown",  "brown",  "brown",  "orange",    "brown"},
	orange     = {"orange", "red",    "orange", "orange"},
	red        = {"pink",   "magenta","red"},
	magenta    = {"magenta","magenta"},
	pink       = {"pink"},
}

for one, results in pairs(mixes) do
	for i, result in ipairs(results) do
		local another = mixbases[i]
		minetest.clear_craft({
			recipe = {'dye:' .. one, 'dye:' .. another},
		})
		mcg_dyemixer.register_mix ('dye:' .. one, 'dye:' .. another, {name = 'dye:' .. result, count = 2})
	end
end