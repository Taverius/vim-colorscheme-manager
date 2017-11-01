" Vim plug-in
" Maintainer: Leonardo Valeri Manera <lvalerimanera@gmail.com>
" Last Change: June 26, 2014
" URL: http://github.com/Taverius/vim-colorscheme-manager

let g:colorscheme_manager#version = '0.0.7'

" Global variables
" Saving and loading of colorscheme from global
if !exists('g:colorscheme_switcher_exclude')
    let g:colorscheme_switcher_exclude = []
endif
if !exists('g:colorscheme_manager_global_last')
    let g:colorscheme_manager_global_last = 0
endif
if !exists('g:colorscheme_manager_shortlist')
    let g:colorscheme_manager_shortlist = []
endif
if !exists('g:ColorschemeManagerLast')
    let g:ColorschemeManagerLast = ''
endif
" Cycle forward or backward on blacklist current colorscheme
if !exists('g:colorscheme_manager_blacklist_direction')
    let g:colorscheme_manager_blacklist_direction = 1
endif
" Persistence file location
if !exists('g:colorscheme_manager_file')
    let g:colorscheme_manager_file = xolox#misc#os#is_win() ?
                \ '~/vimfiles/.colorscheme' :
                \ '~/.vim/.colorscheme'
endif


" Script variables
if !exists('s:data_loaded')
    let s:data_loaded = 0
endif
if !exists('s:data_file')
    let s:data_file = ''
endif
if !exists('s:data_default')
    let s:data_default = {'last': '', 'blacklist': [], 'shortlist': []}
endif



" Prune a list of nonexistent colorschemes, returning a clean list
" and a list of defunct colorschemes
function! s:prune_colorschemes(arg)
    " Abuse colorscheme-switcher to get the list of all colorschemes
    let l:excludes = g:colorscheme_switcher_exclude
    let g:colorscheme_switcher_exclude = []
    let l:all = xolox#colorscheme_switcher#find_names()
    let g:colorscheme_switcher_exclude = l:excludes

    let l:clean = []
    let l:defuncts = []

    " Filter argument
    for l:name in a:arg
        let l:keep = index(l:all, l:name) != -1

        if l:keep && index(l:clean, l:name) == -1
            call add(l:clean, l:name)
        elseif !l:keep && index(l:defuncts, l:name) == -1
            call add(l:defuncts, l:name)
        endif
    endfor

    " Sort them both
    call sort(l:clean, 1)
    call sort(l:defuncts, 1)

    return [l:clean, l:defuncts]
endfunction



" Return the filename used for persistence, and create the necessary
" directory structure if needed
function! colorscheme_manager#filename()
    let l:fname = expand(g:colorscheme_manager_file)
    let l:fpath = fnamemodify(l:fname, ":p:h")

    " Try to create directory if it does not exist
    if exists('*mkdir') && !isdirectory(l:fpath)
        try
            call mkdir(l:fpath, 'p')
        catch /^Vim\%((\a\+)\)\=:E739:/
            if filereadable(l:fpath) && !isdirectory(l:fpath)
                call xolox#misc#msg#warn(
                        \ 'colorscheme-manager.vim %s: Could not create directory %s for cache file %s because a file with the same exists. Please delete it.',
                        \ g:colorscheme_manager#version,
                        \ l:fpath,
                        \ fnamemodify(l:fname, ":p:t"))
            endif
        endtry
    endif
    return l:fname
endfunction



" Write persistent data
function! colorscheme_manager#write()
    let l:data = s:data_default

    " populate data
    let l:data['last'] = exists('g:colors_name') ? g:colors_name : ''
    let l:data['blacklist'] = exists('g:colorscheme_switcher_exclude') ? g:colorscheme_switcher_exclude : []
    let l:data['shortlist'] = exists('g:colorscheme_manager_shortlist') ? g:colorscheme_manager_shortlist : []

    " Write to last to global if enabled
    if g:colorscheme_manager_global_last
        let g:ColorschemeManagerLast = l:data['last']
    endif

    " write to file
    call xolox#misc#persist#save(s:data_file, l:data)
endfunction



