import os
import neovim

if os.path.exists("/tmp/nvim"):
    nvim = neovim.attach("socket", path=f"/tmp/nvim")

    # Set theme environment variables
    for i in range(1, 23):
        color = os.environ[f"COLOR_{i:02}"]
        nvim.command(f":let $COLOR_{i:02}='{color}'")

    color = os.environ[f"BACKGROUND_COLOR"]
    nvim.command(f":let $BACKGROUND_COLOR='{color}'")

    color = os.environ[f"FOREGROUND_COLOR"]
    nvim.command(f":let $FOREGROUND_COLOR='{color}'")

    # reload colorscheme
    colorscheme = os.environ["PROFILE_NAME"]
    nvim.command(f":colorscheme base16-{colorscheme}")

    # reload lightline
    nvim.command(":LightlineReload")
