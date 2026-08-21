-- 釋放 Neo-tree 內的 Ctrl+B（原為 scroll_preview），讓全域的視窗滿版切換也能在檔案樹裡用
-- 並讓檔案樹顯示隱藏檔與 .gitignore 忽略的檔案，與 snacks picker 的行為一致
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_ignored = false,
        -- 相依套件與編輯器歷史目錄預設仍收起來，避免清單被淹沒；在檔案樹按 H 可暫時顯示
        hide_by_name = {
          "node_modules",
          "vendor",
          ".git",
          ".history",
          "dist",
          "build",
        },
      },
    },
    window = {
      mappings = {
        ["<C-b>"] = "none",
      },
    },
  },
}
