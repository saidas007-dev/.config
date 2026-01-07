# config.nu
# Version: 0.109.1

# --- Setup Zoxide ---
if not ("~/.config/nushell/zoxide.nu" | path exists) {
    zoxide init nushell | save -f ~/.config/nushell/zoxide.nu
}
source ~/.config/nushell/zoxide.nu

# --- Setup Starship Prompt ---
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "
$env.config.show_banner = false

# --- Aliases (Simple Replacements) ---

# eza
alias ezl = eza --icons --color=always --hyperlink
alias ezd = eza  -lha  --extended --total-size --no-user --icons=always --changed --modified --created --hyperlink
alias ezt = eza --tree --icons --color=always --hyperlink
alias ezf = eza -A --tree --only-dirs --icons --color=always --hyperlink
#alias  lm = ls -a -d -l | select  mode name size type



# tmux
alias tmatt = tmux attach -t
alias tmcrt = tmux new -s
alias tkill = tmux kill-server
alias tmls = tmux ls
alias tmdel = tmux kill-session -t

# Navigation
alias .. = cd ..
alias ... = z ~

# git
alias gs = git status
alias ga = git add .
alias gc = git commit -m
alias gp = git push

# System
alias upd = sudo apt update -y
alias upg = sudo apt full-upgrade
alias cls = clear
# Use ^ to prevent recursion on internal commands
alias cp = ^cp -i
alias delete = sudo rm -rf
alias ins = sudo dpkg -i
alias is = intelli-shell
alias cs = gocheat
alias rmv = /home/kanashii/.cache.sh
alias matrix = unimatrix -a -b -c green -s 95 -l ckge
alias UNINSTALL = sudo apt autoremove --purge
alias zz = zee
alias conff = nvim .config/nushell/config.nu
alias nvi = nvidia-smi
alias tui = tuios
alias lv = nvim
alias mb = moonbit
alias ff = fastfetch
alias pipes = pipes.sh
alias python = python3
alias mk = mkdir
alias ms = echo $nu.current-exe

# Shell Switching (Fixed to use $env.USER)
alias tobash = chsh $env.USER -s /bin/bash
alias tozsh = chsh $env.USER -s /bin/zsh 
alias tofish = chsh $env.USER -s /bin/fish 

# External Commands (Fixed with ^ to avoid Nushell built-ins)
alias psa = ^ps auxf
alias df = ^df -h
alias free = ^free -m
alias grep = ^grep --color=auto

$env.PATH = ($env.PATH | split row (char esep) | append '/home/kanashii/.local/share/intelli-shell/bin')
mkdir ($nu.data-dir | path join "vendor/autoload")
intelli-shell init nushell | save -f ($nu.data-dir | path join "vendor/autoload/intelli-shell.nu")


# --- Custom Commands (Replacements for Aliases with Pipes) ---



# "refresh" reloads the shell
def refresh [] { exec nu }

def ll [] {
  ls -a -d -l | select mode name size type
}


# rgp: search with ripgrep and feed into fzf
def rgp [] { 
    rg --hidden --files | fzf 
}

# psgrep: grep processes (uses ^ps and ^grep to avoid Nu built-ins)
def psgrep [pattern: string] {
    ^ps aux | ^grep -v grep | ^grep -i -e VSZ -e $pattern
}

# psmem: sort processes by memory (uses ^ps and ^sort)
def psmem [] { 
    ^ps auxf | ^sort -nr -k 4 
}

# pscpu: sort processes by CPU (uses ^ps and ^sort)
def pscpu [] { 
    ^ps auxf | ^sort -nr -k 3 
}
