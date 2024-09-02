local M = {}

local function get_test_path(source_path)
	-- Replace .tsx with .test.tsx
	return source_path:gsub("%.tsx$", ".test.tsx")
end

local function get_source_path(test_path)
	-- Replace .test.tsx with .tsx
	return test_path:gsub("%.test%.tsx$", ".tsx")
end

function M.switch_file()
	local current_file = vim.api.nvim_buf_get_name(0)
	local new_file

	if current_file:match("%.test%.tsx$") then
		new_file = get_source_path(current_file)
	elseif current_file:match("%.tsx$") then
		new_file = get_test_path(current_file)
	else
		print("Current file does not match expected patterns.")
		return
	end

	-- Check if the file exists before attempting to switch
	local file_exists = vim.fn.filereadable(new_file) == 1
	if file_exists then
		vim.cmd("edit " .. new_file)
	else
		print("File does not exist: " .. new_file)
	end
end

return M
