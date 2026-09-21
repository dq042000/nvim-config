# Neovim 設定（LazyVim）

以 LazyVim 為基礎，建置 PHP／Vue／TypeScript／Go 的 VSCode 等級 IDE 環境：
LSP 補全與跳轉、存檔自動格式化、ESLint、偵錯（DAP）、測試面板（neotest）、Claude Code 整合。

## 安裝步驟

### 1. 系統依賴

| 工具            | 用途                                      | 安裝方式                                                                                                                                         |
| --------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Neovim 0.11.2+  | LazyVim 16 的最低要求                     | 官方套件或 PPA                                                                                                                                   |
| git、gcc        | 外掛安裝、treesitter 編譯                 | `sudo apt install git build-essential`                                                                                                           |
| Node.js / npm   | 多數 LSP 是 npm 套件                      | nvm                                                                                                                                              |
| Go              | gopls、delve                              | 官方安裝包                                                                                                                                       |
| PHP             | intelephense、phpcs                       | `sudo apt install php`                                                                                                                           |
| ripgrep         | 全域搜尋（`<leader>/`）                   | `sudo apt install ripgrep`                                                                                                                       |
| fzf             | picker                                    | `git clone https://github.com/junegunn/fzf ~/.fzf && ~/.fzf/install`                                                                             |
| fd              | 檔案搜尋                                  | [官方 release](https://github.com/sharkdp/fd/releases) binary 放 `~/.local/bin/fd`                                                               |
| lazygit         | Git 介面（`<leader>gg`）                  | [官方 release](https://github.com/jesseduffield/lazygit/releases) binary 放 `~/.local/bin/lazygit`                                               |
| tree-sitter CLI | nvim-treesitter（main branch）編譯 parser | [官方 release](https://github.com/tree-sitter/tree-sitter/releases) binary 放 `~/.local/bin/tree-sitter`（Mason 也會自動裝，網路慢時見常見問題） |
| claude CLI      | claudecode.nvim 依賴                      | `npm install -g @anthropic-ai/claude-code`                                                                                                       |

### 2. 複製設定並啟動

```bash
git clone https://github.com/dq042000/nvim-config.git ~/.config/nvim
nvim
```

第一次啟動全自動：bootstrap lazy.nvim → 依 `lazy-lock.json` 安裝所有外掛 → 編譯 treesitter parser。
若外掛版本不一致，執行 `:Lazy restore` 對齊 lock 檔。

Mason 工具（LSP、formatter、debug adapter）會在開啟對應檔案時自動安裝，可開 `:Mason` 查看進度。

### 3. 確認 vue-language-server 為 3.x（必要）

Vue LSP 必須與 LazyVim 的 vue extra 對齊。LazyVim 16.x 的 vue extra 改用
`vue_ls` 搭配 vtsls 的 `@vue/typescript-plugin`，需要 vue-language-server 3.x。
若 Mason 裝的仍是 2.x，`vue_ls` 會 initialize 失敗，只剩 vtsls 掛得上去：

```vim
:MasonInstall vue-language-server
```

> 2026-09-21 以前這裡的規則是相反的：舊版 LazyVim 的 vue extra 用 2.x
> hybridMode，必須鎖定 `vue-language-server@2.2.10`，裝 3.x 會崩潰
> （`ts.server.protocol` undefined）。LazyVim 升到 16.0.1 後限制已解除。
> 升級 LazyVim 大版本時，記得回頭確認這兩者是否仍然對齊。

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

### 自動化：pull 後自動 restore（post-merge hook）

repo 內附 `.githooks/post-merge`：`git pull` 後若 `lazy-lock.json` 有變更，
自動執行 `Lazy! restore` 對齊外掛本體，並偵測「lock 檔被回寫」的降級污染
（自動還原重試，失敗時警告勿 commit）。每台電腦啟用一次：

```bash
git config core.hooksPath .githooks
```

注意 `git pull --rebase` 不會觸發 post-merge，rebase 後請手動跑 restore。

### Mason 工具不在同步範圍

`lazy-lock.json` 只鎖 lazy 外掛。Mason 裝的 LSP、formatter、debug adapter
放在 `~/.local/share/nvim/mason/`，不在本 repo 內，`git pull` 與
`:Lazy restore` 都同步不到，各台電腦的版本可能不一樣。

平常不必特別處理：缺少的 Mason 工具會在開啟對應檔案時自動安裝。但
**LazyVim 有大版本變動時要手動檢查**，因為新版 extra 可能改用不同的
LSP，或要求不同的大版本。

實例：2026-09-21 這次 `:Lazy update` 把 LazyVim 帶到 16.0.1，vue extra
改用 `vue_ls`，而 Mason 裡的 vue-language-server 仍是 2.2.10，開 `.vue`
時 `vue_ls` 會 initialize 失敗。每台電腦都要跑一次：

```vim
:MasonInstall vue-language-server
```

確認方式：pull 後開一個平常在寫的檔案（`.php` / `.vue` / `.go`），
用 `:LspInfo` 檢查該掛的 LSP 是否都掛上了。

### 沒跑 update，`lazy-lock.json` 卻出現大量變更？

在外掛仍是舊版的電腦上開 nvim（例如 pull 後忘了 restore），lazy.nvim
安裝完缺少的外掛後，會用「本機已安裝的舊版本」回寫 lock 檔——
這是**降級污染**，不是升級。commit 推上去會換另一台電腦開檔噴錯，
形成兩台電腦互相污染的循環（實例：e5aeae9 把 LazyVim 16 降回 14.15，
但 nvim-treesitter 仍鎖 main 重寫版，開檔即噴 `query_predicates` 錯誤）。

處理方式：`git checkout -- lazy-lock.json` 丟掉回寫，再跑 `:Lazy restore`。
原則：**只有主動跑過 `:Lazy update` 才 commit lock 檔**，commit 前確認
diff 方向是升級而非降級。

### LazyVim 大版本升級要 update 兩次

`:Lazy update` 執行當下，外掛規格來自「當時已安裝的舊版 LazyVim」。
若這次 update 剛好把 LazyVim 升了大版本（例如 15 → 16），相依外掛
（mason-lspconfig、nvim-treesitter 等）仍照舊規格鎖定，會寫出一組
互不相容的 lock 檔，下次啟動就噴錯（實例見常見問題）。

**正確流程**：`:Lazy update` → 重開 nvim → 再跑一次 `:Lazy update`，
確認開檔沒有錯誤後，才 commit lock 檔並 push。

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

| 分類         | Extras                                                                          |
| ------------ | ------------------------------------------------------------------------------- |
| 語言         | php（intelephense）、vue、typescript（vtsls）、go、json、yaml、docker、markdown |
| 格式化／檢查 | formatting.prettier、linting.eslint                                             |
| 偵錯／測試   | dap.core、test.core                                                             |
| 編輯         | editor.inc-rename                                                               |

自訂外掛（`lua/plugins/`）：

- `test.lua` — neotest 掛載 PHPUnit 與 Vitest adapter
- `claudecode.lua` — Claude Code 整合
- `transparent.lua` — 背景透明

## 快速鍵

完整按鍵總表（自訂鍵、buffer／視窗／標籤頁的差別、LazyVim 內建常用鍵、
測試與偵錯、PHP 偵錯流程）移到 **[KEYMAPS.md](KEYMAPS.md)**。

## 相關連結

- [LazyVim 官方 GitHub](https://github.com/LazyVim/LazyVim)
- [LazyVim 安裝教學](https://lazyvim.github.io/installation)

## 常見問題

- 相依套件安裝失敗：確認網路連線，或開 `:Lazy` / `:Mason` 手動重試。
- Vue LSP 掛不上、開 `.vue` 只剩 vtsls，訊息是
  `Cannot read properties of undefined (reading 'typescript')`：
  vue-language-server 還停在 2.x，執行 `:MasonInstall vue-language-server`
  升到 3.x（見步驟 3）。
- 按 `Ctrl+b` 出現 `module 'snacks.zen' not found`：snacks.nvim 版本太舊
  （`zen` 模組是 2024-11 之後才加入的功能），執行 `:Lazy restore` 對齊 lock 檔即可。
- 開檔噴 treesitter 的 `attempt to call method 'range'` 或
  `module 'mason-lspconfig.mappings' not found`：lock 檔鎖到不相容的外掛組合，
  通常是 LazyVim 大版本升級只 update 了一次（見「LazyVim 大版本升級要 update 兩次」）。
  修復方式——先清掉舊架構的 nvim-treesitter 再對齊 lock 檔：

  ```bash
  rm -rf ~/.local/share/nvim/lazy/nvim-treesitter ~/.local/share/nvim/lazy/nvim-treesitter-textobjects
  nvim --headless "+Lazy! restore" +qa
  ```

- Mason 安裝一直失敗、log 顯示 `Installation was aborted`：多半不是安裝壞掉，
  而是網路到 GitHub 太慢，nvim 在裝完前就被關掉。開著 nvim 等它跑完，
  或手動下載 binary（以 tree-sitter CLI 為例）：

  ```bash
  curl -L https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz \
    | gunzip > ~/.local/bin/tree-sitter && chmod +x ~/.local/bin/tree-sitter
  ```

- 設定檔路徑預設為 `~/.config/nvim`。
