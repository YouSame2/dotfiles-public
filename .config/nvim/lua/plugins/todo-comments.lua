return {
	"folke/todo-comments.nvim",
	cond = not vim.g.vscode,
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = "VeryLazy",
	opts = {},
  -- stylua: ignore
  keys = {
    {
      "]t",
      function() require("todo-comments").jump_next() end,
      desc = "Next [t]odo Comment"
    },
    {
      "[t",
      function() require("todo-comments").jump_prev() end,
      desc = "Previous [t]odo Comment"
    },
    {
      "<leader>ft",
      "<cmd>TodoTelescope<cr>",
      desc = "[f]ind [t]odo"
    },
    {
      "<leader>fT",
      "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
      desc = "[f]ind [t]odo/fix/fixme"
    },
  },
}
