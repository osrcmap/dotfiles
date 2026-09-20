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
