function readln(f)
{
	local c = null;
	local s = "";
	while (!f.eos() && c != '\n') {
		if (c) { s += format("%c",c); }
		c = f.readn('c');
	}
	return s
}
function nice(s)
{
	local p;
	local b = false;
	local g = true;
	local v = 0;
	foreach (c in s)
	{
		local pc = "";
		if (p) { pc = format("%c%c",p,c); }
		b = b || (c == p);
		g = g && pc != "ab";
		g = g && pc != "cd";
		g = g && pc != "pq";
		g = g && pc != "xy";
		p = c;
	}
	return b && g && (split("#"+s+"#","aeiou").len() > 3)
}

function nice2(s)
{
	local p = false;
	local q = false;
	for (local i = 0; i < s.len() - 2; ++i)
	{
		p = p || s.find(s.slice(i,i+2),i+2);
		q = q || s.slice(i,i+1) == s.slice(i+2,i+3);
	}
	return p && q;
}

local a = 0;
local b = 0;
local s;
local f = file("05.txt","r");
while (!f.eos())
{
	s = readln(f);
	a += nice(s) ? 1 : 0;
	b += nice2(s) ? 1 : 0;
}
print(format("%d\t%d\n",a,b));
