-- redefine the greek letter imaps to use ensure_math
local use_unicode = vim.b.translate_tex_unicode
local s = {}

local shortcuts = {
    a = 'α',
    b = 'β',
    c = 'χ',
    d = 'δ',
    e = 'ε',
    f = 'φ',
    g = 'γ',
    h = 'η',
    i = 'ι',
    k = 'κ',
    l = 'λ',
    m = 'μ',
    n = 'ν',
    p = 'π',
    q = 'θ', 
    r = 'ρ',
    s = 'σ',
    t = 'τ',
    u = 'υ',
    w = 'ω',
    x = 'ξ',
    y = 'ψ',
    z = 'ζ',
    
    D = 'Δ',
    F = 'Φ',
    G = 'Γ',
    L = 'Λ',
    P = 'Π',
    Q = 'Θ',
    S = 'Σ',
    W = 'Ω',
    X = 'Ξ',
    Y = 'Ψ',

    o = '∘',
    O = '⊗',
    V = '∇',
    A = '∀',
    ['('] = '⊂',
    ['['] = '⊆',
    ['<'] = '⟨',
    ['>'] = '⟩',
    ['6'] = '∂',
    vd = '∂',
    ['/'] = '∧',
    ['\\'] = '∖',
    ['vm'] = '∖',
    ['0'] = '∅',
    ['|'] = '∥',
    ['v>'] = '≥',
    ['v<'] = '≤',
    ['~>'] = '≳',
    ['~<'] = '≲',
    ['vl'] = 'ℓ',
}

function s.imaps_setup()
    imaps = vim.api.nvim_get_var('vimtex_imaps_list')
    if vim.b.translate_tex_unicode then
        vim.bo.iminsert = 1
    else
        vim.bo.iminsert = 0
        shortcuts = {}
    end
    for k, v in pairs(imaps) do
        if v.lhs:match("^%a$") and v.rhs:match("^\\") and shortcuts[v.lhs] == nil then-- %l is a 'regex' class for lowercase letters
            vim.fn['vimtex#imaps#add_map']({lhs = v.lhs, rhs = v.rhs, wrapper = 'Ensure_math'})
            --vim.cmd("let g:vimtex_imaps_list[" .. k .. "].wrapper = 'Ensure_math'")
        end
    end

    for k, v in pairs(shortcuts) do
        if (k:match("%a") or k == 'vl') and k ~= 'o' and k ~= 'O' then
            vim.api.nvim_buf_set_keymap(0, 'l', ';' .. k, 'Ensure_math(";' .. k .. '", "' .. v ..'")', {noremap = true, silent = true, nowait = true, expr = true})
            --vim.api.nvim_buf_set_keymap(0, 'l', ';' .. k, v, {noremap = true, silent = true, nowait = true})
        else
            lhs = vim.fn.escape(';' .. k, '\\')
            vim.api.nvim_buf_set_keymap(0, 'l', ';' .. k, 'In_math("' .. lhs .. '", "' .. v ..'")', {noremap = true, silent = true, nowait = true, expr = true})
        end
        --vim.fn['vimtex#imaps#add_map']({lhs = k, rhs = v, wrapper = 'Ensure_math'})
    end
end

return s

-- BufReadCmd
--tex_to_chr = {}

--local function read_dict(file)
--	for line in io.lines(file) do
--		if line:sub(1, 1) == '#' or line == '' then
--			goto continue
--		end
--		tex_start = line:find(' ') + 1
--		tex_to_chr[line:sub(tex_start, -1)] = line:sub(1, tex_start-2)

--		::continue::
--	end
--end

--read_dict('translate.csv')

--function translate_tex_read(str)
--    a, b = str:find('\\[a-zA-Z]+')
--    if a == nil then
--        return str
--    end
--    new = {}
--    last = 0
--    new_i = 1
--    while a ~= nil do
--        cmd = str:sub(a + 1, b) -- str:sub(a, a) is a backslash
--        sub = tex_to_chr[cmd]
--        if sub ~= nil then
--            new[new_i] = str:sub(last + 1, a - 1)
--            new[new_i + 1] = sub
--            new_i = new_i + 2
--            last = b
--        end
--        a, b = str:find('\\[a-zA-Z]+', b + 1)
--    end
--    new[new_i] = str:sub(last+1, #str)
--    return table.concat(new, '')
--end


--function read_tex(fname)
--    file = io.open(fname, "r")
--    new = {}
--    for line in file:lines() do
--        print(line)
--        table.insert(new, translate_tex_read(line))
--    end
--    for i, s in pairs(new) do
--        --print(s .. ' ' .. s)
--    end
--    vim.fn.append(0, new)
--end



--function write_tex()
--vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

