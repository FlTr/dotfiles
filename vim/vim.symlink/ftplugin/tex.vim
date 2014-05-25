if exists("b:did_ftplugin")
    finish
endif

let b:did_ftplugin = 1 " Don't load twice in one buffer

setl textwidth=80
setl colorcolumn=81
setl expandtab
setl tabstop=2
setl softtabstop=2
setl shiftwidth=2
