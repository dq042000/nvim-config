-- 釋放 Neo-tree 內的 Ctrl+B（原為 scroll_preview），讓全域的視窗滿版切換也能在檔案樹裡用
return {
  "nvim-neotree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["<C-b>"] = "none",
      },
    },
  },
}
