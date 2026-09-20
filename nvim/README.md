# Neovim

Requires Neovim 0.12+, Git, a C compiler, curl, tar, and tree-sitter CLI 0.26.1+
(install the CLI from your OS package manager or an upstream release, not npm).
Telescope live grep requires ripgrep; fd improves file finding. A Nerd Font
provides the status bar icons.

Run `:Lazy restore` after pulling these dotfiles to install the locked plugin
versions. Treesitter uses the rewritten `main` branch and automatically installs
the configured parsers, including TSX, JSON, and Markdown. Allow installation to
finish on first launch; `:TSUpdate` updates parsers after plugin changes.

Completion uses native Neovim snippets. Tab/Shift-Tab jump between snippet
placeholders, select completion entries when no snippet jump is available, and
otherwise retain their normal behavior. Filesystem path completion is available
in insert mode as well as the command line.

Undo history is saved across sessions. Space + F5 opens Undotree.

## Formatting

Files format before saving, with a two-second timeout. Conform uses Prettier for
web files, JSON, YAML, and Markdown; Ruff for Python; StyLua for Lua; shfmt for
shell; and gofmt for Go. Other supported languages fall back to their LSP's
formatter. Prettier prefers the project's `node_modules` executable, and the
formatters respect their project configuration files.

Mason automatically installs Prettier, Ruff, StyLua, and shfmt. Go's toolchain
must provide gofmt. Node/npm are needed for Prettier and several language servers.
Use `:MasonToolsInstall` to retry missing tools and `:ConformInfo` to inspect
formatter availability and logs.

- Space + f: format the buffer or visual selection, even without an LSP.
- `:FormatDisable`: disable automatic formatting for the session.
- `:FormatDisable!`: disable it only for the current buffer.
- `:FormatEnable`: re-enable it globally and for the current buffer.

## Git and surround editing

Gitsigns marks changed lines and adds these mappings inside Git-tracked files:

| Keys | Action |
| --- | --- |
| `]c` / `[c` | Next / previous change (retains native behavior in diff windows) |
| Space + hs | Stage/unstage a hunk; visual mode stages selected lines |
| Space + hp | Preview the current change |
| Space + hb | Show blame for the current line |
| Space + hd | Diff the file against the Git index |
| `ih` | Git hunk text object, e.g. `vih` to select it |

mini.surround uses its default mappings:

- `saiw"`: surround a word with double quotes.
- `sr"'`: replace surrounding double quotes with single quotes.
- `sd"`: delete surrounding double quotes.
- Select text, then `sa)`: surround the selection with parentheses.

These complement autopairs, which inserts closing delimiters while typing.
