Oracle JDK is in

  /usr/local/java/jdk/bin/


https://askubuntu.com/questions/982112/how-can-i-disable-snaps-in-gnome-software-centre

disabled snapd with
`systemctl disable snapd`
`systemctl disable snapd.socket`
`systemctl disable snapd.autoimport.service snapd.core-fixup.service snapd.seeded.service snapd.snap-repair.timer snapd.system-shutdown.service`

custom scripts in `~/bin`, "startup applications"

### Settings files
- `.inputrc` readline settings
- `.bashrc` bash settings (also imports other files `.bash_inputrc`, `.tmux_completion`, etc.)
- `.vimrc` vim settings
- `.profile` more shell settings
- `.bash_profile`
- `.xbindkeysrc` custom keyboard shortcuts
- `.tmux.conf` tmux config
- `.config/redshift.conf`
- sudoers file (get with visudo)
- maybe `/etc/profile` (some old Java hacks apparently)
- `/usr/share/texlive/texmf.cnf` (more memory, update with `sudo fmtutil-sys --all`)

Caps Lock remapped to Escape
Shift + Escape does Caps Lock

### fbterm
- modified `.bash_login`
- settings in `fbtermrc`
- `sudo gpasswd -a YOUR_USERNAME video` so that non-root can run fbterm
- `sudo setcap 'cap_sys_tty_config+ep' $(which fbterm)`
- copy contents of `/usr/share/terminfo/` to `/lib/terminfo`

### vim
- using neovim
- config in ~/.config/nvim/init.vim (filetype `.zsh-theme`)

### other config commands
- `sudo dpkg --add-architecture i386` ?

### zsh
- `.zshrc`, `.oh-my-zsh/themes/custom.zsh-theme`, many more files modified
- also in /root/

### firefox
- custom stuff and stuff from inet in userchrome

### python
- numpy
  + custom-compiled, enable **MKL** (in `/opt/intel`)


## manually installed
- bat (cat clone)
- fd (find clone)
- fzf
- diff-so-fancy (manually downloaded to `/usr/local/bin/`, `git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"` to use in git)

## Packages
- `librsvg2-bin` for converting SVGs to PDFs 
- `pdf2svg` for converting PDFs to SVGs
### kernel stuff
- replace `wpa_supplicant` by `iwd`
