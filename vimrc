" ------|判斷目前為哪一種作業系統|------

function! GetCurrentOS()
    
    if ( has( "win32" ) || has( "win64" ) )
        return "win"
    endif

    if ( has( "unix" ) )
        if system( 'uname' )=~'Darwin'
            return "mac"
        else
            return "linux"
        endif
    endif

endfunction

let os = GetCurrentOS()

" ------|判斷MACOS是否使用MacVim|------
" if ( os == 'mac' )
"     if ( has( "gui_macvim" ) && has( "gui_running" ) )
"         let g:ismacvim = 1
"     else
"         let g:ismacvim = 0
"     endif
" endif

" ------|判斷編輯器為VIM或GVIM|------
if has( "gui_running" )
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

" ------|判斷作業系統為Windows或Linux|------
" if ( has( "win32") || has( "win64" ) )
"    let g:iswindows = 1
" else
"    let g:iswindows = 0
" endif

" ------|Setting up Vundle|------
" 用於方便管理VIM插件，安裝方法為在終機下輸入以下命令
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

" 透過Vundle管理插件，便不需要再讓GIT追蹤 ~/.vim/bundle/ 目錄
" 所以，讓VIM在啟動的時候就自動檢查Vundle是否有安裝，
" 在 .gitignore裹把bundle目錄直接忽略，
let hasVundle = 1
let vundle_readme = expand( '~/.vim/bundle/vundle/README.md' )
if ( !filereadable( vundle_readme ) )
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let hasVundle = 0
endif

" Vundle配置
set nocompatible
filetype off        " required!

if ( os == 'win' )
    set rpt+=$VIM/vimfiles/bundle/vundle/
    call vundle#rc( '$VIM/vimfiles/bundle' )
else
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
endif

" 使用Vundle來管理Vundle
" requried!
Bundle 'gmarik/vundle'

" ------|My Bundle here, original repos on github|------
" ======|Nerdtree && NerdTree-Tabs|======
Bundle 'scrooloose/nerdtree.git'
Bundle 'jistr/vim-nerdtree-tabs'

" 設定NERDTree視窗大小
let NERDTreeWinPos='left'
let NERDTreeWinSize = 31
let NERDTreeCaseSensitiveSort=1
" 改變Tree目錄的同時也改變工程目錄：
let NERDTreeChDirMode=1
" 打開NERDTree時，自動顯示Bookmarks
let NERDTreeShowBookmarks=1

" Show hidden files in NerdTree
let NERDTreeShowHidden=1

" Open a NERDTree automatically when vim starts up and 
" move the cursor into the main window
autocmd vimEnter * NERDTree
autocmd vimEnter * wincmd p

" Open a NERDTree automatically when vim starts up if no files were specified.
autocmd vimEnter * if !argc() | NERDTree | endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Give a shortcut key to NERDTree, fn + <F2>
map <F2> :NERDTreeToggle<CR>

if ( hasVundle == 0 )
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif

filetype plugin indent on

" ------|配置字型及外觀|------
if ( g:isGUI )
    " remove menu bar
    set guioptions+=m
    " remove tool bar
    set guioptions+=T
    " remove left scroll
    set guioptions-=r
    " remove right scroll
    set guioptions-=l

    " ------|判斷是否為MACOS並且是否使用MacVim|------
    if ( ( os=='mac' ) && has( "gui_macvim" ) )
        set guifont=Monaco:h14
        " set guifont=Osaka-Mono:h18
        set background=dark
        set cursorline
        " colorscheme desert
        colorscheme evening
        highlight CursorLine guibg=#003853 ctermbg=24 gui=none cterm=none
    else
        " 設定字型
        " set guifont=Inconsolata:h14:cANSI     " 常用字體第一名
        " set guifont=Consolas:h14:cANSI        " 常用字體第二名
        set guifont=Courier_New:h14:cANSI
        " setguifont=monaco:h14:cANSI
        " setguifont=DajaVu:h11:cANSI
        "set guifont=Lucida\ Console:h11:cANSI
        "set guifontwide=YouYuan:h11:cGB2312
        " GVIM 配色方案
        colorscheme evening
    endif
else
    " terminal color settings
    set t_Co=256
    "set background=dark
    colorscheme evening 
    ""highlight Normal ctermfg=grey ctermbg=darkblue
endif

" ------|配置Windows GVIM|------
if ( ( os == 'win' ) && ( g:isGUI ) )
    " 設定在Windows底下gVIM在啟動時, 視窗要最大化
    au GUIEnter * simalt ~x
    " 在Windows底下, 若是字符編碼正確應該是不會產生亂碼,
    " 萬一gVIM的主選單變成亂碼,以下兩行可以修正
    " source $VIMRUNTIME/delmenu.vim
    " source $VIMRUNTIME/menu.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    language messages zh_TW.utf-8
endif

" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

