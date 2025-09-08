" 1. 自动安装 vim-plug 本身（如果它还没有被安装的话）
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" 启用文件类型检测和插件加载
filetype on
filetype plugin on
filetype indent on
syntax enable


" 设置 leader 键为空格
let mapleader = " "
" 设置粘贴模式切换快捷键
" set pastetoggle=<C-p>



" 基础设置
set nocompatible              " 不使用 Vi 兼容模式
set number                    " 显示行号
set cursorline                " 高亮当前行
set scrolloff=5               " 滚动时保留5行可见
set ambiwidth=double
set autoread                  " 文件在外部被修改时自动重新读取
set autowriteall             " 自动保存修改
set hidden                   " 允许在不保存的情况下切换缓冲区
set hlsearch                 " 高亮搜索匹配
set ignorecase               " 搜索时忽略大小写
set smartcase                " 如果有大写字母，则区分大小写
set smartindent              " 智能缩进
set shiftwidth=4             " 自动缩进使用的宽度
set tabstop=4                " Tab 键的宽度
set expandtab                " 将 Tab 转换为空格
set backup                   " 启用备份
set undofile                 " 启用撤销历史持久化
set undodir=~/.vimtmp/undodir " 撤销文件目录
set backupdir=~/.vimtmp/backupdir " 备份文件目录
set directory=~/.vimtmp/directory " 交换文件目录
set encoding=utf-8           " 使用 UTF-8 编码
set fileencodings=ucs-bom,utf-8,cp936 " 文件编码检测顺序
set clipboard+=unnamed       " 使用系统剪贴板
set showcmd                  " 显示正在输入的命令
set laststatus=2             " 总是显示状态栏

" 创建必要的目录
call system('mkdir -p ~/.vimtmp/undodir ~/.vimtmp/backupdir ~/.vimtmp/directory')

" 插件管理 - vim-plug
call plug#begin('~/.vim/plugged')

" Go 语言开发核心插件
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }  " Go 语言支持

" 辅助插件
Plug 'jiangmiao/auto-pairs'        " 自动补全符号
Plug 'preservim/nerdtree'         " 文件浏览器
Plug 'tpope/vim-commentary'        " 快速注释
Plug 'itchyny/lightline.vim'       " 状态栏
Plug 'mbbill/undotree'             " 可视化撤销历史
Plug 'tpope/vim-fugitive'          " Git 集成
Plug 'kien/ctrlp.vim'              " 搜索

" 主题
Plug 'ghifarit53/tokyonight-vim'   " 主题
Plug 'NLKNguyen/papercolor-theme'

call plug#end()

" 主题设置
colorscheme PaperColor  
set background=dark
" colorscheme tokyonight  
" let g:tokyonight_style = 'dark'  
" let g:tokyonight_enable_italic = 0

" NERDTree 文件浏览器设置
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30
nmap <leader>n :NERDTreeToggle<CR>
" nmap <leader>f :NERDTreeFind<CR>

" vim-go 配置
let g:go_highlight_types = 1           " 高亮类型
let g:go_highlight_fields = 1          " 高亮字段
let g:go_highlight_functions = 1       " 高亮函数
let g:go_highlight_function_calls = 1  " 高亮函数调用
let g:go_highlight_operators = 1       " 高亮操作符
let g:go_highlight_extra_types = 1     " 高亮额外类型
let g:go_highlight_build_constraints = 1 " 高亮构建约束
let g:go_fmt_autosave = 1              " 保存时自动格式化
let g:go_fmt_command = "goimports"     " 使用 goimports 而不是 gofmt
let g:go_def_mapping_enabled = 0       " 禁用默认的跳转定义映射(使用coc.nvim的)

" 自定义 Go 快捷键
autocmd FileType go nmap <leader>r :GoRun %<CR>
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage)
autocmd FileType go inoremap <Leader>i <Plug>(go-info)
autocmd FileType go inoremap <silent> <Leader>t <C-x><C-o>

" 使用 K 显示文档
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" 自动命令组
augroup go_autocmds
    autocmd!
    " Go 文件保存时自动格式化
    autocmd BufWritePre *.go :silent! call CocAction('format')
    " 设置 Go 文件的缩进
    autocmd FileType go setlocal shiftwidth=4 tabstop=4 noexpandtab
augroup END

" 清除搜索高亮
nmap <silent> <leader>/ :nohlsearch<CR>

" 快速打开 vimrc
nmap <leader>v :e $MYVIMRC<CR>
nmap <leader>y :source %<CR>
" 基本配置
let g:undotree_WindowLayout = 2      " 窗口布局
let g:undotree_SplitWidth = 30       " 窗口宽度
let g:undotree_DiffpanelHeight = 10  " 差异面板高度
let g:undotree_SetFocusWhenToggle = 1 " 切换时获取焦点

" 快捷键映射
nnoremap <leader>h :UndotreeToggle<CR>

"ctrlp
"
let g:ctrlp_map = '<leader>pp'
let g:ctrlp_cmd = 'CtrlP'
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
            \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
            \ }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
