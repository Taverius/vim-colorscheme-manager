" Vim plug-in
" Maintainer: Leonardo Valeri Manera <lvalerimanera@gmail.com>
" Last Change: June 26, 2014
" URL: http://github.com/Taverius/vim-colorscheme-manager

" Easy(er) management of the vim-colorscheme-switcher blacklist, automatic
" loading of last used colorscheme on vim enter, on-file persistence of
" blacklist and last colorscheme.
" Still pretty minimalist.

if &cp || exists('g:loaded_colorscheme_manager') || version < 700 || ! has('autocmd')
    finish
endif

" Make sure vim-misc is installed.
try
    call type(g:xolox#misc#version)
catch
    echomsg "Warning: The vim-colorscheme-manager plug-in requires the vim-misc plug-in which seems not to be installed! For more information please review the installation instructions in the readme (also available on the homepage and on GitHub). The vim-colorscheme-switcher plug-in will now be disabled."
    let g:loaded_colorscheme_manager = -1
    finish
endtry

" Make sure vim-colorscheme-switcher is installed
try
    call type(g:xolox#colorscheme_switcher#version)
catch
    echomsg "Warning: The vim-colorscheme-manager plug-in requires the vim-colorscheme-switcher plug-in which seems not to be installed! For more information please review the installation instructions in the readme (also available on Github). The vim-colorscheme-manager plug-in will now be disabled."
    let g:loaded_colorscheme_manager = -1
    finish
endtry



" You can set this variable to 0 (false) in your vimrc script to disable the
" default mappings (Shift/Meta-F8 in insert and normal mode).
if !exists('g:colorscheme_manager_define_mappings')
    let g:colorscheme_manager_define_mappings = 1
endif

if !exists('g:colorscheme_manager_remember_background')
    let g:colorscheme_manager_remember_background = 0
endif

" Define maps unless disabled
if g:colorscheme_manager_define_mappings
    inoremap <silent> <F9> <C-O>:BlacklistAddColorScheme<CR>
    nnoremap <silent> <F9> :BlacklistAddColorScheme<CR>
    inoremap <silent> <S-F9> <C-O>:BlacklistRemColorScheme<CR>
    nnoremap <silent> <S-F9> :BlacklistRemColorScheme<CR>
endif



" Define commands
command! -bar -nargs=? -complete=color
            \ BlacklistAddColorScheme call colorscheme_manager#add_blacklist(<f-args>)
command! -bar -nargs=? -complete=color
            \ BlacklistRemColorScheme call colorscheme_manager#rem_blacklist(<f-args>)
command! BlacklistPruneColorScheme call colorscheme_manager#prune_blacklist()
command! -nargs=1 -complete=color
            \ SwitchToColorScheme call xolox#colorscheme_switcher#switch_to(<f-args>)



" Set autocommands
augroup ColorschemeManager
    autocmd!
    autocmd VimEnter * call colorscheme_manager#init()
    autocmd ColorScheme * call colorscheme_manager#write()
augroup END
if has('mksession')
    augroup ColorschemeManager
        autocmd SessionLoadPost * call colorscheme_manager#init()
    augroup END
endif

" Loaded, don't do it again
let g:loaded_colorscheme_manager = 1

" vim: sw=4 et
