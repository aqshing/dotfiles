""vim日志
function! LogOfCodeByVim()
	""保存光标原位置
	let save_cursor=getpos(".")
	""获取代码路径和保存时间
	let s:codeChangedLog = expand("%:p")." changed: ".
\	strftime('%Y-%m-%d %H:%M:%S',localtime())
	""后台静默打开新标签页读写日志文件
	silent exec ":tabnew"
	silent exec ":edit ~/.vim/.vim.log"
	silent call append(line("$"), s:codeChangedLog)
	silent exec ":wq"
	""恢复光标位置
	call setpos(".", save_cursor)
endfunction
"" 当下列文件保存时触发修改最后保存时间
""au BufWritePre *.c,*.cpp,*.cc,*.java,*.py,*.sh silent call LogOfCodeByVim()
au BufWritePre *.c,*.cpp,*.cc,*.sh silent call LogOfCodeByVim()

""func! UpdateCount()
""	%s/\(Update Count\s*:\s*\)\(\d\+\)/\=submatch(1).(submatch(2)+1)/ge
""endfunc
""au BufWritePre *.c,*.cpp,*.cc,*.java,*.py,*.sh silent call UpdateCount()
