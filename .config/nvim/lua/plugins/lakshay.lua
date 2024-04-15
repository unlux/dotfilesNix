return {
  { "wakatime/vim-wakatime", lazy = false },
  { -- comments
        'numToStr/Comment.nvim',
        opts = {},
        config = function()
            require("Comment").setup()
        end
  },
}