set clipboard=unnamed   " yank to the system register (*) by default
set showmatch           " Cursor shows matching ) and }
set showmode            " Show current mode
set wildchar=<TAB>      " start wild expansion in the command line using <TAB>
set wildmenu            " wild char completion menu

" ignore these files while expanding wild chars
set wildignore=*.o,*.class

" ------|文件內容編碼配置|------
" 檔案字元編碼 - 配置多語言環境
" encoding - encoding的設定會影響vim內部的Buffer及訊息文字等。
"            在UNIX環境下，encoding的默認設定為LOCALE；
"            在中文WINDOWS環境下encoding的默認設定為CP950。
" fileencodings - vim在打開文件時，會根據fileencoding的設定依序來
"                 偵測所打開文件的編碼。
" fileencoding - vim 在儲存新文件時會根據fileencoding的設定編碼來儲存新文件；
"                如果是已經打開的文件，vim會根據打開文件時所偵測到的編碼來儲存，
"                除非在儲存時重新設定。重新設定的方式有兩種：
"                1. 永久改變文件的儲存編碼，例如 －
"                   set fileencoding=cp950
"                2. 只改變當前文件的儲存編碼，例如 －
"                   setlocal=cp950
" termencoding - 在終端環境下要使用vim, 需要設定termencoding和終端環境所使用的編碼一致。
" amiwidth -
" fileformat - 寫入檔案時放置 EOL 的形式
"              unix是以0A來斷行
"              dos 是以0D0A來斷行
"              mac 是以0D來斷行
" fileformats - 可以指定多種檔案格式, 會依載入的檔案格式來調整fileformat
"               例如: set fileformat=unix
"                     set fileformats=unix,dox
"               此時若讀入的檔案為dos格式, 會自動調整為dos格式, 存檔也以dos格式存檔
"               若希望存檔時改成用unix格式存檔, 則執行set fileformat=unix, 然後存檔即可
if &termencoding == ''
	let &termencoding = &encoding
endif

if has("multi_byte")
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=ucs-bom,utf-8,big5,cp950
	if v:lang =~? '^/(zh/)/|/(ja/)/|/(ko/)'
	        set ambiwidth=double
  	endif
else
	echoerr "Sorry, this version of (g)vim was not compiled with multi-byte."
endif

" 設定快捷鍵ctrl+u、ctrl+b，來切換檔案的編碼。
" set <C-u>=^U
" set <C-b>=
" map <C-u> :set fileencoding=utf8
" map <C-b> :set fileencoding=big5

" 文件格式設定, 預設為unix格式
set fileformat=unix
set fileformats=unix,dos,mac

" ------|文件類型檢測|------
" filetype - 下列描述其實代表三行命令
"            filetype on - 打開文件類型檢測功能
"            filetype plugin on - 允許VIM加載文件類型插件,
"                                 令VIM可以針對不同的文件類型載入相對應旳的插件
"            fileytpe indent on - 允許VIM可以針對不同的文件類型定義不同的文件縮進格式
" 模式行(modeline) - 當VIM無法檢測出文件類型時,可以用模式行來指明文件類型。
"                     VIM在打開文件時, 會在文件首尾的若干行(行數由"modellines"選項決定,預設為五行),
"                     檢測具有VIM特殊標記的行,稱為模式行。
" modelines - 將搜尋 modelines 的範圍設定為文件開頭和末尾各兩行，若省略則預設為五行。
"             例如: 於文件中的頭2行內可以做以下設定
"             /* vim: set tabstop=4 shiftwidth=4 expandtab: */ 或 /* vim: set filetype=c */
"             '/*' 與 vim 之間必須要留空白, 並且, 最後一個字元 ':' 與 '*/'之間也必須留空白, 是規定
set modeline
set modelines=2
filetype on
filetype plugin indent on

" ------|文件編輯操作配置|------
" Text formating - 空格、Tab、縮排控制
" shiftwidth - 縮排的空格數
" tabstop - Tab的空格數
" expandtab - 遇到shiftwidth及tabstop時，使用空格代替；使用noexpandtap取消設定
" softtabstop -設定為非零數值後，使用Tab及Backspace時，
"              移動的格數等於設定的數值
" autoindent - 自動縮排；每行的縮排值與上一行相同；使用
"              noautoindent取消設定
" nobackup -
" copyindent -
" ignorecase -
" cindent - 使用C語言的縮排方式，根據特殊字元如“{”、“}”“
"           和語句是否結束等訊息自動調整縮排；於編輯C／C＋＋程式時，
"           會自動設定；使用nocindent取消設定
" cinoptions -
" paste -
" formatoptions - Let vim can reformat multibyte text (e.g. Chinese).
" autoread - 當文件在外部被修改, VIM自動更新該文件
" ignorecase - 於搜索模式下忽略大小寫
" smartcase - 於搜索模式下, 搜索字串包括大小寫字元時,
"             不使用"ignorecase"選項,
" smarttab -
" noincsearch - 在輸入要搜索字串時, 取消即時匹配
" incsearch -
" ruler -
" nocompatible -
" bs -
" history -
set smarttab
set autoindent
set smartindent
set wrap
set lbr
set formatoptions+=mM
set autoread
set ignorecase
set smartcase
set ruler
set nocompatible
set bs=2
set history=50

