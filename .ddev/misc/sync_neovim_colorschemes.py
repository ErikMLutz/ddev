import os
import neovim

colorscheme = os.environ["PROFILE_NAME"]
if os.path.exists("/tmp/nvim"):
    nvim = neovim.attach("socket", path=f"/tmp/nvim")
    nvim.command(f":colorscheme base16-{colorscheme}")
