# Color scheme manager for Vim

An add-on for [vim-colorscheme-switcher](https://github.com/xolox/vim-colorscheme-switcher).

More convenient blacklist management, automatically load the last used colorscheme on Vim start or session load, save the last colorscheme and blacklist to file using [tlib](https://github.com/tomtom/tlib_vim)

## Author
[Taverius](https://github.com/Taverius)

## Installation
Requires [vim-colorscheme-switcher](https://github.com/xolox/vim-colorscheme-switcher)[vim-colorscheme-switcher](https://github.com/xolox/vim-colorscheme-switcher), must be installed separately.

Requires [tlib](https://github.com/tomtom/tlib_vim), must be installed separately.

### Manually
1. Put all files under $VIM.

### [Pathogen](https://github.com/tpope/vim-pathogen)
1. Install with the following command.

        git clone https://github.com/Taverius/vim-colorscheme-manager ~/.vim/bundle/vim-colorscheme-manager

### [Vundle](https://github.com/gmarik/Vundle.vim)
1. Add the following configuration to your `.vimrc`.

        Plugin 'Taverius/vim-colorscheme-manager'

2. Install with `:PluginInstall`.

### [NeoBundle](https://github.com/Shougo/neobundle.vim)
1. Add the following configuration to your `.vimrc`.

        NeoBundle 'Taverius/vim-colorscheme-manager'

2. Install with `:NeoBundleInstall`.

## Commands

### The `:BlacklistAddColorScheme` command

Blacklist the current colorscheme and cycle forwards or backwards once. See `g:colorscheme_manager_blacklist_direction` below.

### The `:BlacklistRemColorScheme` command

Remove the current colorscheme from the blacklist.

### The `:BlacklistPruneColorScheme` command

Removes non-existent colorschemes from blacklist.

## Options

The colorscheme manager plug-in should work out of the box, but you can change the configuration defaults if you want to change how the plug-in works.

### The `g:colorscheme_manager_define_mappings` option

By default the plug-in maps the following keys in insert and normal mode:

- `Control-F8` to add the current colorscheme to the blacklist
- `Meta-F8` to remove the current colorscheme from the blacklist

To disable these mappings (e.g. because you're already using them for a different purpose) you can set the option `g:colorscheme_manager_define_mappings` to 0 (false) in your vimrc.

### The `g:colorscheme_manager_blacklist_direction` option

By default the plug-in cycles forward one colorscheme when adding the current to the blacklist.

By setting the option `g:colorscheme_manager_blacklist_direction` to 0 in your vimrc, it will instead cycle to the previous colorscheme upon blacklisting the current one.

### The `g:colorscheme_manager_global_last` option

By default the plug-in reads both blacklist and last colorscheme from file.

By setting the `g:colorscheme_manager_global_last` option to 1 in your vimrc, a global variable will - if non-empty - take precedence.

This might, for example, allow you to have different colorschemes for each session/project.


## License

Copyright (c) Leonardo Valeri Manera. Distributed under the same terms as Vim itself. See `:help license`.