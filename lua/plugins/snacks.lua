-- picker 找檔案時也顯示隱藏檔與 .gitignore 忽略的檔案（例如 config/autoload/local.php），
-- 但排除相依套件與編輯器歷史目錄，避免清單被 node_modules／vendor 淹沒
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = true,
          exclude = {
            "node_modules",
            "vendor",
            ".git",
            ".history",
            "dist",
            "build",
          },
        },
      },
    },
  },
}
