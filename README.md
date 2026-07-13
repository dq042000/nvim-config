# Neovim 設定（LazyVim）

以 LazyVim 為基礎，建置 PHP／Vue／TypeScript／Go 的 VSCode 等級 IDE 環境：
LSP 補全與跳轉、存檔自動格式化、ESLint、偵錯（DAP）、測試面板（neotest）、Claude Code 整合。

## 安裝步驟

### 1. 系統依賴

| 工具 | 用途 | 安裝方式 |
|---|---|---|
| Neovim 0.10+ | — | 官方套件或 PPA |
| git、gcc | 外掛安裝、treesitter 編譯 | `sudo apt install git build-essential` |
| Node.js / npm | 多數 LSP 是 npm 套件 | nvm |
| Go | gopls、delve | 官方安裝包 |
| PHP | intelephense、phpcs | `sudo apt install php` |
| ripgrep | 全域搜尋（`<leader>/`） | `sudo apt install ripgrep` |
| fzf | picker | `git clone https://github.com/junegunn/fzf ~/.fzf && ~/.fzf/install` |
| fd | 檔案搜尋 | [官方 release](https://github.com/sharkdp/fd/releases) binary 放 `~/.local/bin/fd` |
| lazygit | Git 介面（`<leader>gg`） | [官方 release](https://github.com/jesseduffield/lazygit/releases) binary 放 `~/.local/bin/lazygit` |
| claude CLI | claudecode.nvim 依賴 | `npm install -g @anthropic-ai/claude-code` |

### 2. 複製設定並啟動

```bash
git clone https://github.com/dq042000/nvim-config.git ~/.config/nvim
nvim
```

第一次啟動全自動：bootstrap lazy.nvim → 依 `lazy-lock.json` 安裝所有外掛 → 編譯 treesitter parser。
若外掛版本不一致，執行 `:Lazy restore` 對齊 lock 檔。

Mason 工具（LSP、formatter、debug adapter）會在開啟對應檔案時自動安裝，可開 `:Mason` 查看進度。

### 3. 手動降版 vue-language-server（必要）

Mason 預設會裝 3.x，但與現行 LazyVim 的 hybridMode 設定不相容，啟動會崩潰
（`ts.server.protocol` undefined）。必須鎖定 2.2.10：

```
:MasonInstall vue-language-server@2.2.10
```

> 之後若 `:Lazy update` 更新 LazyVim 到支援 vue_ls 3.x 的版本，才可同步升級。
> 在那之前不要手動 `:MasonInstall vue-language-server`（會裝回 3.x）。

### 4. PHP 偵錯：Xdebug（系統層）

```bash
sudo apt install php-xdebug
sudo tee /etc/php/*/mods-available/xdebug.ini <<'EOF'
zend_extension=xdebug.so
xdebug.mode=develop,debug
xdebug.start_with_request=trigger
EOF
```

`start_with_request=trigger`：只有帶 `XDEBUG_TRIGGER` 環境變數（CLI）或
`XDEBUG_SESSION` cookie（瀏覽器）時才連偵錯器，平常執行不受影響。

驗證：`php -i | grep xdebug.mode` 應顯示 `develop,debug`。

### 5. 驗證安裝

- `:checkhealth` — 檢查缺漏的依賴
- `:LazyExtras` — 確認 extras 已啟用（見下表）
- 開一個 `.php` / `.vue` / `.go` 檔，確認 LSP 掛載（`:LspInfo`）

## 多台電腦同步外掛版本

外掛版本由 `lazy-lock.json` 鎖定（記錄每個外掛的 commit），此檔已納入版本控制，
因此所有電腦都能還原出一致的外掛環境。工作流程：

1. **升級外掛（只在一台電腦做）**：`:Lazy update` 更新到上游最新版並改寫 lock 檔，
   確認沒問題後 commit `lazy-lock.json` 並 push。
2. **其他電腦同步**：`git pull` 之後執行 `:Lazy restore`，外掛就會對齊 lock 檔記錄的版本。
   不想開編輯器可直接在終端機執行：

   ```bash
   nvim --headless "+Lazy! restore" +qa
   ```

兩個指令的差別：`restore` 同步到 **lock 檔版本**（日常用這個）；
`update` 更新到**上游最新版**（主動升級才用，會改寫 lock 檔）。

### `git pull` 後 `lazyvim.json` 又出現變更？

`lazyvim.json` 不是純手寫設定檔，LazyVim 每次啟動都會自動回寫兩個欄位：

- `version` — lazyvim.json 的格式版本，跟著安裝的 LazyVim 走
- `news.NEWS.md` — 已讀過的 LazyVim NEWS.md 檔案大小

只要兩台電腦安裝的 LazyVim 版本不同，這兩個值就不一樣，誰開 nvim
誰就把檔案改成自己那版的值，造成 diff 改來改去。解法：

1. 在每台電腦 `git pull` 後執行 `:Lazy restore`，讓 LazyVim 版本對齊 lock 檔
2. 開一次 nvim 讓 `lazyvim.json` 更新，若有變更就 commit 推上去

之後所有電腦的 LazyVim 版本一致，`lazyvim.json` 就不會再被自動改動。
執行過 `:Lazy update` 升級 LazyVim 時，記得把 `lazy-lock.json` 和
`lazyvim.json` **一起 commit**，其他電腦 pull + restore 後才不會又漂移。

## 已啟用的 extras（`lazyvim.json`）

| 分類 | Extras |
|---|---|
| 語言 | php（intelephense）、vue、typescript（vtsls）、go、json、yaml、docker、markdown |
| 格式化／檢查 | formatting.prettier、linting.eslint |
| 偵錯／測試 | dap.core、test.core |
| 編輯 | editor.inc-rename |

自訂外掛（`lua/plugins/`）：

- `test.lua` — neotest 掛載 PHPUnit 與 Vitest adapter
- `claudecode.lua` — Claude Code 整合
- `transparent.lua` — 背景透明

## 常用按鍵

`<leader>` 為空格。

| 按鍵 | 功能 |
|---|---|
| `<leader>e` | 檔案樹（neo-tree） |
| `<leader><space>` | 快速開檔（VSCode 的 Ctrl+P） |
| `<leader>/` | 全域搜尋（VSCode 的 Ctrl+Shift+F） |
| `<leader>,` | 開啟中的 buffer 清單 |
| `Shift+h` / `Shift+l` | 上一個／下一個 buffer |
| `<leader>gg` | lazygit |
| `<leader>cr` | 重新命名（即時預覽） |
| `<leader>db` / `<leader>dc` | 中斷點／啟動偵錯 |
| `<leader>tt` | 跑當前檔案測試 |
| `Ctrl+b` | 視窗滿版 ⇄ 還原（自訂，取代預設翻頁；翻頁用 Ctrl+u） |
| `sh` `sj` `sk` `sl` | 視窗間移動 |
| `ss` / `sv` | 水平／垂直分割 |
| `<leader>qq` | 離開 nvim（關閉全部視窗） |

> `Ctrl+b` 為讓出全域綁定，已停用 noice（捲動 hover 文件）與
> Neo-tree（scroll_preview）各自的 `Ctrl+b`（見 `lua/plugins/noice.lua`、`neo-tree.lua`）。

### Claude Code（`<leader>a`）

| 按鍵 | 功能 |
|---|---|
| `Alt+r` | 開／關 Claude 側欄（自訂，側欄內也可直接按，不用脫離終端機模式） |
| `<leader>ac` | 開／關 Claude 側欄 |
| `<leader>af` | 跳到 Claude 視窗 |
| `<leader>ab` | 把目前檔案加入 context |
| `<leader>as` | （visual）送選取範圍給 Claude |
| `<leader>aa` / `<leader>ad` | 接受／拒絕 diff |
| `<leader>ar` / `<leader>aC` | resume／continue 對話 |

側欄是終端機模式：快速連按兩下 `Esc` 回 normal mode（單按會送給 Claude 當中斷），
或按 `<C-w>h` 直接跳回編輯視窗。

### PHP 偵錯流程

1. `<leader>db` 下中斷點
2. `<leader>dc` 選「Listen for Xdebug」
3. 終端機執行 `XDEBUG_TRIGGER=1 php script.php`（網頁請求帶 `XDEBUG_SESSION` cookie）

Go 偵錯不需額外設定，`<leader>dc` 直接可用（delve）。

## 相關連結

- [LazyVim 官方 GitHub](https://github.com/LazyVim/LazyVim)
- [LazyVim 安裝教學](https://lazyvim.github.io/installation)

## 常見問題

- 相依套件安裝失敗：確認網路連線，或開 `:Lazy` / `:Mason` 手動重試。
- Vue LSP 啟動就崩潰：vue-language-server 被升到 3.x 了，重跑步驟 3 降回 2.2.10。
- 按 `Ctrl+b` 出現 `module 'snacks.zen' not found`：snacks.nvim 版本太舊
  （`zen` 模組是 2024-11 之後才加入的功能），執行 `:Lazy restore` 對齊 lock 檔即可。
- 設定檔路徑預設為 `~/.config/nvim`。
