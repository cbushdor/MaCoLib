" ------------------------------------------------------
" Created By : sdo
" File Name : MaCoLib.vim
" Creation Date :2023-07-05 15:03:48
" Last Modified : 2024-02-22 02:49:04
" Email Address : cbushdor@laposte.net
" Version : 0.0.0.363
" License : 
" 	Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-NonCommercial 3.0
" 	Unported License, which is available at http://creativecommons.org/licenses/by-nc/3.0/.
" Purpose :
" 	MAnage COlor LIBrary and other stuffs...
" 	DEbug: breakadd file 15 ~/.vim/plugged/MyNewPlugin/plugin/MyNewPlugin.vim
" ------------------------------------------------------


if !has("g:true")
  let g:true = 1
endif

if !has("g:false")
  let g:false = 0
endif

" Check bellow MyDefine("MaCoLib") for sanitary fence
echo "path to open file: "..expand("<script>")
" We get current path
let g:current_path=expand('<sfile>:p:h')
echo "g:current_path: "..g:current_path
let g:local_path_homedir = substitute(g:current_path,'\v(\/[^\/]+){1}$','',"")..'/' " path to vimrc that contains files
echo "g:local_path_homedir: "..g:local_path_homedir
let dirs=split(g:local_path_homedir,'/') " Split by separator g:local_path_homedir
let g:module_name=substitute(dirs[len(dirs)-1],'-','',"") " we get module name from homedir path
echo "g:module_name: "..g:module_name

function! GetsFileNameFromPath(pfn)
  " We split path
  let dirs=split(a:pfn,'/')
  " We get file name from homedir path
  return substitute(dirs[len(dirs)-1],'-','',"") 
endfunction

function! GetsScript(sf)
  return ">>>>"..expand("<script>").."<<<<<<<<<|"..a:sf.."|****"
endfunction

function! GetsVarString(var)
  return "g:"..a:var
endfunction

function! IsVarDefined(var)
  if !exists(a:var)
    return g:false
  endif
  return g:true
endfunction

function! CreatesGlobalVar(var)
  try
    " Variable created
    exe "let "..a:var.."=1"
    " Variable created return
    return g:true
  catch
    return g:false
  endtry
endfunction

function! GetsFileWithNoExtension(fi)
  return substitute(a:fi,'\.[^\.]*$',"","g")
endfunction

" Sanitary fence
if !IsVarDefined(GetsFileWithNoExtension(expand("%")))
  echo "oooooooooooooooooo>"..GetsFileWithNoExtension(expand("%"))
  let v=CreatesGlobalVar(GetsFileWithNoExtension(expand("%")))
  echo "v: "..v
else
  finish
endif

" let g:file_ext_ref = "."..expand("%:e") " this file ref for extension comp
" echo "g:file_ext_ref: "..g:file_ext_ref
" let g:local_path_vimrc = g:local_path_homedir.."vimrc/" " path to vimrc that contains files
" echo "g:local_path_vimrc: "..g:local_path_vimrc
" let g:local_path_mylibrary =  g:local_path_homedir.."MaCoLib/" " path to MaCoLib that contains files
" echo "g:local_path_mylibrary:"..g:local_path_mylibrary
" let g:pathConf = 'MYVIMRC' " File that contains local configuration
" echo "g:pathConf: "..g:pathConf

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
