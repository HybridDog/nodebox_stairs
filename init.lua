local load_time_start = os.clock()


-- What needs to be changed

local stairboxdef = {
	mesh = "",
	drawtype = "nodebox",
	nodebox = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	},
}


-- Override stair register function

local register_node = minetest.register_node
local function register_stair_node(name, def, ...)
	for i,v in pairs(stairboxdef) do
		def[i] = v
	end
	return register_node(name, def, ...)
end

local register_stair = stairs.register_stair
function stairs.register_stair(...)
	minetest.register_node = register_stair_node
	register_stair(...)
	minetest.register_node = register_node
end


-- Override known stair nodes

for name in pairs(minetest.registered_nodes) do
	if string.sub(name, 1, 13) == "stairs:stair_" then
		minetest.override_item(name, stairboxdef)
	end
end


local time = math.floor(tonumber(os.clock()-load_time_start)*100+0.5)/100
local msg = "[nodebox_stairs] loaded after ca. "..time
if time > 0.05 then
	print(msg)
else
	minetest.log("info", msg)
end
