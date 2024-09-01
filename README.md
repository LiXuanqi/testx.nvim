# testx.nvim

```lua
  {
    'Lixuanqi/testx.nvim',
    opts = {
      mocha = {
        single_test_cmd = "mocha ${rel} -g '${test}'",
        file_test_cmd = 'mocha ${rel}',
      },
    },
    dependencies = {
      'LiXuanqi/termx.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
```
