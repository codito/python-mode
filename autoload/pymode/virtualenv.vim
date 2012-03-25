fun! pymode#virtualenv#Activate() "{{{

    if !exists("$VIRTUAL_ENV")
        return
    endif

    for env in g:pymode_virtualenv_enabled
        if env == $VIRTUAL_ENV
            return 0
        endif
    endfor

    call add(g:pymode_virtualenv_enabled, $VIRTUAL_ENV)

    if g:pymode_py3k
        " XXX these differences should better be moved into a common module
python3 << EOF
import os

ve_dir = os.environ['VIRTUAL_ENV']
ve_dir in sys.path or sys.path.insert(0, ve_dir)
activate_this = os.path.join(os.path.join(ve_dir, 'bin'), 'activate_this.py')

exec(compile(open(activate_this).read(), "activate_this.py", 'exec'), dict(__file__=activate_this))
EOF
    else
python << EOF
ve_dir = os.environ['VIRTUAL_ENV']
ve_dir in sys.path or sys.path.insert(0, ve_dir)
activate_this = os.path.join(os.path.join(ve_dir, 'bin'), 'activate_this.py')
execfile(activate_this, dict(__file__=activate_this))
EOF
    endif
endfunction "}}}
