"===============KEYBINDS===============

" Line moving
" In normal or insert mode, press Alt-j or Alt-k to move the current line down or up
" Similarly move blocks of code in visual mode after selecting it
nnoremap <Esc>j :m .+1<CR>==
nnoremap <Esc>k :m .-2<CR>==
inoremap <Esc>j <Esc>:m .+1<CR>==gi
inoremap <Esc>k <Esc>:m .-2<CR>==gi
vnoremap <Esc>j :m '>+1<CR>gv=gv
vnoremap <Esc>k :m '<-2<CR>gv=gv
