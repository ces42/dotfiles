#!/usr/bin/python3
import re, vim

# def read_dict(file):
#     with open(file) as f:
#         for line in f:
#             if not line[:-1] or line.startswith('#'): continue
#             char, tex = line[:-1].split(' ')
#             chr_to_tex[char] = '\\' + tex
#             # HAS_BAR |= (tex == '|')

def tr_write(s):
    new = []
    last_pos = 0
    for match in re.finditer(cmp, s):
        new.append(s[last_pos : match.start()])
        new.append(chr_to_tex[match.group(0)])
        last_pos = match.end()
    new.append(s[last_pos :])
    return ''.join(new)

# chr_to_tex = vim.lua.require('tr_tex_chr').chr_to_tex
chr_to_tex = vim.exec_lua("return require('tr_tex_chr').chr_to_tex")
cmp = re.compile(
        '(' +
        # '|'.join(chr(c) + '(?![a-zA-Z])'*v.isalpha() for c, v in chr_to_tex.items())
        '|'.join(c + '(?![a-zA-Z])'*cmd.isalpha() for c, cmd in chr_to_tex.items())
        + ')'
)

backup_buffer = []

def tr_change_buffer():
    # fmt = fmt or vim.eval('&fileformat')
    # if fmt == 'unix':
    #     end = '\n'
    # elif fmt == 'dos':
    #     end = '\r\n'
    # else:
    #     end = '\r'

    global backup_buffer
    backup_buffer = vim.api.buf_get_lines(0, 0, -1, 1)
    vim.api.buf_set_lines(0, 0, -1, 1, list(map(tr_write, backup_buffer)))

def tr_restore_buffer():
    import vim
    global backup_buffer
    vim.api.buf_set_lines(0, 0, -1, 1, backup_buffer)
    backup_buffer = []

def tr_write_buffer(path):
    path = path.replace(r'\ ', ' ')
    import vim
    fmt = vim.api.eval('&fileformat')
    if fmt == 'unix':
        end = '\n'
    elif fmt == 'dos':
        end = '\r\n'
    else:
        end = '\r'

    with open(path, 'w+') as f:
        buffer = end.join(vim.api.buf_get_lines(0, 0, -1, 1))
        f.write(tr_write(buffer))

def tr_write_file(path):
    path = path.replace(r'\ ', ' ')
    import vim
    fmt = vim.eval('&fileformat')
    if fmt == 'unix':
        end = '\n'
    elif fmt == 'dos':
        end = '\r\n'
    else:
        end = '\r'

    with open(path, 'w+') as f:
        b = vim.current.buffer
        buffer = end.join(vim.api.buf_get_lines(0, b.mark('[')[0] - 1, b.mark(']')[0], 1))
        f.write(tr_write(buffer))

if __name__ == '__main__':
    import sys
    inpt = sys.stdin.read()
    print(tr_write(inpt), end='')
