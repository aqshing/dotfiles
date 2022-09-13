noremap <F12> :term<CR><ESC><C-w>L

"-----------------------------------------------------------------------

function! GetCfg(file, key)
    if filereadable(a:file)
        for line in readfile(a:file)
            if line =~? '^'.a:key.'='
                return substitute(line, '\c'.a:key.'=', '', '')
            endif
        endfor
    endif
    return ''
endfunction

function! SetPath()
    let path=GetCfg(expand('%:p').'.vimcfg', 'PATH')
    if path == ''
        let path=GetCfg('./.vimcfg', 'PATH')
    endif

    if path != ''
        let &path=path
    endif

    let path=GetCfg(expand('%:p').'.vimcfg', 'PATH+')
    if path == ''
        let path=GetCfg('./.vimcfg', 'PATH+')
    endif

    if path == ''
        let path=GetCfg('../.vimcfg', 'PATH+')
    endif

    if path != '' && stridx(','.&path.',', ','.path.',') < 0
        if &path =~ ',$'
            let &path=&path.path
        else
            let &path=&path.','.path
        endif
    endif
endfunction

"call SetPath()
"autocmd BufReadPost * call SetPath()

nnoremap  <Leader>/                 :call SetPath()\|set path<CR>

"-----------------------------------------------------------------------

function! GenMakeCmd()
    " filetype on
    " &filetype ==? expand('%:e')
    let ext=expand('%:e')

    if ext ==? 'c' || ext ==? 'cpp' || ext ==? 'cxx' || ext ==? 'cc'
        if filereadable(expand('%:p:h').'/CMakeLists.txt')
            if executable('/usr/bin/cmake')
                if !isdirectory(expand('%:p:h').'/build')
                    call mkdir(expand('%:p:h').'/build')
                endif

                return 'cd "%:p:h/build" && cmake .. && make -j8'
            else
                echoerr 'Can not find "cmake"!'
            endif
        elseif executable(expand('%:p:h').'/configure')
            return 'cd "%:p:h" && ./configure && make -j8'
        elseif filereadable(expand('%:p:h').'/Makefile')
            \ || filereadable(expand('%:p:h').'/makefile')
            return 'cd "%:p:h" && make -j4'
        elseif filereadable('CMakeLists.txt')
            if executable('/usr/bin/cmake')
                if !isdirectory('build')
                    call mkdir('build')
                endif

                return 'cd build && cmake .. && make -j8'
            else
                echoerr 'Can not find "cmake"!'
            endif
        elseif executable('./configure')
            return './configure && make -j8'
        elseif filereadable('Makefile') || filereadable('makefile')
            return 'make -j8'
        else
            if ext ==? 'c'
                "return 'gcc --verbose -g3 -O0 -Wall -o "%<" "%"'
                return 'gcc --std=c99 -Wall -g -O2 -o "%<" "%"'
            else
                "return 'g++ --verbose -g3 -O0 -Wall -o "%<" "%"'
                return 'g++ -std=c++11 -Wall -g -O2 -o "%<" "%"'
            endif
        endif
    elseif ext ==? 'java'
        return 'javac -verbose -g "%"'
    elseif ext == ''
        echoerr 'Unknown file type: "'.@%.'"!'
    else
        echoerr 'Operation "make" on "*.'.ext.'" is not defined!'
    endif
    return ''
endfunction

let g:MAKE_CMD=''

function! GetMakeCmd()
    if exists('g:MAKE_CMD') && g:MAKE_CMD != ''
        return g:MAKE_CMD
    endif

    let make_cmd=GetCfg(expand('%:p').'.vimcfg', 'MAKE_CMD')
    if make_cmd != ''
        return make_cmd
    endif

    let make_cmd=GetCfg('./.vimcfg', 'MAKE_CMD')
    if make_cmd != ''
        return make_cmd
    endif

    let make_cmd=GetCfg('../.vimcfg', 'MAKE_CMD')
    if make_cmd != ''
        return make_cmd
    endif

    return GenMakeCmd()
endfunction

function! Make()
    exec 'update'
    redraw!

    let make_cmd=GetMakeCmd()
    "let g:MAKE_CMD = make_cmd
    if make_cmd != ''
        exec 'cclose'
        let &makeprg=make_cmd
        make!
        exec 'botright cwindow'
        return
    endif

    echoerr 'MAKE_CMD is not defined!'
endfunction

noremap   <silent><F8>              <Esc>:call Make()<CR>
noremap!  <silent><F8>              <Esc>:call Make()<CR>

"-----------------------------------------------------------------------

