# ---- PATH ----
$env.PATH = (
  $env.PATH
  | prepend [
    $"($env.HOME)/.cargo/bin"
    $"($env.HOME)/.local/bin"
    "/usr/local/go/bin"
    "/usr/local/cuda/bin"
    $"($env.HOME)/.fzf/bin"
  ]
)

# ---- History ----
$env.HISTFILE = $"($env.HOME)/.local/share/nushell/history.txt"

# ---- Editor ----
$env.EDITOR = "nvim"

# ---- CUDA ----
$env.LD_LIBRARY_PATH = "/usr/local/cuda/lib64"

# ---- Homebrew ----
let brew_prefix = "/home/linuxbrew/.linuxbrew"

$env.PATH = (
  $env.PATH
  | prepend [
    $"($brew_prefix)/bin"
    $"($brew_prefix)/sbin"
  ]
)

# ---- Gemini API Key ----
$env.GEMINI_API_KEY = "AIzaSyCP1xNqqBdMOG_zPdiQl7nuHGNj9leC0_4"

