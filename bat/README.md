# [Bat](https://github.com/sharkdp/bat)

Like `cat`, but on steroids.

To use the config file, a environment variable needs to be set ([official docs](https://github.com/sharkdp/bat#configuration-file)).

Add `BAT_CONFIG_PATH` with the value `~/.dotfiles/bat/bat.conf`.

To easily preview themes, execute `bat --list-themes | fzf --preview="bat --theme={} --color=always path/to/some-file"`
