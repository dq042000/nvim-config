-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- 選取全部內容
keymap.set("n", "<C-a>", "gg<S-v>G") -- 使用 `Ctrl+a` 選取整個文件

-- 新建標籤頁
keymap.set("n", "te", ":tabedit") -- 使用 `te` 開啟新標籤頁
keymap.set("n", "<tab>", ":tabnext<Return>", opts) -- 使用 `tab` 切換到下一個標籤頁
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts) -- 使用 `Shift+tab` 切換到上一個標籤頁

-- 分割視窗
keymap.set("n", "ss", ":split<Return>", opts) -- 使用 `ss` 水平分割視窗
keymap.set("n", "sv", ":vsplit<Return>", opts) -- 使用 `sv` 垂直分割視窗

-- 視窗間移動
keymap.set("n", "sh", "<C-w>h") -- 使用 `sh` 向左移動視窗
keymap.set("n", "sk", "<C-w>k") -- 使用 `sk` 向上移動視窗
keymap.set("n", "sj", "<C-w>j") -- 使用 `sj` 向下移動視窗
keymap.set("n", "sl", "<C-w>l") -- 使用 `sl` 向右移動視窗
