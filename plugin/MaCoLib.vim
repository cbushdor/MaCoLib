" ------------------------------------------------------
" Created By : sdo
" File Name : MaCoLib.vim
" Creation Date :2023-07-05 15:03:48
" Last Modified : 2024-05-21 20:48:58
" Email Address : cbushdor@laposte.net
" Version : 0.0.0.1717
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

const s:DEFAULT_MAX_STACK = 14
const g:func_print_col = {"MACOLIB_PRINT": "MACOLIB_PRINT","MACOLIB_PROMPT": "MACOLIB_PROMPT"}

" expand('<script>'),expand('<sfile>'    )
function! OutsideTesting(sc,sf)
   return split(a:sc,'/')[len(split(a:sc,'/'))-1]..substitute(substitute(substitute(a:sf,'^.*function *','#',''),'[\[\]0-9]','','g'),'\.\+','#','')
endfunction

function! g:HiClear() abort
   hi clear
endfunction

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

function! Stop() abort
   call system('kill -9 ' .. getpid())
endfunction

" Gets PID 
function! GetsPid()
   return getpid()
endfunction

function! MaCoLib#new(...)
   let s:MAX_STACK = -1
   " We check if max stack specified in param
   " let s:check_max_stack = v:false
   let s:check_max_array_of_array = v:false

   " Ths function checks if the array is valid
   function! s:is_valid_col_arr(s)
      if (type(a:s) != v:t_list )
         return v:false
      else
         if match(a:s[0],'^[.\t\n]*$') 
            if match(a:s[1],'^:(hi|highlight) ') 
               for l:mkey in keys(g:func_print_col) " We parse all values from dictionary to check that 3rd field within dictionary
                  if g:func_print_col[l:mkey] == a:s[2] " We check that value is in dictionary
                     return v:true " Value found and, return true
                  endif
               endfor
               return v:false
            endif
         else
            return v:false
         endif
      else
         return v:false
      endif
   endfunction

   " That function check if the arrays of arrays is valid
   function! s:is_spec_col_str(s)
      let l:p = a:s

      if (type(l:p) != v:t_list )
         return v:false
      else
         " To check if first element of the array is a list 
         " we store first element in a local memory l:po
         " then, we check if, that element is a list itself.
         " Hence, if it is not we throw an error.

         let l:po = l:p[0]

         if (type(l:po) != v:t_list )
            return v:false
         else
            if s:is_valid_col_arr(l:po) == v:true
               return v:true
            else
             return v:false
            endif
         endif
      endif
   endfunction

   try
      " We create an object (hash)
      let obj = {} " Object/Dictionary created
      let obj.len = -1 " We initialise
      let obj.MyArray = [] " This is where the array of array will be stored
      " let s:MAX_STACK = s:DEFAULT_MAX_STACK " Case it is not specified

      " throw "MyErrorForTheTest"
      let index = 0

      while index < a:0 " Begin while index < a:0
         let index += 1

         let l:p = a:[index]
         if s:is_spec_col_str(l:p) == v:true " Array of array
            if s:check_max_array_of_array == v:false
               let s:check_max_array_of_array = v:true
               if s:MAX_STACK != -1 " Case where stack max was not met in parametters
                  if len(l:p)+1 >= s:MAX_STACK
                     throw "Max size reached "..s:MAX_STACK
                  endif
               endif
               let obj.MyArray = l:p
            else
               throw "Spec for color and  string already declared in arguments."
            endif
         elseif (type(l:p) == v:t_number) " Number of element in the stack specified
            if s:MAX_STACK == -1 " Number of element(s) of the stack not met yet 
               let s:MAX_STACK = l:p " We initialise the maximum of elements in the stack
               if len(l:p)+1 >= s:MAX_STACK " We compare the number of elements in the stack
                  throw "Max size reached "..s:MAX_STACK
               endif
            else
               throw "Stack max (".. s:MAX_STACK .. ") already specified "..OutsideTesting(expand('<script>'),expand('<sfile>'))
            endif
         else
            throw "Argument type should be v:t_list. "..OutsideTesting(expand('<script>'),expand('<sfile>'))
         endif
      endwhile " End while index < a:0

      if s:MAX_STACK == -1 " Case no arguments that  specify the number of elements in stack
         let s:MAX_STACK = s:DEFAULT_MAX_STACK
      endif
      if exists("l:p") " Case not enout arguments in MaCoLib#new(...)
         if len(l:p)+1 >= s:MAX_STACK " We compare the number of elements in the stack
            throw "Max size reached "..s:MAX_STACK
         endif
      endif
      let obj.len = len(obj.MyArray)

      function! obj.addStackStringColor(nuplet) dict abort
         " nuplet is an array with specific format
         " to check the format we need to get array of array!
 
         "echo (type(a:nuplet) == v:t_list) ? "is type v:t_list" : "is not type v:t_list"
         if s:is_spec_col_str([ a:nuplet ]) == v:true " Array of array
            if self.len+1 < s:MAX_STACK 
               call add(self.MyArray,a:nuplet)
               let self.len = len(self.MyArray)
               echo "Added:"..string(a:nuplet).."\n"
            else
               throw "Max size reached "..s:MAX_STACK
            endif
         else
            throw "Error detected in the nuplet format: "..string(a:nuplet)
         endif
      endfunction

      " W only check how many print are and, how many prompt are ... declared
      function! obj.checks_prints_and_prompts() dict abort
         if self.len < 0
            throw "Error stack is empty"
         else
            let l:cMACOLIB_PRINT = 0
            let l:cMACOLIB_PROMPT = 0
            for [m,c,r] in self.MyArray
               if r == g:func_print_col.MACOLIB_PRINT
                  let l:cMACOLIB_PRINT += 1
               elseif r == g:func_print_col.MACOLIB_PROMPT
                  let l:cMACOLIB_PROMPT += 1
               endif
            endfor
         endif
         return {"PRINT": l:cMACOLIB_PRINT,"PROMPT": l:cMACOLIB_PROMPT}
      endfunction

      " This gathersay and prompt function but only paste and copy
      function! obj.prints_and_prompts() dict abort
         if self.len < 0
            throw "Error stack is empty"
         else
            let l:MyRes = []

            for [m,c,r] in self.MyArray
               if r == g:func_print_col.MACOLIB_PRINT
                  let l:fields = split(c,' ')
                  let l:myechohl = ":echohl "..l:fields[1]
                  exe c
                  exe l:myechohl
                  " echohl MyColor
                  echon m
                  echohl None
               elseif r == g:func_print_col.MACOLIB_PROMPT
                  let l:fields = split(c,' ')
                  let l:myechohl = ":echohl "..l:fields[1]
                  exe c
                  exe l:myechohl
                  "echohl MyColor
                  call inputsave()
                  let l:res = input(m .. '> ')
                  call add(l:MyRes,l:res)
                  call inputrestore()
                  echohl None
                  echo "\n"
               else
                  throw "Bad value "..OutsideTesting(expand('<script>'),expand('<sfile>'))
               endif
            endfor
            return MyRes
         endif
      endfunction

      function! obj.say() dict abort
         if self.len > 0
            let l:cpt = 0
            " m: string to print
            " c: syntax to highlight
            " r: print or prompt
            for [m,c,r] in self.MyArray
               if r == g:func_print_col.MACOLIB_PRINT
                  let l:cpt += 1
                  let l:fields = split(c,' ')
                  let l:myechohl = ":echohl "..l:fields[1]
                  exe c
                  exe l:myechohl
                  "echohl MyColor
                  echon m
                  echohl None
               endif
            endfor
            if l:cpt == 0
               throw "Nothing to print "..OutsideTesting(expand('<script>'),expand('<sfile>'))
            endif
         else
            throw "Nothing to print "..OutsideTesting(expand('<script>'),expand('<sfile>'))
         endif
      endfunction

      function! obj.prompt() dict abort
         if self.len > 0
            let l:cpt = 0
            let l:MyRes = []

            " m: string to print
            " c: syntax to highlight
            " r: print or prompt
            for [m,c,r] in self.MyArray
               if r == g:func_print_col.MACOLIB_PROMPT
                  let l:cpt += 1
                  let l:fields = split(c,' ')
                  let l:myechohl = ":echohl "..l:fields[1]
                  exe c
                  exe l:myechohl
                  "echohl MyColor
                  call inputsave()
                  let l:res = input(m .. '> ')
                  call add(l:MyRes,l:res)
                  call inputrestore()
                  echohl None
                  echo "\n"
               endif
            endfor
            if l:cpt <= 0
               throw "Nothing to prompt "..OutsideTesting(expand('<script>'),expand('<sfile>'))
            endif
         else
            throw "Nothing to prompt "..OutsideTesting(expand('<script>'),expand('<sfile>'))
         endif
         return l:MyRes
      endfunction

      " We erase the string list/stack
      function! obj.clearStringColor() dict abort
         if len(self.MyArray) > 0
            let l:i = 0
            while l:i < len(self.MyArray)
               call remove(self.MyArray[l:i],0,2)
               let l:i += 1
            endwhile
            call remove(self.MyArray,0,len(self.MyArray)-1)
            let self.len = len(self.MyArray)
            return (self.len == 0) ? v:true : v:false
         else
            throw "Nothing to clean "..OutsideTesting(expand('<script>'),expand('<sfile>'))
         endif
      endfunction


      function! obj.removeStackStringColor() dict abort
         if (self.len > 0)
            let l:elem = copy(get(self.MyArray,len(self.MyArray)-1))
            call remove(self.MyArray[len(self.MyArray)-1],0,2)
            call remove(self.MyArray,len(self.MyArray)-1)
            let self.len = len(self.MyArray)
            return l:elem
         else
            throw "Stack is empty "..OutsideTesting(expand('<script>'),expand('<sfile>'))
         endif
      endfunction

      function! obj.isEmptyStackStringColor() dict abort
         return (self.len <= 0) ? v:true : v:false
      endfunction

      function! obj.addHeapStringColor(tuple) dict abort
         call reverse(self.MyArray)
         call add(self.MyArray , a:tuple)
         call reverse(self.MyArray)
         let self.len = len(self.MyArray)
      endfunction

      function! obj.removeHeapStringColor() dict abort
         if (self.len > 0)
            call reverse(self.MyArray)
            let l:rem =  self.removeStackStringColor()
            call reverse(self.MyArray)
            return l:rem
         else
            throw "Heap is empty "..OutsideTesting(expand('<script>'),expand('<sfile>'))
         endif
      endfunction

      return obj
   catch /My Error/
      throw "MaCoLib#"..v:exception
   catch /.*/
      throw "MaCoLib#"..v:exception
   endtry
endfunction
