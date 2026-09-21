return {
  -- VSCode Dark+ / Light+ 配色複刻
  { "Mofiqul/vscode.nvim" },

  -- 讓 LazyVim 啟動時載入 vscode 佈景主題
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
