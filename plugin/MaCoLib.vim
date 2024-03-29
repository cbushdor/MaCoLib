" ------------------------------------------------------
" Created By : sdo
" File Name : MaCoLib.vim
" Creation Date :2023-07-05 15:03:48
" Last Modified : 2024-03-22 22:08:21
" Email Address : cbushdor@laposte.net
" Version : 0.0.0.850
" License : 
" 	Permission is granted to copy, distribute, and/or modify this document under the terms of the Creative Commons Attribution-NonCommercial 3.0
" 	Unported License, which is available at http://creativecommons.org/licenses/by-nc/3.0/.
" Purpose :
" 	MAnage COlor LIBrary and other stuffs...
" 	DEbug: breakadd file 15 ~/.vim/plugged/MyNewPlugin/plugin/MyNewPlugin.vim
" ------------------------------------------------------

if !exists("g:MaCoLib")
  let g:MaCoLib = v:true
else
  finish
endif

" Object for color printing
let g:ManageColorLine = {}

function! OutsideTesting(sc,sf)
  " let l:base = split(expand("<script>"),'/')[len(split(expand("<script>"),'/'))-1]
  " let l:src = substitute(expand("<sfile>"),'^.*function *','#','')
  " let l:src = substitute(substitute(expand("<sfile>"),'^.*function *','#',''),'[\[\]0-9]','','g')
  " let l:src = substitute(substitute(substitute(expand("<sfile>"),'^.*function *','#',''),'[\[\]0-9]','','g'),'\.\+','#','')
  "echo split(expand("<script>"),'/')[len(split(expand("<script>"),'/'))-1]..substitute(substitute(substitute(expand("<sfile>"),'^.*function *','#',''),'[\[\]0-9]','','g'),'\.\+','#','')
  return split(a:sc,'/')[len(split(a:sc,'/'))-1]..substitute(substitute(substitute(a:sf,'^.*function *','#',''),'[\[\]0-9]','','g'),'\.\+','#','')
endfunction

function s:new(...) dict abort
  try
    " We create our object
    let l:oneBlock = copy(self)
    let l:oneBlock.myexpand = {"SCRIPT": "<script>"}
    let l:oneBlock.error = ":hi MyErrorManagement  term=italic ctermfg=Red guifg=#80a0ff gui=bold"

    " Loop to analyze params in new
    for i in range(1,a:0)
      if type(a:{i}) == v:t_list
        echo i.." ------->["..join(a:{i},",").."]: ".. "ok for list\n" 
      elseif type(a:{i}) == v:t_string
        "echo i.." ------->"..a:{i}..": ".. "ok for string\n" 
        if a:{i} =~ '\v^:hi(ghlight){0,1}\ '
          "echo "(within loop) We have highligtht :"..a:{i}

          " We create in the object a field called color where color will be set
          let l:oneBlock.color = a:2
        else
          "echo "(within loop) We have string to print in color: "..a:{i}

          " We create in the object a field block where our first field is a block (future
          " might change but for dem it a string
          let l:oneBlock.block = a:1
        endif
      elseif type(a:{i}) == v:t_dict
        echo i.." ------->a:{i}.. ok for dict\n" 
      else 
        throw "Wrong arguments"
      endif
    endfor
    return l:oneBlock
  catch /Key.*/
    echoerr "We have error herere ======================="
    finish
  finally
  endtry
endfu

function s:say() dict abort
  try
    exe self.color
    echohl MyColor
    echon self.block
    echohl None
    " echon "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  catch
    " echo "-------------------------------------------------------------------xxx"
    let l:s = OutsideTesting(expand("<script>"),expand("<sfile>"))
    "echo l:s
    echoerr "Caught error in ["..l:s.."]: " .. v:exception
  endtry
endfunction

let g:ManageColorLine.new = function("s:new")
let g:ManageColorLine.say = function("s:say")

" We get path of the current file
function! GetsMyExecScript(str)
  let l:apth="execute ':echo expand(\""..a:str.."\")'"
  return l:apth
endfunction

" Check bellow MyDefine("MaCoLib") for sanitary fence

" Remove last cariage return
function! MyChomp(s)
  return substitute(a:s,'\n$','',"g")
endfunction


" We get current script path source
let g:current_script_path = MyChomp(execute(GetsMyExecScript("<script>")))

" We get current path
let g:current_path=expand('<sfile>:p:h')

" Path to vimrc that contains files
let g:local_path_homedir = substitute(g:current_path,'\v(\/[^\/]+){1}$','',"")..'/' 

" Split by separator g:local_path_homedir
let s:mydirs=split(g:local_path_homedir,'/')

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
