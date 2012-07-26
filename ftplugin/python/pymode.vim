if pymode#Default('b:pymode', 1)
    finish
endif


" Parse pymode modeline
call pymode#Modeline()


" Syntax highlight
if pymode#Option('syntax')
    let python_highlight_all=1
endif


" Options {{{

" Python indent options
if pymode#Option('options_indent')
    setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
    setlocal cindent
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
    setlocal shiftround
    setlocal smartindent
    setlocal smarttab
    setlocal expandtab
    setlocal autoindent
endif

" Python other options
if pymode#Option('options_other')
    setlocal complete+=t
    setlocal formatoptions-=t
    if v:version > 702 && !&relativenumber
        setlocal number
    endif
    setlocal nowrap
    setlocal textwidth=79
endif

" }}}


" Documentation {{{

if pymode#Option('doc')

    " DESC: Set commands
    command! -buffer -nargs=1 Pydoc call pymode#doc#Show("<args>")

    " DESC: Set keys
    exe "nnoremap <silent> <buffer> " g:pymode_doc_key ":call pymode#doc#Show(expand('<cword>'))<CR>"
    exe "vnoremap <silent> <buffer> " g:pymode_doc_key ":<C-U>call pymode#doc#Show(@*)<CR>"

endif

" }}}


" Lint {{{

if pymode#Option('lint')

    let b:qf_list = []

    " DESC: Set commands
    command! -buffer -nargs=0 PyLintToggle :call pymode#lint#Toggle()
    command! -buffer -nargs=0 PyLintWindowToggle :call pymode#lint#ToggleWindow()
    command! -buffer -nargs=0 PyLintCheckerToggle :call pymode#lint#ToggleChecker()
    command! -buffer -nargs=0 PyLint :call pymode#lint#Check()

    " DESC: Set autocommands
    if pymode#Option('lint_write')
        au BufWritePost <buffer> PyLint
    endif

    if pymode#Option('lint_onfly')
        au InsertLeave <buffer> PyLint
    endif

    if pymode#Option('lint_message')

        " DESC: Show message flag
        let b:show_message = 0

        " DESC: Errors dict
        let b:errors = {}

        au CursorHold <buffer> call pymode#lint#show_errormessage()
        au CursorMoved <buffer> call pymode#lint#show_errormessage()

    endif

endif

" }}}


" Rope {{{

if pymode#Option('rope')

    " DESC: Set keys
    exe "noremap <silent> <buffer> " . g:pymode_rope_short_prefix . "g :RopeGotoDefinition<CR>"
    exe "noremap <silent> <buffer> " . g:pymode_rope_short_prefix . "d :RopeShowDoc<CR>"
    exe "noremap <silent> <buffer> " . g:pymode_rope_short_prefix . "f :RopeFindOccurrences<CR>"
    exe "noremap <silent> <buffer> " . g:pymode_rope_short_prefix . "m :emenu Rope . <TAB>"
    inoremap <silent> <buffer> <S-TAB> <C-R>=RopeLuckyAssistInsertMode()<CR>

    let s:prascm = g:pymode_rope_always_show_complete_menu ? "<C-P>" : ""
    exe "inoremap <silent> <buffer> <Nul> <C-R>=RopeCodeAssistInsertMode()<CR>" . s:prascm
    exe "inoremap <silent> <buffer> <C-space> <C-R>=RopeCodeAssistInsertMode()<CR>" . s:prascm

endif

" }}}


" Execution {{{

if pymode#Option('run')

    " DESC: Set commands
    command! -buffer -nargs=0 -range=% Pyrun call pymode#run#Run(<f-line1>, <f-line2>)

    " DESC: Set keys
    exe "nnoremap <silent> <buffer> " g:pymode_run_key ":Pyrun<CR>"
    exe "vnoremap <silent> <buffer> " g:pymode_run_key ":Pyrun<CR>"

endif

" }}}


" Breakpoints {{{

if pymode#Option('breakpoint')

    " DESC: Set keys
    exe "nnoremap <silent> <buffer> " g:pymode_breakpoint_key ":call pymode#breakpoint#Set(line('.'))<CR>"

endif

" }}}


" Utils {{{

if pymode#Option('utils_whitespaces')
    au BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
endif

" }}}


" Folding {{{

if pymode#Option('folding')

    setlocal foldmethod=expr
    setlocal foldexpr=pymode#folding#expr(v:lnum)
    setlocal foldtext=pymode#folding#text()

endif

" }}}

" vim: fdm=marker:fdl=0
