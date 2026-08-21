<!-- 快速鍵總表；設定來源見 lua/config/keymaps.lua 與 lua/plugins/ -->

# 快速鍵

`<leader>` 為空格。分成兩部分：**自訂**（這個 repo 自己設定的，改了就會反映在這裡）
與 **LazyVim 內建**（extras 帶來的常用鍵）。

忘記按鍵時，按下 `<leader>`（空格）不動，which-key 會列出所有可用的後續按鍵。

## 自訂：視窗與分割（`lua/config/keymaps.lua`）

| 按鍵                | 模式   | 功能                                   |
| ------------------- | ------ | -------------------------------------- |
| `ss`                | normal | 水平分割視窗                           |
| `sv`                | normal | 垂直分割視窗                           |
| `sh` `sj` `sk` `sl` | normal | 往左／下／上／右移動到相鄰視窗         |
| `Ctrl+b`            | normal | 目前視窗滿版 ⇄ 還原（Snacks zen zoom） |

`Ctrl+b` 覆蓋了 vim 預設的「往上翻頁」，翻頁請改用 `Ctrl+u`。
為了讓這個鍵在任何視窗都有效，另外停用了 noice 的捲動 hover 文件
（`lua/plugins/noice.lua`）與 Neo-tree 的 scroll_preview（`lua/plugins/neo-tree.lua`）。

## 自訂：標籤頁與選取（`lua/config/keymaps.lua`）

| 按鍵        | 模式   | 功能                                               |
| ----------- | ------ | -------------------------------------------------- |
| `te`        | normal | 開新標籤頁（會停在命令列等你輸入檔名，再按 Enter） |
| `Tab`       | normal | 切到下一個標籤頁                                   |
| `Shift+Tab` | normal | 切到上一個標籤頁                                   |
| `Ctrl+a`    | normal | 選取整個檔案（`gg` + visual line + `G`）           |

`Ctrl+a` 覆蓋了 vim 預設的「游標下數字 +1」，需要遞增數字時請用
`:normal! <C-a>`。

### buffer、視窗、標籤頁是三件事

畫面上方那條顯示檔名的橫條是 bufferline，列的是 **buffer** 而不是標籤頁，
所以在那裡按 `Tab` 不會切換檔案——這是最容易搞混的地方。

- **buffer**：一個已開啟檔案在記憶體裡的內容。開兩個檔案就有兩個 buffer，
  把畫面切走 buffer 仍留在背景，要真的關掉得按 `<leader>bd`。
- **視窗（window）**：畫面上的一個框，用來顯示某個 buffer。分割視窗就是多開框。
- **標籤頁（tab page）**：一整組視窗排版，不是「一個檔案」。適合一組排版放前端、
  另一組放後端，切過去整份版面一起換。

| 想切換的東西   | 按鍵                                        |
| -------------- | ------------------------------------------- |
| buffer（檔案） | `Shift+h`／`Shift+l`，或 `<leader>,` 選清單 |
| 視窗           | `sh` `sj` `sk` `sl`                         |
| 標籤頁         | `Tab`／`Shift+Tab`                          |

關閉 buffer（LazyVim 內建）：

| 按鍵         | 功能                                     |
| ------------ | ---------------------------------------- |
| `<leader>bd` | 關掉目前 buffer（視窗保留）              |
| `<leader>bo` | 只留目前這個，其他 buffer 全關           |
| `<leader>bi` | 關掉沒顯示在任何視窗的 buffer            |
| `<leader>bD` | 關掉 buffer 並一起關掉視窗（原生 `:bd`） |
| `<leader>bb` | 切回上一個待過的 buffer                  |

`<leader>bd` 不會離開 nvim；buffer 全關光只會回到 LazyVim 起始畫面，
要離開請用 `<leader>qq`。

## 自訂：Claude Code（`lua/plugins/claudecode.lua`）

| 按鍵         | 模式             | 功能                                                     |
| ------------ | ---------------- | -------------------------------------------------------- |
| `Alt+r`      | normal、terminal | 開／關 Claude 側欄（側欄內也能按，不用先脫離終端機模式） |
| `<leader>ac` | normal           | 開／關 Claude 側欄                                       |
| `<leader>af` | normal           | 跳到 Claude 視窗                                         |
| `<leader>ar` | normal           | resume 舊對話                                            |
| `<leader>aC` | normal           | continue 上一次對話                                      |
| `<leader>ab` | normal           | 把目前檔案加入 context                                   |
| `<leader>as` | visual           | 送選取範圍給 Claude                                      |
| `<leader>aa` | normal           | 接受 diff                                                |
| `<leader>ad` | normal           | 拒絕 diff                                                |

側欄是終端機模式：快速連按兩下 `Esc` 回 normal mode（單按會被送給 Claude 當中斷），
或按 `Ctrl+w` `h` 直接跳回編輯視窗。

## LazyVim 內建：檔案、搜尋、Git

| 按鍵                  | 功能                                   |
| --------------------- | -------------------------------------- |
| `<leader>e`           | 檔案樹（neo-tree）                     |
| `<leader><space>`     | 快速開檔（VSCode 的 Ctrl+P）           |
| `<leader>/`           | 全域搜尋內容（VSCode 的 Ctrl+Shift+F） |
| `<leader>,`           | 開啟中的 buffer 清單                   |
| `Shift+h` / `Shift+l` | 上一個／下一個 buffer                  |
| `<leader>bd`          | 關閉目前 buffer                        |
| `<leader>gg`          | lazygit                                |
| `<leader>cr`          | 重新命名符號（即時預覽，inc-rename）   |
| `<leader>ca`          | code action                            |
| `<leader>qq`          | 離開 nvim（關閉全部視窗）              |

## LazyVim 內建：搜尋與開檔（picker）