" Read the last colorscheme and blacklist from file
function! colorscheme_manager#read()
    return xolox#misc#persist#load(s:data_file, s:data_default)
endfunction



" Check for the presence of a colorscheme in the blacklist
function! colorscheme_manager#check_blacklist(check_scheme)
    return index(g:colorscheme_switcher_exclude, a:check_scheme) >= 0 ? 1 : 0
endfunction



" Prune the blacklist of nonexistent colorschemes
function! colorscheme_manager#prune_blacklist()
    if exists('g:colorscheme_switcher_exclude') &&
                \ len(g:colorscheme_switcher_exclude)
        let l:blacklist = g:colorscheme_switcher_exclude
        let l:original_length = len(l:blacklist)
        let [blacklist, defuncts] = s:prune_colorschemes(l:blacklist)

        " If we pruned any, update the global blacklist, write file, and
        " message user
        if len(l:defuncts)
            let g:colorscheme_switcher_exclude = l:blacklist
            call colorscheme_manager#write()

            call xolox#misc#msg#info(
                        \ 'colorscheme-manager.vim %s: Pruned %s from blacklist (%i/%i)',
                        \ g:colorscheme_manager#version,
                        \ join(l:defuncts, ', '),
                        \ len(l:defuncts),
                        \ l:original_length)
        endif
    endif
endfunction



" Add the current colorscheme to the blacklist
function! colorscheme_manager#add_blacklist(...)
    let l:color = a:0 ? a:1 : ( exists('g:colors_name') ? g:colors_name : '' )
    " Check the variables exist, and that the scheme is not already in the
    " blacklist
    if strlen(l:color) &&
                \ exists('g:colorscheme_switcher_exclude') &&
                \ !colorscheme_manager#check_blacklist(l:color)

        " colorscheme-switcher will go back to the first scheme in the list if
        " the user cycles while on a blacklisted scheme. cycle once to prevent
        " this
        if l:color == g:colors_name
            call xolox#colorscheme_switcher#cycle(g:colorscheme_manager_blacklist_direction)
        endif

        " add colorscheme to blacklist and sort it
        call add(g:colorscheme_switcher_exclude, l:color)
        call sort(g:colorscheme_switcher_exclude, 1)

        " write the file
        call colorscheme_manager#write()

        " be nice and let the user know what happened
        call xolox#misc#msg#info(
                    \ 'colorscheme-manager.vim %s: Added color scheme %s to blacklist (%i/%i)',
                    \ g:colorscheme_manager#version,
                    \ l:color,
                    \ index(g:colorscheme_switcher_exclude, l:color) + 1,
                    \ len(g:colorscheme_switcher_exclude))
        return 1
    endif
    return 0
endfunction



" Remove the current colorscheme from the blacklist
function! colorscheme_manager#rem_blacklist(...)
    let l:color = a:0 ? a:1 : ( exists('g:colors_name') ? g:colors_name : '' )
    " Check the variables exist, and that the scheme is in the blacklist
    if strlen(l:color) &&
                \ exists('g:colorscheme_switcher_exclude') &&
                \ colorscheme_manager#check_blacklist(l:color)

        " Remove the colorscheme from the blacklist and sort it
        call filter(g:colorscheme_switcher_exclude, 'v:val != "'.l:color.'"')
        call sort(g:colorscheme_switcher_exclude, 1)

        " Write the file
        call colorscheme_manager#write()

        " Be nice and let the user know what happened
        call xolox#misc#msg#info(
                    \ 'colorscheme-manager.vim %s: Removed color scheme %s from blacklist (%i)',
                    \ g:colorscheme_manager#version,
                    \ l:color,
                    \ len(g:colorscheme_switcher_exclude))
        return 1
    endif
    return 0
endfunction



" Prune the shortlist of nonexistent colorschemes
function! colorscheme_manager#prune_shortlist()
    if exists('g:colorscheme_manager_shortlist') &&
                \ len(g:colorscheme_manager_shortlist)
        let l:shortlist = g:colorscheme_manager_shortlist
        let l:original_length = len(l:shortlist)
        let [shortlist, defuncts] = s:prune_colorschemes(l:shortlist)

        " If we pruned any, update the global shortlist, write file, and
        " message user
        if len(l:defuncts)
            let g:colorscheme_manager_shortlist = l:shortlist
            call colorscheme_manager#write()

            call xolox#misc#msg#info(
                        \ 'colorscheme-manager.vim %s: Pruned %s from shortlist (%i/%i)',
                        \ g:colorscheme_manager#version,
                        \ join(l:defuncts, ', '),
                        \ len(l:defuncts),
                        \ l:original_length)
        endif
    endif
