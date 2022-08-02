#!/usr/bin/lua

chr_to_tex = {}

function read_dict(file)
	regex_list = {}
	for line in io.lines(file) do
		if line:sub(1, 1) == '#' or line == '' then
			goto continue
		end
		tex_start = line:find(' ') + 1
		chr = line:sub(1, tex_start-2)
		table.insert(regex_list, chr)
		chr_to_tex[chr] = '\\' .. line:sub(tex_start, -1)

		::continue::
	end
	return '[' .. table.concat(regex_list, '') .. ']'
end

function tr_write(str)
	a, b = str:find(regex)
    if a == nil then
        return str
    end
    new = {}
    last = 0
    while a ~= nil do
        chr = str:sub(a, b) -- str:sub(a, a) is a backslash
        sub = chr_to_tex[cmd]
		table.insert(new, str:sub(last + 1, a - 1))
		table.insert(new, sub)
		last = b
        a, b = str:find(regex, b + 1)
    end
    table.insert(new, str:sub(last+1, #str))
    return table.concat(new, '')
end


regex = read_dict('translate.csv')
print(regex)
io.write(tr_write(io.read("*a")))
io.flush()

--line = io.read("*l")
--while line ~= nil do
--    line = io.read("*l")
--    print(tr_read(line))
--end
--io.flush()
