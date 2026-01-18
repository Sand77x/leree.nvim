local api = vim.api
local M = {}

local defaults = {
	v_off = 4,
	h_off = 10,
	interval = 3,
	hide_on = { "<Esc>" },
	show_on = { "V" },
	toggle_on = {},
	hl = { fg = "#ebaaf2", bg = nil, bold = true },
}

M.buf_marks = {}
M.config = vim.deepcopy(defaults)
M.ns = api.nvim_create_namespace("LereeNvim")

M.get_buf_marks = function(bufnr)
	M.buf_marks[bufnr] = M.buf_marks[bufnr] or {}
	return M.buf_marks[bufnr]
end

M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", defaults, opts or {})
	M.config.v_off = math.max(0, M.config.v_off)
	M.config.h_off = math.max(0, M.config.h_off)
	M.config.interval = math.max(1, M.config.interval)

	for _, key in ipairs(M.config.show_on) do
		vim.keymap.set({ "n", "v", "o" }, key, function()
			M.enable_marks()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
		end, { noremap = true, silent = true })
	end

	for _, key in ipairs(M.config.hide_on) do
		vim.keymap.set({ "n", "v", "o" }, key, function()
			M.disable_marks()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
		end, { noremap = true, silent = true })
	end

	for _, key in ipairs(M.config.toggle_on) do
		vim.keymap.set({ "n", "v" }, key, function()
			M.toggle_marks()
		end, { noremap = true, silent = true })
	end
end

--- Creates a list of marks based on location of the cursor
M.create_marks = function(bufnr, marks)
	local cl = api.nvim_win_get_cursor(0)[1] - 1

	local f_line = vim.fn.line("w0") - 1
	local l_line = vim.fn.line("w$") - 1

	local ext_opts = {
		virt_text = { { "0 ", "LereeMark" } },
		virt_text_pos = "overlay",
		virt_text_win_col = M.config.h_off,
	}

	local max_dist = math.max(cl - f_line, l_line - cl)

	for i = M.config.v_off, max_dist, M.config.interval do
		local t = tostring(i)
		if #t == 1 then
			t = t .. " "
		end

		ext_opts.virt_text[1][1] = t

		if cl + i <= l_line then
			table.insert(marks, api.nvim_buf_set_extmark(bufnr, M.ns, cl + i, 0, ext_opts))
		end
		if cl - i >= 0 then
			table.insert(marks, api.nvim_buf_set_extmark(bufnr, M.ns, cl - i, 0, ext_opts))
		end
	end
end

M.delete_all_marks = function(bufnr, marks)
	for _, id in ipairs(marks) do
		api.nvim_buf_del_extmark(bufnr, M.ns, id)
	end
	M.buf_marks[bufnr] = nil
end

M.toggle_marks = function()
	local bufnr = api.nvim_get_current_buf()
	local marks = M.get_buf_marks(bufnr)

	if #marks == 0 then
		M.create_marks(bufnr, marks)
	else
		M.delete_all_marks(bufnr, marks)
	end
end

M.enable_marks = function()
	local bufnr = api.nvim_get_current_buf()
	local marks = M.get_buf_marks(bufnr)

	if #marks == 0 then
		M.create_marks(bufnr, marks)
	end
end

M.disable_marks = function()
	local bufnr = api.nvim_get_current_buf()
	local marks = M.get_buf_marks(bufnr)

	if #marks ~= 0 then
		M.delete_all_marks(bufnr, marks)
	end
end

return M
