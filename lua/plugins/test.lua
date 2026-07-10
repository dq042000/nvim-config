-- 測試面板 adapter：PHPUnit 與 Vitest（test.core extra 只提供框架，adapter 要自己加）
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "olimorris/neotest-phpunit",
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-phpunit"] = {},
        ["neotest-vitest"] = {},
      },
    },
  },
}
