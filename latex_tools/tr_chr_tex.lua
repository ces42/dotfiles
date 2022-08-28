#!/usr/bin/lua

chr_to_tex = {}

function read_dict(file)
	byte_list = {}
	len_tbl = {}
	notalpha = {}
	for line in io.lines(file) do
		if line:sub(1, 1) == '#' or line == '' then
			goto continue
		end
		tex_start = line:find(' ') + 1
		chr = line:sub(1, tex_start-2)
		table.insert(byte_list, chr:sub(1,1))
		if len_tbl[chr:sub(1,1)] == nil then
			len_tbl[chr:sub(1,1)] = chr:len()
		else
			assert(len_tbl[chr:sub(1,1)] == chr:len())
		end
		chr_to_tex[chr] = '\\' .. line:sub(tex_start, -1)
		if not line:sub(tex_start, -1):find('[a-zA-Z]') then
			notalpha[chr] = true
		end

		::continue::
	end
	return {'[' .. table.concat(byte_list, '') .. ']', len_tbl, notalpha}
end

function tr_write(str)
	a, _ = str:find(regex)
    if a == nil then
        return str
    end
    new = {}
    last = 0
    while a ~= nil do
        byte = str:sub(a, a)
		b = a + len_tbl[byte] - 1
		chr = str:sub(a, b)
		if notalpha[chr] or not str:sub(b+1, b+1):find('^[a-zA-Z]$') then
			sub = chr_to_tex[chr]
			if sub == nil then
				sub = chr
			end
			table.insert(new, str:sub(last + 1, a - 1))
			table.insert(new, sub)
			last = b
		end
        a, _ = str:find(regex, b + 1)
    end
    table.insert(new, str:sub(last+1, #str))
    return table.concat(new, '')
end




build = read_dict('translate.csv')
regex = build[1]
len_tbl = build[2]
notalpha = build[3]
--print(regex)
--print(string.format('len(regex) = %s',regex:len()))
io.write(tr_write(io.read("*a")))
io.flush()

--line = io.read("*l")
--while line ~= nil do
--    line = io.read("*l")
--    print(tr_read(line))
--end
--io.flush()
