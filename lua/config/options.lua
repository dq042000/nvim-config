-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

vim.opt.clipboard = "unnamedplus" -- 讓 Vim 使用系統剪貼簿（與系統剪貼簿同步）

-- 設定 Leader 鍵為空格
vim.g.mapleader = " "

-- 編碼設定
vim.opt.encoding = "utf-8" -- 設定內部字元編碼為 UTF-8
vim.opt.fileencoding = "utf-8" -- 設定文件編碼為 UTF-8

-- 行號顯示
vim.opt.number = true -- 顯示行號

-- 顯示檔案標題
vim.opt.title = true -- 顯示檔案標題

-- 縮排設定
vim.opt.autoindent = true -- 自動縮排
vim.opt.smartindent = true -- 智能縮排

-- 搜尋設定
vim.opt.hlsearch = true -- 搜尋後高亮顯示
vim.opt.ignorecase = true -- 忽略搜尋大小寫（除非包含大寫字母）
vim.opt.inccommand = "split" -- 顯示增量指令結果分割視窗

-- 禁用備份文件
vim.opt.backup = false -- 禁用備份文件

-- 顯示設定
vim.opt.showcmd = true -- 顯示指令資訊
vim.opt.cmdheight = 1 -- 設定指令行高度
vim.opt.laststatus = 3 -- 全局狀態行模式
vim.opt.expandtab = true -- 用空格替代 Tab
vim.opt.scrolloff = 10 -- 滾動時保留游標周圍行數
vim.opt.wrap = false -- 禁用自動換行

-- 跳過特定目錄的備份
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }

-- Tab 和縮排設定
vim.opt.smarttab = true -- 智能縮排 Tab
vim.opt.breakindent = true -- 保持換行縮排
vim.opt.shiftwidth = 2 -- 自動縮排的寬度
vim.opt.tabstop = 2 -- Tab 縮排的寬度
vim.opt.backspace = { "start", "eol", "indent" } -- 支持退格鍵刪除縮排

-- 文件查找和忽略
vim.opt.path:append({ "**" }) -- 允許在子目錄中查找文件
vim.opt.wildignore:append({ "*/node_modules/*" }) -- 忽略 node_modules 目錄

-- 分割視窗行為
vim.opt.splitbelow = true -- 新分割窗口顯示在當前窗口下方
vim.opt.splitright = true -- 新分割窗口顯示在當前窗口右側
vim.opt.splitkeep = "cursor" -- 保持游標位置在分割窗口內

-- 禁用滑鼠操作
vim.opt.mouse = ""

-- 底線（Undercurl）設定
vim.cmd([[let &t_Cs = "\e[4:3m"]]) -- 啟用底線樣式
vim.cmd([[let &t_Ce = "\e[4:0m"]]) -- 關閉底線樣式

-- 區塊註釋時自動加入星號
vim.opt.formatoptions:append({ "r" })

-- 自動設置文件類型
vim.cmd([[au BufNewFile,BufRead *.astro setf astro]]) -- .astro 文件設為 astro 語法
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]]) -- Podfile 設為 ruby 語法

-- nvim 0.8 以上版本的指令行高度設定
if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0 -- 如果是 nvim 0.8，將指令行高度設為 0
end