endfunction



" Add the current colorscheme to the shortlist
function! colorscheme_manager#add_shortlist(...)
    let l:color = a:0 ? a:1 : ( exists('g:colors_name') ? g:colors_name : '' )
    " Check the variables exist, and that the scheme is not already in the
    " shortlist
    if strlen(l:color) &&
                \ exists('g:colorscheme_manager_shortlist') &&
                \ index(g:colorscheme_manager_shortlist, l:color) == -1

        " add colorscheme to shortlist and sort it
        call add(g:colorscheme_manager_shortlist, l:color)
        call sort(g:colorscheme_manager_shortlist, 1)

        " write the file
        call colorscheme_manager#write()

        " be nice and let the user know what happened
        call xolox#misc#msg#info(
                    \ 'colorscheme-manager.vim %s: Added color scheme %s to shortlist (%i/%i)',
                    \ g:colorscheme_manager#version,
                    \ l:color,
                    \ index(g:colorscheme_manager_shortlist, l:color) + 1,
                    \ len(g:colorscheme_manager_shortlist))
        return 1
    endif
    return 0
endfunction



" Remove the current colorscheme from the shortlist
function! colorscheme_manager#rem_shortlist(...)
    let l:color = a:0 ? a:1 : ( exists('g:colors_name') ? g:colors_name : '' )
    " Check the variables exist, and that the scheme is in the shortlist
    if strlen(l:color) &&
                \ exists('g:colorscheme_manager_shortlist') &&
                \ index(g:colorscheme_manager_shortlist, l:color) != -1

        " Remove the colorscheme from the shortlist and sort it
        call filter(g:colorscheme_manager_shortlist, 'v:val != "'.l:color.'"')
        call sort(g:colorscheme_manager_shortlist, 1)

        " Write the file
        call colorscheme_manager#write()

        " Be nice and let the user know what happened
        call xolox#misc#msg#info(
                    \ 'colorscheme-manager.vim %s: Removed color scheme %s from shortlist (%i)',
                    \ g:colorscheme_manager#version,
                    \ l:color,
                    \ len(g:colorscheme_switcher_exclude))
        return 1
    endif
    return 0
endfunction



" Pick a random colorscheme neither in the blacklist nor in the shortlist
function! colorscheme_manager#fresh_colorscheme()
    let l:excludes = g:colorscheme_switcher_exclude
    let g:colorscheme_switcher_exclude = g:colorscheme_switcher_exclude
                \ + g:colorscheme_manager_shortlist
    let l:choices = xolox#colorscheme_switcher#find_names()
    let g:colorscheme_switcher_exclude = l:excludes
    if exists('g:colors_name')
        call filter(choices, 'v:val != g:colors_name')
    endif
    call xolox#colorscheme_switcher#random_among(choices)
endfunction



" Initialize plugin state, load last colorscheme
function! colorscheme_manager#init()
    let l:data = s:data_default
    let l:last = ''

    " Load last from global if set to do so
    if g:colorscheme_manager_global_last
        let l:last = g:ColorschemeManagerLast
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

        " If the file's shortlist is not empty, load it
        if len(l:data['shortlist'])
            let g:colorscheme_manager_shortlist = l:data['shortlist']
        endif

        " We've read from the file, no need to do it again in this vim process
        let s:data_loaded = 1
    endif

    " Is the last scheme used non-empty?
    if strlen(l:last)
        " Get the list of non-blacklisted schemes
        let l:list = xolox#colorscheme_switcher#find_names()

        " Is the saved scheme not blacklisted?
        let l:last = !colorscheme_manager#check_blacklist(l:last) ? l:last : l:list[0]

        call xolox#colorscheme_switcher#switch_to(l:last)
    endif
endfunction

" vim: sw=4 et
