# tool_nudges

A fish shell system that teaches you modern CLI tools by showing random tips on startup and gentle nudges when you use old commands.

## What it does

- **Startup tips**: Each new shell shows a random tool tip from the database
- **Old-command nudges**: Wrapper functions for `find`, `ls`, `cat`, `grep`, `sed`, `top`, `du`, and `curl` suggest modern replacements (once per session, on stderr only)
- **`new_tools` command**: Pretty-prints the full tool catalog

## Setup

```sh
./setup.sh
```

The setup script will:
1. Symlink the fish config files into place
2. Optionally install all the tools via Homebrew

## Files

| File | Purpose |
|------|---------|
| `new_tools.yaml` | Tool database (name, replaces, description, examples) |
| `new_tools_reminder.fish` | Startup tips + old-command wrapper functions |
| `new_tools.fish` | `new_tools` catalog command |
| `setup.sh` | Symlinks + optional tool installation |
| `uninstall.sh` | Removes fish symlinks (does not uninstall tools) |

## Tools included

| Tool | Replaces | Description |
|------|----------|-------------|
| fd | find | Modern find with intuitive syntax |
| eza | ls | ls with git status, tree view, colors |
| bat | cat | Syntax highlighting and line numbers |
| zoxide | cd | Smarter cd that learns your directories |
| rg | grep | Blazing fast grep |
| fzf | — | Fuzzy finder for everything |
| sd | sed | Simpler find-and-replace |
| xsv | — | Fast CSV toolkit |
| delta | — | Beautiful git diffs |
| lazygit | — | Terminal UI for git |
| btop | top | Beautiful system monitor |
| dust | du | Intuitive disk usage viewer |
| hyperfine | — | CLI benchmarking |
| http | curl | Friendlier API testing (httpie) |
| curlie | — | curl with httpie's readability |

## Uninstall

```sh
./uninstall.sh
```

This removes the fish symlinks. It does not uninstall any Homebrew packages.
