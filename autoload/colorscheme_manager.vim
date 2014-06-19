" Vim plug-in
" Maintainer: Leonardo Valeri Manera <lvalerimanera@gmail.com>
" Last Change: June 19, 2014
" URL: http://github.com/Taverius/vim-colorscheme-manager

let g:colorscheme_manager#version = '0.0.2'



" Global name of last scheme loaded
" Used if g:colorscheme_manager_global_last = 1
if !exists('g:colorscheme_manager#last_scheme')
    let g:colorscheme_manager#last_scheme = ''
endif



" Script variables
if !exists('s:data_loaded')
    let s:data_loaded = 0
endif
if !exists('s:data_file')
    let s:data_file = ''
endif
if !exists('s:data_path')
    let s:data_path = 'colorscheme-manager'
endif
if !exists('s:data_type')
    let s:data_type = 'cache'
endif
if !exists('s:data_default')
    let s:data_default = { 'last': '', 'blacklist': []}
endif



" This function returns the filename used for persistence, and creates the
" necessary directory structure if needed
function! colorscheme_manager#filename()
    " get filename, and create directory if needed
    return tlib#persistent#Filename(s:data_path, s:data_type, 1)
endfunction



" This function writes the last colorscheme and blacklist to file
function! colorscheme_manager#write()
    " make sure the directory is present
    call colorscheme_manager#filename()

    let l:data = s:data_default

    " populate data
    let l:data['last'] = exists('g:colors_name') ? g:colors_name : ''
    let l:data['blacklist'] = exists('g:colorscheme_switcher_exclude') ? g:colorscheme_switcher_exclude : []

    " write to file
    call tlib#persistent#Save(s:data_file, l:data)
endfunction



" This function reads the last colorscheme and blacklist from file
function! colorscheme_manager#read()
    return tlib#persistent#Get(s:data_file, s:data_default)
endfunction



" This function checks for the presence of a colorscheme in the blacklist
" Its used internally, but can also be used in statusline, I guess?
function! colorscheme_manager#check_blacklist(check_scheme)
    return index(g:colorscheme_switcher_exclude, a:check_scheme) >= 0 ? 1 : 0
endfunction



" This function adds the current colorscheme to the blacklist
function! colorscheme_manager#add_blacklist()
    " Check the variables exist, and that the scheme is not already in the
    " blacklist
    if exists('g:colors_name') \
        && exists('g:colorscheme_switcher_exclude') \
        && !colorscheme_manager#check_blacklist(g:colors_name)

        " colorscheme-switcher will go back to the first scheme in the list if
        " the user cycles while on a blacklisted scheme. store the current
        " scheme name and cycle once to prevent this
        let l:prev_name = g:colors_name
        call xolox#colorscheme_switcher#cycle(g:colorscheme_manager_blacklist_direction)

        " add colorscheme to blacklist and sort it
        call add(g:colorscheme_switcher_exclude, l:prev_name)
        call sort(g:colorscheme_switcher_exclude)

        " write the file
        call colorscheme_manager#write()

        " be nice and let the user know what happened
        call xolox#misc#msg#info('colorscheme-manager.vim %s: Added color scheme %s to blacklist (%i/%i)', g:colorscheme_manager#version, l:prev_name, index(g:colorscheme_switcher_exclude, l:prev_name) + 1, len(g:colorscheme_switcher_exclude))
    endif
endfunction



" This function removes the current colorscheme from the blacklist
function! colorscheme_manager#rem_blacklist()
    " Check the variables exist, and that the scheme is in the blacklist
    if exists('g:colors_name') \
        && exists('g:colorscheme_switcher_exclude') \
        && colorscheme_manager#check_blacklist(g:colors_name)

        " Remove the colorscheme from the blacklist and sort it
        call tlib#list#RemoveAll(g:colorscheme_switcher_exclude, g:colors_name)
        call sort(g:colorscheme_switcher_exclude)

        " Write the file
        call colorscheme_manager#write()

        " Be nice and let the user know what happened
        call xolox#misc#msg#info('colorscheme-manager.vim %s: Removed color scheme %s to blacklist (%i)', g:colorscheme_manager#version, g:colors_name, len(g:colorscheme_switcher_exclude))
    endif
endfunction



" This function loads a given colorscheme, with all the bells and whistles
" from vim-colorscheme-switcher
" :def: function! colorscheme_manager#load(colorscheme, ?filter=0)
function! colorscheme_manager#load(scheme, ...)
    let l:filter = a:0 >= 1 ? a:1 : 0

    if l:filter
        " Get the list of non-blacklisted schemes
        let l:list = xolox#colorscheme_switcher#find_names()

        " Is the saved scheme not blacklisted?
        let l:color = !colorscheme_manager#check_blacklist(a:scheme) ? a:scheme : l:list[0]
    else
        let l:color = a:scheme
    endif

    " Save highlight group links
    " Check for existing colorscheme name, since this may be called on vim
    " start
    if exists('g:colors_name')
        let l:links = 1
        call xolox#colorscheme_switcher#find_links()
    endif

    " Enable it
    execute 'colorscheme' fnameescape(l:color)

    " Restore highlight group links
    if exists('l:links')
        call xolox#colorscheme_switcher#restore_links()
    endif

    " Store the name
    let g:colors_name = l:color
    let g:colorscheme_manager#last_scheme = l:color

    " Run autocommands
    silent execute 'doautocmd ColorScheme' fnameescape(l:color)
endfunction



" This function is called at vim start or when loading a session, and takes
" care of initial setup and switching to the last used colorscheme
function! colorscheme_manager#init()
    let l:data = s:data_default
    let l:last = ''

    " Load last from global if set to do so
    if g:colorscheme_manager_global_last
        let l:last = g:colorscheme_manager#last_scheme
    endif

    " Read from file
    if s:data_loaded == 0
        let s:data_file = colorscheme_manager#filename()
        let l:data = colorscheme_manager#read()

        " If the file's blacklist is not empty, load it
        if len(l:data['blacklist'])
            let g:colorscheme_switcher_exclude = l:data['blacklist']
        endif

        " If not set to load from last, or last is empty, load from file
        if !g:colorscheme_manager_global_last || !strlen(l:last)
            let l:last = l:data['last']
        endif

        " We've read from the file, no need to do it again in this vim process
        let s:data_loaded = 1
    endif

    " Is the last scheme used non-empty?
    if strlen(l:last)
        call colorscheme_manager#load(l:last, 1)
    endif
endfunction

" vim: ts=4 sw=4
