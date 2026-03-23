# tool_nudges

A fish shell plugin that nudges the user toward modern CLI tools.

## Architecture

- `new_tools.yaml` — flat YAML database of tools. Parsed with fish `string replace/match` (no external YAML parser).
- `new_tools_reminder.fish` — sourced via `conf.d/` symlink. Handles startup tips and defines wrapper functions for old commands. Nudges go to stderr and fire once per session per tool.
- `new_tools.fish` — autoloaded via `functions/` symlink. The `new_tools` command pretty-prints the catalog.
- `setup.sh` — creates symlinks and optionally installs tools via Homebrew.

## Conventions

- Tool names in the YAML must match what you'd type in the shell (e.g. `rg` not `ripgrep`, `http` not `httpie`).
- Brew package names differ from CLI names for some tools — the mapping lives in `setup.sh`.
- Wrapper functions use `command` to call the real binary and avoid recursion.
