" ------------------------------------------------------
" Created By : sdo
" File Name : MaVaEnv.vim
" Creation Date :2023-07-05 15:03:48
" Last Modified : 2024-07-03 01:04:05
" Email Address : cbushdor@laposte.net
" Version : 0.0.0.1867
" License : 
" 	Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-NonCommercial 3.0
" 	Unported License, which is available at http://creativecommons.org/licenses/by-nc/3.0/.
" Purpose :
" 	MAnage COlor LIBrary and other stuffs...
" 	DEbug: breakadd file 15 ~/.vim/plugged/MyNewPlugin/plugin/MyNewPlugin.vim
" ------------------------------------------------------

if !exists("g:MaVaEnv")
   let g:MaVaEnv = v:true
else
   finish
endif

" expand('<script>'),expand('<sfile>'    )
function! OutsideTesting(sc,sf)
   let l:inherit= substitute(a:sf,'^.*\.\(function\)','\1','')

   return   l:inherit
endfunction

function! g:HiClear() abort
   hi clear
endfunction

" We get current path
let s:current_path=expand('<sfile>:p:h')

" Path to vimrc that contains files
let s:local_path_homedir = substitute(g:current_path,'\v(\/[^\/]+){1}$','',"")..'/'

" Split by separator g:local_path_homedir
let s:mydirs=split(s:local_path_homedir,'/')

" We get module name from homedir path
let g:module_name=substitute(s:mydirs[len(s:mydirs)-1],'-','',"")

" We get file name from path
function! GetsFileNameFromPath(pfn)
   " We split path
   let dirs=split(a:pfn,'/')
   " We get file name from homedir path
   return substitute(dirs[len(dirs)-1],'-','',"") 
endfunction

" We return Script
function! GetsScript(sf)
   return ">>>>"..expand("<script>").."<<<<<<<<<|"..a:sf.."|****"
endfunction

" We return string for global variable not set in memory
function! GetsVarString(var)
   return "g:"..a:var
endfunction

" We check if variable is defined and return v:true if so
function! IsVarDefined(var)
   return exists(a:var)
endfunction

" We return string for global variable set in memory and return v:true if
" created.
function! CreatesGlobalVar(var)
   try
      " Variable created
      exe "let "..a:var.."=1"
      " Variable created return
      return v:true
   catch
      return v:false
   endtry
endfunction

" Frome file name returns only file name with not extension if, has one.
function! GetsFileWithNoExtension(fi)
   return substitute(a:fi,'\.[^\.]*$',"","g")
endfunction

" Sanitary fence
if !IsVarDefined(GetsFileWithNoExtension(expand("%")))
   " echo "oooooooooooooooooo>"..GetsFileWithNoExtension(expand("%"))
   let v=CreatesGlobalVar(GetsFileWithNoExtension(expand("%")))
" echo "v: "..v
else
   finish
endif

" This file ref for extension comp
let g:file_ext_ref = "."..expand("%:e") 
" echo "g:file_ext_ref: "..g:file_ext_ref

" Path to vimrc that contains files
let g:local_path_vimrc = g:local_path_homedir.."vimrc/" 
" echo "g:local_path_vimrc: "..g:local_path_vimrc

" path to MaCoLib that contains files
let g:local_path_mylibrary =  g:local_path_homedir.."MaCoLib/" 
" echo "g:local_path_mylibrary:"..g:local_path_mylibrary

" File that contains local configuration
let g:pathConf = 'MYVIMRC'
" echo "g:pathConf: "..g:pathConf

" Gets current file nale
function! GetsCurrentFileName()
   return expand("%:p")
endfunction

" We create a envarionment variable string 
function! CreatesEnvVar(en)
   " We take file associated with script name and create environment variable/memory associated
   return 'g:my_auto_'..a:en 
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

function! Stop() abort
   call system('kill -9 ' .. getpid())
endfunction

" Gets PID 
function! GetsPid()
   return getpid()
endfunction