" TAB setting {
    set tabstop=4
    set expandtab
    set softtabstop=4
    set shiftwidth=4

    au FileType Makefile set noexpandtab
" }


" 啟用折疊
" set foldenable
" indent 折疊方式
" set foldmethod=indent
" marker 折疊方式
" set foldmethod=marker
" 用空格鍵來開關折疊
" nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" 於Normal模式下, 輸入cS, 清除行尾空格
nmap cS :%s/\s\+$//g<cr>:noh<cr>
" 於Normal模式下, 輸入cM, 清除行尾 ^M
nmap cM :%s/\r$//g<cr>:noh<cr>

" Ctrl + K 於插入模式下向上移動游標
imap <c-k> <Up>
" Ctrl + J 於插入模式下向下移動游標
imap <c-j> <Down>
" Ctrl + H 於插入模式下向左移動游標
imap <c-h> <Left>
" Ctrl + L 於插入模式下向右移動游標
imap <c-l> <Right>

" 每一行當長度度超過80個字元, 第81個字元起會用下底下標示出來
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

" ------|界面配置|------
" 設定語法上色
if has("syntax")
    syntax on
endif

" search highlighting
set hlsearch

" number - 顯示行數
set number

" Line Highlight 游標處整列(橫)會標註顏色
set cursorline
" Column Highlight 游標處整行(直)會標註顏色
" set cursorcolumn
" 顏色的前景色與背景色要如何
" highlight CursorLine cterm=none ctermfg=0 ctermbg=2
" highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue

" Status line customization {
    " 截取目前路徑, 將$HOME轉成~
    function! CurDir()
        let curdir = substitute(getcwd(), $HOME, "~", "g")
         return curdir
    endfunction
    
    " 狀態欄個性化
    set laststatus=2
    set cmdheight=2
    set statusline=[%n]\ %f%m%r%h\ \|\ 
    set statusline+=\ pwd:\ %{CurDir()}\ \ \|
    set statusline+=%=\|\ %l,%c\ %p%%\ \|\ 
    set statusline+=ascii=%b,hex=%b%{((&fenc==\"\")?\"\":\"\ \|\ \".&fenc)}\ \|\ 
    set statusline+=%{$USER}\ @\ %{hostname()}\
" }

" status line {
"set laststatus=2
"set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
"set statusline+=\ \ \ [%{&ff}/%Y] 
"set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
"set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L
"
"function! CurDir()
"    let curdir = substitute(getcwd(), $HOME, "~", "")
"    return curdir
"endfunction
"
"function! HasPaste()
"    if &paste
"        return '[PASTE]'
"    else
"        return ''
"    endif
"endfunction
" }


" 自動命令
" autocmd - vim在讀寫文件，緩衝區，或退出文件時，都可以指定要自動執行的命令;
"           autocmd {event} {file name pattern,} {command |}
" BufNewFile - 編輯一個不存在的文件。
" BufRead - 讀取一個已存在的文件。
" file name pattern － 使用 “，”分隔多種檔案。
" command - 使用 “｜”分隔多個命令。
" 例如：可以設定遇到 *.c 的文件時，自動設定cindent選項。
autocmd BufNewFile,BufRead *.c set cindent

" 例如：設定在 Makefile 裡不將 tab 展開 (Makefile 裡必需是 Tab 不能是空格)
autocmd BufNewFile,BufRead ?akefile*,*.mk  set noexpandtab
autocmd BufNewFile,BufRead *.html,*.htm,*.css,*.js set noexpandtab tabstop=2 shiftwidth=2

" 可以在vim 中查看該檔案的編碼為何

" 在右下角顯示組合指令目前的輸入狀態
set showcmd

" ------|其它配置|------
" writebackup - 儲存文件前先建立備份文件, 儲存成功後刪除該備份
" nobackup - 設定無備份文件
" noswapfile - 設定無臨時文件
" vb t_vb= - 關閉提示音
set writebackup
set nobackup
" set noswapfile
" disable sound on errors
set noerrorbells
set novisualbell
set vb t_vb=
set tm=500

" 快速輸入設定
" 自動完成括號和引號
inoremap ( ()<esc>:let leavechar=")"<cr>i
inoremap [ []<esc>:let leavechar="]"<cr>i
inoremap { {}<esc>:let leavechar="}"<cr>i
inoremap <leader>4 {<esc>o}<esc>:let leavechar="}"<cr>O
inoremap ' ''<esc>:let leavechar="'"<cr>i
inoremap " ""<esc>:let leavechar='"'<cr>i

" 開啟NERDTree快速鍵設定
" nnoremap <silent> <F2> :NERDTree<CR>
" nmap <F2> :NERDTreeToggle <CR>""
