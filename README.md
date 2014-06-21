# Color scheme manager for Vim

An add-on for [vim-colorscheme-switcher](https://github.com/xolox/vim-colorscheme-switcher).

* Convenience functions for managing the colorscheme blacklist.
* Automatically load last used colorscheme upon starting vim or (optionally) loading a session.
* Store last used colorscheme and blacklist on file, using [tlib](https://github.com/tomtom/tlib_vim).

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

        NeoBundle 'Taverius/vim-colorscheme-manager', {
							\ 'depends': [
							\	'tomtom/tlib_vim',
							\	'xolox/vim-colorscheme-switcher'
							\ ]}

2. Install with `:NeoBundleInstall`.

## Commands

### The `:BlacklistAddColorScheme` command

Blacklist the current colorscheme and cycle forwards or backwards once. See `g:colorscheme_manager_blacklist_direction` below.

Optionally, takes a colorscheme name as an argument, and operates on that instead of the current one.

### The `:BlacklistRemColorScheme` command

Remove the current colorscheme from the blacklist.

Optionally, takes a colorscheme name as an argument, and operates on that instead of the current one.

### The `:BlacklistPruneColorScheme` command

Removes non-existent colorschemes from blacklist.

### The `:SwitchToColorScheme` command

Syntactic sugar for `xolox#colorscheme_switcher#switch_to(colorscheme)`, takes a colorscheme name as argument.

Useful for switching to a colorscheme you just installed with Vundle/NeoBundle/etc, or to use as custom command for a colorscheme browser - for example, [unite.vim](https://github.com/Shougo/unite.vim) with [unite-colorscheme](https://github.com/ujihisa/unite-colorscheme)

## Options

The plug-in *should* work out of the box, but you can change the configuration defaults if you want to change how the plug-in works.

### The `g:colorscheme_manager_define_mappings` option

By default the plug-in maps the following keys in insert and normal mode:

- `F9` to add the current colorscheme to the blacklist
- `Shift-F9` to remove the current colorscheme from the blacklist

To disable these mappings (e.g. because you're already using them for a different purpose) you can set the option `g:colorscheme_manager_define_mappings` to 0 (false) in your vimrc.

### The `g:colorscheme_manager_blacklist_direction` option

By default the plug-in cycles forward one colorscheme when adding the current to the blacklist.

By setting the option `g:colorscheme_manager_blacklist_direction` to 0 in your vimrc, it will instead cycle to the previous colorscheme upon blacklisting the current one.

### The `g:colorscheme_manager_global_last` option

By default the plug-in reads both blacklist and last colorscheme from file.

By setting the `g:colorscheme_manager_global_last` option to 1 in your vimrc, a global variable will take precedence unless empty.

Together with vim sessions with the option to store global variables enabled, this allows you to have a different colorscheme for each vim session.

### The `g:ColorschemeManagerLast` String

This is where the last used colorscheme is saved if `g:colorscheme_manager_global_last` is 1.

Will be saved in vim sessions if `sessionoptions` contains `globals`.


## License

Copyright (c) Leonardo Valeri Manera. Distributed under the same terms as Vim itself. See `:help license`.