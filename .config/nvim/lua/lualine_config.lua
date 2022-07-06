local custom_theme = require'lualine.themes.powerline_dark'
custom_theme.normal.c.fg = '#50EF70'
custom_theme.command.c.fg = '#50EF70'

custom_theme.normal.a.bg = '#EFF810'

custom_theme.inactive.a.fg = '#A0A0A0'
custom_theme.inactive.b.fg = '#A0A0A0'
custom_theme.inactive.c.fg = '#A0A0A0'

local function search_indicator()
    local s = vim.fn.getreg("/")
    local disp = ''
    if s == '' then return '%3p%%' end
    if string.len(s) <= 12 then
        disp = s
    else
        disp = string.sub(s, 1, 11) .. '…'
    end
    return '/' .. disp .. ' %3p%%'
end

local function modified()
  if vim.bo.modified then
    return '+'
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return '-'
  end
  return ''
end

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = custom_theme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{ 'filename', file_status = false, path = 1 }, {modified, color = {bg = '#FF4C51', fg='#FFFFFFF', gui = 'bold'}}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {search_indicator},
    --lualine_y = {'progress'}
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{ 'filename', file_status = true, path = 1 }},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fzf', 'fugitive'}
}
