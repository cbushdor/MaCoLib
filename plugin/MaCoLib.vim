" ------------------------------------------------------
" Created By : sdo
" File Name : MaCoLib.vim
" Creation Date :2023-07-05 15:03:48
" Last Modified : 2024-02-19 23:43:23
" Email Address : cbushdor@laposte.net
" Version : 0.0.0.265
" License : 
" 	Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-NonCommercial 3.0
" 	Unported License, which is available at http://creativecommons.org/licenses/by-nc/3.0/.
" Purpose :
" 	MAnage COlor LIBrary and other stuffs...
" ------------------------------------------------------


if !has("g:true")
  let g:true = 1
endif

if !has("g:false")
  let g:false = 0
endif

" Check bellow MyDefine("MaCoLib") for sanitary fence

let g:current_path=expand('<sfile>:p:h') " We get current path
let g:local_path_homedir = substitute(g:current_path,'\v(\/[^\/]+){1}$','',"")..'/' " path to vimrc that contains files
let dirs=split(g:local_path_homedir,'/') " Split by separator g:local_path_homedir
let g:module_name=substitute(dirs[len(dirs)-1],'-','',"") " we get module name from homedir path

function! GetsVarString(var)
  return "g:".g:module_name."_".a:var
endfunction

function! IsVarDefined(var)
  if !exists(GetsVarString(a:var))
    return g:false
  endif
  return g:true
endfunction

function! CreatesGlobalVar(var)
  if !IsVarDefined(a:var)
    exe "let ".GetsVarString(a:var)."=1"
    " Variable created
    return GetsVarString(a:var)
  endif
  " Not created
  return g:false 
endfunction

" Sanitary fence
if !IsVarDefined("MaCoLib")
  let v=CreatesGlobalVar("MaCoLib")
else
  finish
endif

let g:file_ext_ref = "."..expand("%:e") " this file ref for extension comp
let g:local_path_vimrc = g:local_path_homedir.."vimrc/" " path to vimrc that contains files
let g:local_path_mylibrary =  g:local_path_homedir.."mylibrary/" " path to mylibrary that contains files
let g:pathConf = 'MYVIMRC' " File that contains local configuration

" Loads source
function! LoadSource(file)
  execute "source "..a:file
endfunction

" Gets current file nale
function! GetsCurrentFileName()
  return expand("%:p")
endfunction

" We create a envarionment variable string 
function! CreatesEnvVar(en)
  return 'g:my_auto_'..a:en " We take file associated with script name and create environment variable/memory associated
endfunction

" Load global extension that start with suf(ix)
function! LoadGlobVar(...)
  for i in keys(g:)
    for j in 1..a:0
      if i =~ get(a:,j,0)
        echo "LoadGlobVar: " .. get(a:,j,0) .. ":---->" .. i .. "<----"
      endif
    endfor
  endfor
endfunction

" Calculates random number
function! Rand()
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])
endfunction

" -------------------------------------------------------------
"  Next are used to call to outside functions within vimscript
" -------------------------------------------------------------

" Executes shell script input entered should be returned!
" p as  ':!read momo;echo $momo'
function! MyExec(p)
  let l:tmp = Rand() .. Rand() .. ".tmp"
  let l:parm = a:p .. ">&" .. l:tmp
  :silent exec l:parm
  :let l:b = readfile(l:tmp)
  let l:mrm = ":!rm -f " .. l:tmp
  :silent exec l:mrm
  :return l:b[0]
endfunction

" Executes shell script no input expected so no result returned!
" p as  ':!read momo;echo $momo'
function! MyExecOut(p)
  let l:parm = a:p  
  :silent exec l:parm
endfunction

" Gets PID 
function! GetsPid()
  let l:term = MyExec(':!export MYPID=$(echo $$);echo ${MYPID}')
  return l:term
endfunction

" Prints colored string. Needs array as parameter. 
" let MyArray = [['string1','highlightString1'], ['string2','highlighString2'] ]
function! PrintsColoredString(arr)
  let l:i = 0
  while l:i < len(a:arr)
    exe a:arr[l:i][1]
    echohl MyColor
    echon a:arr[l:i][0]
    echohl None
    let l:i += 1
  endwhile
endfunction

" Add new info to print in the string
" array, new string, color
function! AddToPrintColorString(a,s,c)
  call add(a:a,[a:s,a:c])
endfunction

" We erase the string
function! ClearStringColor(a)
  let l:i = 0
  while l:i < len(a:a)
    let l:k = remove(a:a,-1)
    let l:i += 1
  endwhile
  let l:k = remove(a:a,-1)
endfunction

" AddStackStringColor is to add tuple to s at the end
" returns the new list
function! AddStackStringColor(s,tuple)
  call add(a:s,a:tuple)
endfunction

" AddHeadStringColor is to add tuple to s at the beging
" returns the new list
function! AddHeadStringColor(s,tuple)
  call reverse(a:s)
  call add(a:s , a:tuple)
  call reverse(a:s)
endfunction
