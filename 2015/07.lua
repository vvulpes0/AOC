local f = io.stdin
local t = {}
local s = f:read("*l")
while s do
	w = {}
	b = false
	for i in s:gmatch("%S+") do
		if (i == "->") then b = true goto continue end
		if b then t[i] = w goto continue end
		w[#w + 1] = i
		::continue::
	end
	s = f:read("*l")
end
function lookup(t, x)
	if tonumber(x) ~= nil then return tonumber(x) end
	local w = t[x]
	if (type(w) ~= "table") then return w end
	local n = nil
	if (#w == 1) then
		n = lookup(t, w[1]) & 65535
	elseif (#w == 2) then
		n = (1 - lookup(t, w[2])) & 65535
	elseif (w[2] == "AND") then
		n = lookup(t, w[1]) & lookup(t, w[3])
	elseif (w[2] == "OR") then
		n = lookup(t, w[1]) | lookup(t, w[3])
	elseif (w[2] == "LSHIFT") then
		n = (lookup(t, w[1]) << lookup(t, w[3])) & 65535
	elseif (w[2] == "RSHIFT") then
		n = lookup(t, w[1]) >> lookup(t, w[3])
	end
	t[x] = n
	return n
end
local u = {}
for k,v in pairs(t) do
	u[k] = v
end
local a = lookup(t, "a")
u["b"] = a
local b = lookup(u, "a")
print(tostring(a).."\t"..tostring(b))
