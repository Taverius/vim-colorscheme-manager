# Color scheme manager for Vim

An add-on for [vim-colorscheme-switcher](http://github.com/xolox/vim-colorscheme-switcher).

* Convenience functions for managing the colorscheme blacklist.
* Automatically load last used colorscheme upon starting vim or (optionally) loading a session.
* Manage a shortlist of favorite colorschemes, including the ability to switch to a random colorscheme from the shortlist.
* Store last used colorscheme, blacklist, and shortlist on file.

## Author
[Taverius](http://github.com/Taverius)

## Installation
Requires [vim-colorscheme-switcher](http://github.com/xolox/vim-colorscheme-switcher), must be installed separately.

Requires [vim-misc](http://github.com/xolox/vim-misc), must be installed separately.

### Manually
1. Put all files under $VIM.

### [Pathogen](http://github.com/tpope/vim-pathogen)
1. Install with the following command.

   ```sh
   git clone https://github.com/Taverius/vim-colorscheme-manager ~/.vim/bundle/vim-colorscheme-manager
   ```

### [Dein.vim](https://github.com/Shougo/dein.vim)
1. Add the following configuration to your `.vimrc`.

   ```VimL
   call dein#add('Taverius/vim-colorscheme-manager')
   ```

2. Install with `:call dein#install()`.

### [vim-plug](https://github.com/junegunn/vim-plug)
1. Add the following configuration to your `.vimrc`.

   ```VimL
   Plug 'Taverius/vim-colorscheme-manager'
   ```

2. Install with `:PlugInstall`.

## Commands

### The `:BlacklistAddColorScheme` command

Blacklist the current colorscheme and cycle forwards or backwards once. See `g:colorscheme_manager_blacklist_direction` below.

Optionally, takes a colorscheme name as an argument, and operates on that instead of the current one.

### The `:BlacklistRemColorScheme` command

Remove the current colorscheme from the blacklist.

Optionally, takes a colorscheme name as an argument, and operates on that instead of the current one.

### The `:BlacklistPruneColorScheme` command

Remove non-existent (i.e. not in runtime path) colorschemes from the blacklist.

### The `:ShortlistAddColorScheme` command

Add the current colorscheme to the shortlist.

Optionally, takes a colorscheme name as an argument, and operates on that instead of the current one.

### The `:ShortlistRemColorScheme` command

Remove the current colorscheme from the shortlist.

Optionally, takes a colorscheme name as an argument, and operates on that instead of the current one.

### The `:ShortlistPruneColorScheme` command

Remove non-existent (i.e. not in runtime path) colorschemes from the shortlist.

### The `:ShortlistRandomColorScheme` command

Switch to a random colorscheme from the shortlist.

### The `:SwitchToColorScheme` command

Syntactic sugar for `xolox#colorscheme_switcher#switch_to(colorscheme)`, takes a colorscheme name as argument.

Useful for switching to a colorscheme you just installed with Vundle/NeoBundle/etc, or to use as custom command for a colorscheme browser - for example, [unite.vim](http://github.com/Shougo/unite.vim) with [unite-colorscheme](http://github.com/ujihisa/unite-colorscheme)

### The `:FreshColorScheme` command

Similar to `:RandomColorScheme` (from [vim-colorscheme-switcher](http://github.com/xolox/vim-colorscheme-switcher)), but switch to a random colorscheme that is neither in the blacklist nor in the shortlist.

## Options

The plug-in *should* work out of the box, but you can change the configuration defaults if you want to change how the plug-in works.

### The `g:colorscheme_manager_define_mappings` option

By default the plug-in maps the following keys in insert and normal mode:

- `F9` adds the current colorscheme to the blacklist
- `Shift-F9` removes the current colorscheme from the blacklist

To disable these mappings (e.g. because you're already using them for a different purpose) you can set the option `g:colorscheme_manager_define_mappings` to 0 (false) in your vimrc.

### The `g:colorscheme_manager_blacklist_direction` option

By default the plug-in cycles forward one colorscheme when adding the current one to the blacklist.

If you set this variable to 0 (false), it will instead cycle backwards.

### The `g:colorscheme_manager_global_last` option

By default the plug-in reads both blacklist and last colorscheme from file.

If you set this option to 1 (true) in your `vimrc`, a global variable will take precedence unless empty.

Together with vim sessions with the option to store global variables enabled, this allows you to have a different colorscheme for each vim session.

### The `g:ColorschemeManagerLast` option

This option is a string specifying the last the last used colorscheme.
It will be written to by the plug-in if `g:colorscheme_manager_global_last` is 1 (true).

If `sessionoptions` contains `globals`, `:mksession` will store this variable in the session file.

### The `g:colorscheme_manager_file` option

The filename the plug-in will write its persistence data to.

Defaults to:

* `~/vimfiles/.colorscheme` on windows.
* `~/.vim/.colorscheme` everywhere else.

Set this to your preferred value in your `vimrc` to override the location.

## License

Copyright (c) Leonardo Valeri Manera. Distributed under the same terms as Vim itself. See `:help license`.