local M = {}
local query = [[
	(call_expression
  function: (identifier) @function (#eq? @function "it")
  arguments: (arguments 
	       (string (string_fragment) @string))
  ) @it-block
]]
local mocha_it_block_query = vim.treesitter.query.parse("javascript", query)

local get_treesitter_root = function(bufnr)
	local parser = vim.treesitter.get_parser(bufnr, "javascript")
	local tree = parser:parse()[1]
	return tree:root()
end

local function get_mocha_test(bufnr, row)
	local root = get_treesitter_root(bufnr)
	for id, node, metadata, match in mocha_it_block_query:iter_captures(root, bufnr, 0, -1) do
		local name = mocha_it_block_query.captures[id]
		if name == "it-block" then
			local start_row, start_col, end_row, end_col = node:range()
			if row >= start_row and row <= end_row then
				-- Get the text of the 'it' block
				for child_id, child_node in mocha_it_block_query:iter_captures(node, bufnr, 0, -1) do
					local child_name = mocha_it_block_query.captures[child_id]
					if child_name == "string" then
						local block_text = vim.treesitter.get_node_text(child_node, bufnr)
						return block_text
					end
				end
			end
		end
	end
	return nil
end

M.run_test_in_current_cursor = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1 -- Treesitter uses 0-based indexing
	local test_name = get_mocha_test(bufnr, row)

	require("termx").run('mocha -g "' .. test_name .. '"')
end

M.setup = function()
	vim.keymap.set("n", "<leader>rt", M.run_test_in_current_cursor, { desc = "[R]un [T]est under cursor" })
end

return M
