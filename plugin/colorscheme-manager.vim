" Vim plug-in
" Maintainer: Leonardo Valeri Manera <lvalerimanera@gmail.com>
" Last Change: June 17, 2014
" URL: http://github.com/Taverius/vim-colorscheme-manager

" Easy(er) management of the vim-colorscheme-switcher blacklist, automatic
" loading of last used colorscheme on vim enter, on-file persistence of
" blacklist and llast colorscheme.
" Still pretty minimalist.

if &cp || exists('g:loaded_colorscheme_manager') || version < 700 || ! has('autocmd')
    finish
endif

" Make sure vim-colorscheme-switcher is installed
try
    call type(g:xolox#colorscheme_switcher#version)
catch
    echomsg "Warning: The vim-colorscheme-manager plug-in requires the vim-colorscheme-switcher plug-in which seems not to be installed! For more information please review the installation instructions in the readme (also available on Github). The vim-colorscheme-manager plug-in will now be disabled."
    let g:loaded_colorscheme_manager = -1
    finish
endtry

" Make sure tlib is installed
try
    call type(g:tlib#debug)
catch
    echoerr 'Warning: The vim-colorscheme-manager plug-in requires the tlib plug-in which seems not to be installed! For more information please review the installation instructions in the readme (also available on Github). The vim-colorscheme-manager plug-in will now be disabled.'
    let g:loaded_colorscheme_manager = -1
    finish
endtry



" Set autocommands
augroup ColorschemeManager
    autocmd!
    autocmd VimEnter * call colorscheme_manager#init()
    autocmd ColorScheme * call colorscheme_manager#write()
augroup end
if has('mksession')
    augroup ColorschemeManager
        autocmd SessionLoadPost * call colorscheme_manager#init()
    augroup end
endif



" Set this to 1 to use a global variable for storing the last colorscheme
" instead of the file. Lets you store the last colorscheme on a per-session
" basis
if !exists('g:colorscheme_manager_global_last')
    let g:colorscheme_manager_global_last = 0
endif



" Set this to 0 to cycle backwards when adding the current colorscheme to the
" blacklist, rather than forwards
if !exists('g:colorscheme_manager_blacklist_direction')
    let g:colorscheme_manager_blacklist_direction = 1
endif



" You can set this variable to 0 (false) in your vimrc script to disable the
" default mappings (Shift/Meta-F8 in insert and normal mode).
if !exists('g:colorscheme_manager_define_mappings')
    let g:colorscheme_manager_define_mappings = 1
endif



" Define maps unless disabled
if g:colorscheme_manager_define_mappings
    inoremap <silent> <C-F8> <C-O>:BlacklistAddColorScheme<CR>
    nnoremap <silent> <C-F8> :BlacklistAddColorScheme<CR>
    inoremap <silent> <M-F8> <C-O>:BlacklistRemColorScheme<CR>
    nnoremap <silent> <M-F8> :BlacklistRemColorScheme<CR>
endif



" Define commands
command! -bar -bang BlacklistAddColorScheme call colorscheme_manager#add_blacklist()
command! -bar -bang BlacklistRemColorScheme call colorscheme_manager#rem_blacklist()



" Loaded, don't do it again
let g:loaded_colorscheme_manager = g:colorscheme_manager#version

" vim: ts=4 sw=4
