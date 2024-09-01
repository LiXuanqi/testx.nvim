local mocha_parser = require("testx.mocha-parser")
local M = {}
local opts = {}

local function is_debug_mode()
	return opts.debug_mode
end

local function build_mocha_under_cursor_test_cmd(absolute_path, relative_path, test_case_name)
	local template = opts.mocha.single_test_cmd
	return template:gsub("${(%w+)}", { test = test_case_name, rel = relative_path })
end

local function build_mocha_of_current_file_cmd(relative_path)
	local template = opts.mocha.file_test_cmd
	return template:gsub("${(%w+)}", { rel = relative_path })
end

M.run_test_under_cursor = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1 -- Treesitter uses 0-based indexing
	local test_case_name = mocha_parser.get_test_name_of_current_cursor(bufnr, row)

	if is_debug_mode() then
		print("Test case name: ", test_case_name)
	end

	local absolute_path = vim.api.nvim_buf_get_name(bufnr)
	local relative_path = vim.fn.fnamemodify(absolute_path, ":~:.") -- Convert to relative path
	local cmd = build_mocha_under_cursor_test_cmd(absolute_path, relative_path, test_case_name)

	require("termx").run(cmd)
end

M.run_test_of_current_file = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local absolute_path = vim.api.nvim_buf_get_name(bufnr)
	local relative_path = vim.fn.fnamemodify(absolute_path, ":~:.") -- Convert to relative path
	local cmd = build_mocha_of_current_file_cmd(relative_path)

	require("termx").run(cmd)
end

M.setup = function(_opts)
	opts = _opts
	vim.keymap.set("n", "<leader>rt", M.run_test_under_cursor, { desc = "[R]un [T]est under cursor" })
	vim.keymap.set("n", "<leader>ra", M.run_test_of_current_file, { desc = "[R]un [A]ll test in current file" })
end

return M
