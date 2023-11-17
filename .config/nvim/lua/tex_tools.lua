--" * check mathzone boundaries
--" * find possible left boundaries
--"   - opening delimiter, =, \cong, \equiv, \simeq, ~
--"   - '+', '-', '\oplus'
--" * find closing delimiter to the left
--" * if the closing delimiter is closer to cursor position => new left seek at
--"   corresponding delimiter

--execute printf('xnoremap <silent><buffer> i+ :<c-u>call get_summand()')

--const s:weak_ops = {'=', '\\cong', '\\equiv', '\\simeq'}

--function! Get_summand() abort
  --let l:save_pos = vimtex#pos#get_cursor()
  --let l:pos_val_cursor = vimtex#pos#val(l:save_pos)
  --let l:left = l:pos_val_cursor
  --let l:right = l:pos_val_cursor
  --let l:math_left, l:math_right = vimtex#delim#get_surrounding('env_math')
  --while l:left > l:math_left.cnum
    --vimtex#delim#get_prev('delim_modq_math', 'close')
--endfunction

function expand_font_macros()
    local onlycaps = {c = 'mathcal', sc = 'mathscr', bb = 'mathbb', s = 'mathsf'}
    local both = {bf = 'mathbf', f = 'mathfrak'}
    for k, v in pairs(onlycaps) do
        vim.api.nvim_command('%s/\\\\' .. k .. '\\(\\u\\)\\a\\@!/\\\\' .. v .. '{\\1}/ge')
    end
    for k, v in pairs(both) do
        vim.api.nvim_command('%s/\\\\' .. k .. '\\(\\a\\)\\a\\@!/\\\\' .. v .. '{\\1}/ge')
    end
end

local buffer_to_string = function()
    local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    return table.concat(content, "\n")
end

--local table_invert = function(t)
--   local s={}
--   for k,v in pairs(t) do
--     s[v]=k
--   end
--   return s
--end


--tex_to_chr = {
--    alpha = 'α',
--    beta = 'β',
--    gamma = 'γ',
--    delta = 'δ',
----    epsilon = 'ϵ',
--    epsilon = 'ε',
----    varepsilon = 'ε',
--    zeta = 'ζ',
--    eta = 'η',
--    theta = 'θ',
----    vartheta = 'ϑ',
--    iota = 'ι',
--    kappa = 'κ',
--    lambda = 'λ',
--    mu = 'μ',
----    nu = 'ν', -- (upright) nu in Source Code Pro looks a lot like v
--    xi = 'ξ',
--    pi = 'π',
----    varpi = 'ϖ',
--    rho = 'ρ',
----    varrho = 'ϱ',
--    sigma = 'σ',
----    varsigma = 'ς',
--    tau = 'τ',
--    upsilon = 'υ',
----    phi = 'ϕ',
--    phi = 'φ',
----    varphi = 'φ',
----    chi = 'χ', -- very similar to X in Source Code Pro
--    psi = 'ψ',
--    omega = 'ω',
--    Gamma = 'Γ',
--    Delta = 'Δ',
--    Theta = 'Θ',
--    Lambda = 'Λ',
--    Xi = 'Ξ',
--    Pi = 'Π',
--    Sigma = 'Σ',
----    Upsilon = 'Υ', -- identical to Y in many fonts
--    Phi = 'Φ',
----    Chi = 'Χ', -- similar to X in many fonts
--    Psi = 'Ψ',
--    Omega = 'Ω',

--	subseteq = '⊆',
--	subset = '⊂',
--	nabla = '∇',
--	partial = '∂',
--	circ = '∘',
--	otimes = '⊗'
--}

--chr_to_tex = table_invert(tex_to_chr)



--function tr_read(str)
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

----function tr_write(path)
----    local str = strfer_to_string()

--function tr_write(str)
--    new = {}
--    new_i = 1
--    last = 0
--    j = 1
--    for c in str:gmatch('.') do
--        local c2t = chr_to_tex
--        sub = chr_to_tex[c]
--        print(c)
--        print(sub)
--        if sub ~= nil then
--            print('sub!')
--            if str:sub(j + 1, j + 1) and str:sub(j + 1, j + 1):match('%w') then
--                goto continue
--            end
--            new[new_i] = str:sub(last + 1, j - 1)
--            new[new_i + 1] = '\\' .. sub
--            new_i = new_i + 2
--            last = j
--        end
--        ::continue::
--        j = j + 1
--    end
--    new[new_i] = str:sub(last+1, j-1)
--    return table.concat(new, '')
--end

--function tr_write_py(str)
--	return 	vim.fn.py3eval('"' .. string.format("%q", str):gsub("\\\n", "\\n") .. '".translate({')
