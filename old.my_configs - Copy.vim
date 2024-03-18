silent exec '!python -c "import neovim"'
set rnu

" colorscheme wal

"Spelling
set spell spelllang=en_gb
hi clear SpellBad
hi SpellBad cterm=underline
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g><Esc>

Vimtex
 let g:tex_flavor = 'latex'
 let g:vimtex_compiler_method = 'latexmk'
 let g:vimtex_view_general_viewer = 'SumatraPDF'

 let g:vimtex_quickfix_mode=0
 set conceallevel=1
 let g:tex_conceal='abdmg'
 let g:vimtex_fold_enabled = 1
 let vimtex_format_enabled = 1
 set fillchars=fold:\ 
 let g:vimtex_fold_levelmarker = '>'
 let g:vimtex_fold_types = {
            \ 'sections' : {
            \   'parse_levels' : 0,
            \   'sections' : ['part', 'chapter', 'section','subsection', 'subsubsection','paragraph'],
            \   },
            \ 'preamble' : {},
            \ 'envs' : {
            \   'whitelist' : ['appendix','appendices','figure','center','abstract','tikzpicture'],
            \ },
            \}
 autocmd BufNewFile,BufRead *.tex exec "VimtexCompile"

"Neosnips
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=0 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
let g:snipMate = { 'snippet_version' : 1 }

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim_runtime/snippets/neosnippet-snippets/neosnippets/'

"Powerline
let g:powerline_pycmd = "py3"

"Python

" Quick run via <F5>
noremap <F5> :call <SID>compile_and_run()<CR>

function! s:compile_and_run()
    exec 'w'
    if &filetype == 'c'
        exec "AsyncRun! gcc % -o %<; ./%<"
    elseif &filetype == 'cpp'
       exec "AsyncRun! g++ -std=c++11 % -o %<; ./%<"
    elseif &filetype == 'java'
       exec "AsyncRun! javac %; java %<"
    elseif &filetype == 'sh'
       exec "AsyncRun! bash %"
    elseif &filetype == 'python'
       <Plug>VimspectorContinue
       autocmd BufWinEnter *.py nmap <silent> <F5>:w<CR>:terminal python3 -m pdb '%:p'<CR>
       exec "AsyncRun! python %"
    elseif &filetype == 'tex'
       exec "VimtexCompile"
    endif
endfunction

let g:asyncrun_open = 15

" Use Powerline
set rtp+=/usr/share/powerline/bindings/vim

" Improved syntax highlighting
highlight Folded ctermbg=Grey ctermfg=Black

" Speed up folding
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
 
" Nerd Tree settings
let NERDTreeWinPos = "left"

" Set folding function for bibtex entries
function! BibTeXFold()
	if getline(v:lnum) =~ '^@.*$'
		return ">1"
	endif
	return "="
endfunction
au BufEnter *.bib setlocal foldexpr=BibTeXFold()
au BufEnter *.bib setlocal foldmethod=expr

" Vimspector Debugging
packadd! vimspector
" Tell YCM where to find the plugin. Add to any existing values.
let g:ycm_java_jdtls_extension_path = [
  \ '</path/to/Vimspector/gadgets/<os>'
  \ ]
let g:vimspector_enable_mappings = 'HUMAN'

let s:jdt_ls_debugger_port = 0
function! s:StartDebugging()
  if s:jdt_ls_debugger_port <= 0
    " Get the DAP port
    let s:jdt_ls_debugger_port = youcompleteme#GetCommandResponse(
      \ 'ExecuteCommand',
      \ 'vscode.java.startDebugSession' )

    if s:jdt_ls_debugger_port == ''
       echom "Unable to get DAP port - is JDT.LS initialized?"
       let s:jdt_ls_debugger_port = 0
       return
     endif
  endif

  " Start debugging with the DAP port
  call vimspector#LaunchWithSettings( { 'DAPPort': s:jdt_ls_debugger_port } )
endfunction

nnoremap <silent> <buffer> <Leader><F5> :call <SID>StartDebugging()<CR>

" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

let g:AngryReviewerEnglish = 'british'
nnoremap <leader>ar :AngryReviewer<cr>

augroup AutoAdjustResize
  autocmd!
  autocmd VimResized * execute "normal! \<C-w>="
augroup end

" Jupyter
nnoremap <silent><expr> <LocalLeader>r  :MagmaEvaluateOperator<CR>
nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
nnoremap <silent>       <LocalLeader>rd :MagmaDelete<CR>
nnoremap <silent>       <LocalLeader>ro :MagmaShowOutput<CR>

let g:magma_automatically_open_output = v:true
let g:magma_image_provider = "none"

" Use deoplete.
let g:deoplete#enable_at_startup = 1
