return {
  "lewis6991/gitsigns.nvim",
  opts = {
    -- 像 VSCode GitLens 一樣，在游標所在行尾顯示 git blame
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text_pos = "eol",
      delay = 300,
      ignore_whitespace = true,
    },
    current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> · <summary>",
  },
}
