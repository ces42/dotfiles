#!/usr/bin/lua

tex_to_chr = {}

function read_dict(file)
	for line in io.lines(file) do
		if line:sub(1, 1) == '#' or line == '' then
			goto continue
		end
		tex_start = line:find(' ') + 1
		tex_to_chr[line:sub(tex_start, -1)] = line:sub(1, tex_start-2)

		::continue::
	end
end


function tr_read(str)
    a, b = str:find('\\[a-zA-Z]+')
    if a == nil then
        new = str
	goto final
    end
    new = {}
    last = 0
    while a ~= nil do
        cmd = str:sub(a + 1, b) -- str:sub(a, a) is a backslash
        sub = tex_to_chr[cmd]
        if sub ~= nil then
            table.insert(new, str:sub(last + 1, a - 1))
            table.insert(new, sub)
            last = b
        end
        a, b = str:find('\\[a-zA-Z]+', b + 1)
    end
    table.insert(new, str:sub(last+1, #str))
    new = table.concat(new, '')

    ::final::
    if tex_to_chr['|'] ~= nil then
	    new = new:gsub('\\|', tex_to_chr['|'])
    end
    return new
end


read_dict(os.getenv('HOME') .. '/latex_tools/translate.csv')
io.write(tr_read(io.read("*a")))
io.flush()

--line = io.read("*l")
--while line ~= nil do
--    line = io.read("*l")
--    print(tr_read(line))
--end
--io.flush()
