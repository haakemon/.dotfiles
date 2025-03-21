# Dotfiles

![dotfiles as imagined by DALL-E](dotfiles.webp)

> [!NOTE]
> The `~` or `$HOME` is used to denote your home directory. On Windows this will typically be at `C:\Users\[YOUR_USERNAME]\`. On Linux this will typically be at `/home/[YOUR_USERNAME]/`.

> [!WARNING]
> Some parts of these files and scripts may expect the repo to be cloned to `~/.dotfiles`. Cloning it anywhere else could lead to some stuff not working as expected.

This repo is setup with [`pre-commit`](https://pre-commit.com/#intro), so to ensure hooks are correctly set up, you should execute `pre-commit install`.

Dont forget to add a Github PAT to `~/.config/nix/nix.conf`, see <https://nix.dev/manual/nix/2.24/command-ref/conf-file.html>

```sh
access-tokens = github.com=***PAT***
```
