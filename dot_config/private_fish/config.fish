if status is-interactive

    # --- Basic Settings ---
    set -g fish_greeting ""      # Disable welcome message
    stty -ixon                   # Disable terminal flow control (allows Ctrl+S)

    # --- Aliases ---
    # eza (Better ls)
    alias ls='eza -a --icons --color=always --no-user --hyperlink'
    alias lt='eza -a --tree --icons --color=always --no-user --hyperlink'
    alias lf='eza -A --tree --only-dirs --icons --color=always --no-user --hyperlink'
    alias lm='eza -lha --extended --total-size --sort=size --no-user --icons --color=always --changed --modified --created --hyperlink'
    alias ll='eza -lah --icons --color=always --hyperlink --no-user'

    # tmux
    alias tmatt='tmux attach -t'
    alias tmcrt='tmux new -s'
    alias tkill='tmux kill-server'
    alias tmls='tmux ls'
    alias tmdel='tmux kill-session -t'
    
    # Navigation
    alias ..='cd ..'
    alias ...='z ~'

    # git
    alias gs='git status'
    alias ga='git add .'
    alias gc='git commit -m'
    alias gp='git push'

    # System & Tools
    alias upd='sudo apt update -y'
    alias upg='sudo apt full-upgrade'
    alias cls='clear'
    alias cp='cp -i'
    alias refresh='source ~/.config/fish/config.fish'
    alias delete='sudo rm -rf'
    alias ins='sudo dpkg -i'
    alias is='intelli-shell'
    alias cs='gocheat'
    alias rmv='/home/kanashii/.cache.sh'
    alias matrix='unimatrix -a -b -c green -s 95 -l ckge'
    alias UNINSTALL='sudo apt autoremove --purge'
    alias zz='zee'
    alias conff='nvim ~/.config/fish/config.fish'
    alias nvi='nvidia-smi'
    alias tui='tuios'
    alias lv='nvim'
    alias mb='moonbit'
    alias ff='fastfetch'
    alias rgp='rg --hidden --files | fzf'
    alias pipes='pipes.sh'
    alias python='python3'
    alias mk='mkdir'
    alias tobash='chsh -s $(which bash); and echo "Log out and back in required."'
    alias tozsh='chsh -s $(which zsh); and echo "Log out and back in required."'
    
    # Process management
    alias psa="ps auxf"
    alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
    alias psmem='ps auxf | sort -nr -k 4'
    alias pscpu='ps auxf | sort -nr -k 3'
    alias df='df -h'
    alias free='free -m'
    alias grep='grep --color=auto'
    alias shellcheck='echo $argv[0]'

    # --- Environment Variables ---
    if type -q go
        set -gx GOPATH $(go env GOPATH)
    end

    set -gx LD_LIBRARY_PATH /usr/local/cuda-13.0/lib64 $LD_LIBRARY_PATH
    
    if test -x /usr/bin/lesspipe
        set -gx LESSOPEN "| /usr/bin/lesspipe %s"
        set -gx LESS -R
    end

    # SECURITY WARNING: Put your NEW key here. Do not use the one you posted online.
    set -gx GEMINI_API_KEY "AIzaSyCP1xNqqBdMOG_zPdiQl7nuHGNj9leC0_4"

    # --- Plugins & Integrations ---

    # Zoxide (Better cd)
    zoxide init fish | source

    # --- IntelliShell ---
    if type -q intelli-shell
        set -gx INTELLI_HOME "$HOME/.local/share/intelli-shell"
        
        # Load the tool
        intelli-shell init fish | source

        # FIX FOR FISH 4.0: Use 'ctrl-space' instead of '-k nul'
        # Apply the binding to Default Mode
        bind ctrl-space _intelli_search
        
        # Apply the binding to Insert Mode (Critical for typing)
        bind -M insert ctrl-space _intelli_search
    end

    # Conda
    if test -f "$HOME/Files/Anaconda/etc/profile.d/conda.sh"
        eval "$HOME/Files/Anaconda/bin/conda" "shell.fish" "hook" | source
        conda deactivate
    end

    # --- FZF Configuration ---
    # 1. Use 'fd' (from Homebrew/apt)
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND 'fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'

    # 2. Use 'bat' for previews
    set -g fzf_preview_file_cmd bat --style=numbers --color=always --line-range :500
    set -g fzf_preview_dir_cmd eza --all --tree --level=2 --color=always 

    # 3. Visual Styles
    set -gx FZF_DEFAULT_OPTS "
    --height=85%
    --layout=reverse
    --border=rounded
    --border-label=' FZF '
    --border-label-pos=top
    --info=inline
    --prompt='❯ '
    --marker='✓ '
    --pointer='▶ '
    --separator='─'
    --scrollbar='▐'
    --margin=2,1
    --padding=1,2
    --ansi
    "
    
    # 4. FORCE BINDINGS (This guarantees they work)
    fzf_configure_bindings --directory=\cf --git_log=\cg --git_status=\cs --history=\cr --variables=\cv --processes=\cp
end