function! GenRunCmd()
    " filetype on
    " &filetype ==? expand('%:e')
    let ext=expand('%:e')

    if ext ==? 'c' || ext ==? 'cpp' || ext ==? 'cxx' || ext ==? 'cc'
        if filereadable(expand('%:p:h').'/CMakeLists.txt')
            echoerr '"CMakeLists.txt" has been found in directory "'.expand('%:p:h').'".'
        elseif executable(expand('%:p:h').'/configure')
            echoerr '"configure*" has been found in directory "'.expand('%:p:h').'".'
        elseif filereadable(expand('%:p:h').'/Makefile') || filereadable(expand('%:p:h').'/makefile')
            echoerr '"Makefile" has been found in directory "'.expand('%:p:h').'".'
        elseif filereadable('CMakeLists.txt')
            echoerr '"CMakeLists.txt" has been found in working directory "'.getcwd().'".'
        elseif executable('./configure')
            echoerr '"configure*" has been found in working directory "'.getcwd().'".'
        elseif filereadable('Makefile') || filereadable('makefile')
            echoerr '"Makefile" has been found in working directory "'.getcwd().'".'
        else
            if stridx(expand('%<'), '/') < 0
                let exe_file='./'.expand('%<')
            else
                let exe_file=expand('%<')
            endif

            if executable(exe_file)
                return '"'.exe_file.'"'
            else
                echoerr 'Can not find executable file!'
            endif
        endif
    elseif ext ==? 'java'
        "return 'cd "'.expand('%:p:h').'" && java '.expand('%:t:r')
        return 'cd "%:p:h" && java %:t:r'
    elseif ext ==? 'py'
        return 'python "%"'
    elseif ext ==? 'sh'
        return 'bash "%"'
    elseif ext ==? 'html'
        return 'firefox "%" &'
    elseif ext == ''
        echoerr 'Unknown file type: "'.@%.'"!'
    else
        echoerr 'Operation "run" on "*.'.ext.'" is not defined!'
    endif
    return ''
endfunction


let g:RUN_CMD=''

function! GetRunCmd()
    if exists('g:RUN_CMD') && g:RUN_CMD != ''
        return g:RUN_CMD
    endif

    let run_cmd=GetCfg(expand('%:p').'.vimcfg', 'RUN_CMD')
    if run_cmd != ''
        return run_cmd
    endif

    let run_cmd=GetCfg('./.vimcfg', 'RUN_CMD')
    if run_cmd != ''
        return run_cmd
    endif

    let run_cmd=GetCfg('../.vimcfg', 'RUN_CMD')
    if run_cmd != ''
        return run_cmd
    endif

    return GenRunCmd()
endfunction

function! Run()
    exec 'update'
    redraw!

    let run_cmd=GetRunCmd()
    echo run_cmd
    if run_cmd != ''
        exec 'cclose'
        exec '!'.run_cmd
        return
    endif

    echoerr 'RUN_CMD is not defined!'
endfunction

noremap   <silent><F6>              <Esc>:call Run()<CR>
noremap!  <silent><F6>              <Esc>:call Run()<CR>

"-----------------------------------------------------------------------

function! GenDebugCmd()
    " filetype on
    " &filetype ==? expand('%:e')
    let ext=expand('%:e')

    if ext ==? 'c' || ext ==? 'cpp' || ext ==? 'cxx' || ext ==? 'cc'
        if exists(':ConqueGdb')
            let debug_cmd='ConqueGdb'
        else
            let debug_cmd='gdb -tui'
        endif

        if filereadable(expand('%:p:h').'/CMakeLists.txt')
            return debug_cmd
        elseif executable(expand('%:p:h').'/configure')
            return debug_cmd
        elseif filereadable(expand('%:p:h').'/Makefile')
            \ || filereadable(expand('%:p:h').'/makefile')
            return debug_cmd
        elseif filereadable('CMakeLists.txt')
            return debug_cmd
        elseif executable('./configure')
            return debug_cmd
        elseif filereadable('Makefile') || filereadable('makefile')
            return debug_cmd
        else
            "if stridx(expand('%<'), '/') < 0
            "    let exe_file='./'.expand('%<')
            "else
            "    let exe_file=expand('%<')
            "endif

            "if executable(exe_file)
            "    return debug_cmd.' "'.exe_file.'"'
            "else
            "    return debug_cmd
            "endif
            return debug_cmd.' "'.expand('%<').'"'
        endif
    elseif ext ==? 'java'
        "return 'cd "'.expand('%:p:h').'" && jdb '.expand('%:t:r')
        return 'cd "%:p:h" && jdb %:t:r'
    elseif ext ==? 'py'
        return 'python -m pdb "%"'
    elseif ext ==? 'sh'
        "return 'bashdb "%"'
        return 'bash -x "%"'
    elseif ext == ''
        echoerr 'Unknown file type: "'.@%.'"!'
    else
        echoerr 'Operation "debug" on "*.'.ext.'" is not defined!'
    endif
    return ''
endfunction

let g:DEBUG_CMD=''

function! GetDebugCmd()
    if exists('g:DEBUG_CMD') && g:DEBUG_CMD != ''
        return g:DEBUG_CMD
    endif

    let debug_cmd=GetCfg(expand('%:p').'.vimcfg', 'DEBUG_CMD')
    if debug_cmd != ''
        return debug_cmd
    endif

    let debug_cmd=GetCfg('./.vimcfg', 'DEBUG_CMD')
    if debug_cmd != ''
        return debug_cmd
    endif

    return GenDebugCmd()
endfunction

function! Debug()
    exec 'update'
    redraw!

    let debug_cmd=GetDebugCmd()
    if debug_cmd != ''
        exec 'cclose'
        if debug_cmd =~ '^ConqueGdb'
            exec debug_cmd
        else
            exec '!'.debug_cmd
        endif
        return
    endif

    echoerr 'DEBUG_CMD is not defined!'
endfunction

noremap   <silent><F9>              <Esc>:call Debug()<CR>
noremap!  <silent><F9>              <Esc>:call Debug()<CR>

"-----------------------------------------------------------------------