picker 由 snacks.nvim 提供（LazyVim 預設）。先分清楚兩種搜尋：

| 想找什麼                          | 按鍵              | 對應 VSCode    |
| --------------------------------- | ----------------- | -------------- |
| **檔名** — 知道檔案叫什麼         | `<leader><space>` | `Ctrl+P`       |
| **內容** — 只知道檔案裡有哪段文字 | `<leader>/`       | `Ctrl+Shift+F` |

搜尋範圍預設是**專案根目錄**（往上找到含 `.git` 的那層），不是整台電腦。
大寫版本（如 `<leader>fF`、`<leader>sG`）改用目前工作目錄。

找檔案（`<leader>f`）：

| 按鍵         | 功能                            |
| ------------ | ------------------------------- |
| `<leader>ff` | 找檔案（專案根目錄）            |
| `<leader>fF` | 找檔案（目前工作目錄）          |
| `<leader>fg` | 只找 git 追蹤中的檔案           |
| `<leader>fr` | 最近開過的檔案                  |
| `<leader>fb` | 目前開著的 buffer               |
| `<leader>fc` | 找 nvim 設定檔（跳來這個 repo） |

找內容與其他（`<leader>s`）：

| 按鍵         | 功能                                      |
| ------------ | ----------------------------------------- |
| `<leader>sg` | 搜尋內容（等同 `<leader>/`）              |
| `<leader>sw` | 搜尋游標所在的字（visual 模式搜選取範圍） |
| `<leader>sb` | 只搜目前這個檔案的每一行                  |
| `<leader>ss` | 搜尋目前檔案的符號（函式、類別、變數）    |
| `<leader>sd` | 搜尋診斷訊息（錯誤與警告）                |
| `<leader>sk` | 搜尋所有 keymap（忘記按鍵時用這個）       |
| `<leader>sR` | 重開上一次的搜尋結果                      |

picker 視窗裡的操作：

| 按鍵                         | 功能                 |
| ---------------------------- | -------------------- |
| 打字                         | 即時過濾             |
| `↓`／`↑`、`Ctrl+j`／`Ctrl+k` | 上下選擇             |
| `Enter`                      | 開啟                 |
| `Ctrl+v`／`Ctrl+s`           | 以垂直／水平分割開啟 |
| `Ctrl+t`                     | 以新標籤頁開啟       |
| `Alt+i`                      | 切換顯示被忽略的檔案 |
| `Alt+h`                      | 切換顯示隱藏檔       |
| `Alt+p`                      | 切換預覽視窗         |
| `Esc`                        | 關掉 picker          |

picker 有三個視窗：搜尋框、結果列表、預覽。焦點切換：

| 情況                    | 按鍵                              |
| ----------------------- | --------------------------------- |
| 搜尋框 → 結果列表       | 先 `Esc` 進 normal mode，再按 `/` |
| 結果列表／預覽 → 搜尋框 | `i`，或再按一次 `/`               |
| 三個視窗循環            | `Alt+w`                           |

在結果列表裡可以用 vim 的移動鍵：`j` `k` 上下、`gg` 跳頂、`G` 跳底。

三個容易踩到的地方：

- 一般選檔案不必把游標移進列表，在搜尋框直接按 `Ctrl+j`／`Ctrl+k` 就能選，
  還能繼續改關鍵字。
- `Esc` 是兩段：第一次離開 insert mode（picker 還開著），第二次才關掉 picker。
- 列表裡的 `Tab` 是「選取並往下」（多選檔案用），不是切換焦點。

`Alt` 開頭的鍵在部分終端機會被拆成 `Esc` + 按鍵送出，按下後焦點可能掉到列表，
按 `i` 回搜尋框即可。找不到 `.gitignore` 忽略的檔案時不必每次按 `Alt+i`——
`lua/plugins/snacks.lua` 已讓找檔案預設就顯示這些檔案。

## LazyVim 內建：測試（neotest，`<leader>t`）

| 按鍵         | 功能                            |
| ------------ | ------------------------------- |
| `<leader>tt` | 跑目前檔案的測試                |
| `<leader>tT` | 跑整個專案的測試                |
| `<leader>tr` | 跑游標所在的那個測試            |
| `<leader>tl` | 重跑上一次的測試                |
| `<leader>ts` | 開／關測試清單側欄              |
| `<leader>to` | 顯示測試輸出                    |
| `<leader>tO` | 開／關輸出面板                  |
| `<leader>tS` | 停止正在跑的測試                |
| `<leader>tw` | 開／關 watch 模式（存檔就重跑） |
| `<leader>td` | 用偵錯器跑游標所在的測試        |

adapter 為 PHPUnit 與 Vitest（見 `lua/plugins/test.lua`）。

## LazyVim 內建：偵錯（DAP，`<leader>d`）

| 按鍵         | 功能                          |
| ------------ | ----------------------------- |
| `<leader>db` | 切換中斷點                    |
| `<leader>dB` | 條件式中斷點（輸入條件）      |
| `<leader>dc` | 開始／繼續執行                |
| `<leader>dC` | 執行到游標處                  |
| `<leader>di` | step into                     |
| `<leader>dO` | step over                     |
| `<leader>do` | step out                      |
| `<leader>du` | 開／關偵錯 UI                 |
| `<leader>de` | 求值（normal 或 visual 選取） |
| `<leader>dr` | 開／關 REPL                   |
| `<leader>dt` | 結束偵錯                      |

## PHP 偵錯流程

1. `<leader>db` 下中斷點
2. `<leader>dc` 選「Listen for Xdebug」
3. 終端機執行 `XDEBUG_TRIGGER=1 php script.php`（網頁請求帶 `XDEBUG_SESSION` cookie）

Go 偵錯不需額外設定，`<leader>dc` 直接可用（delve）。
