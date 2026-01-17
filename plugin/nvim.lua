local l = require("leree")

vim.api.nvim_set_hl(0, "LereeMark", { fg = "#ebaaf2", bg = "NONE", bold = true })

vim.api.nvim_create_user_command("Leree", function(_)
	l.toggle_marks()
end, {
	range = true,
	nargs = 0,
	desc = "Leree: Creates marks",
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	pattern = "*",
	callback = function(opts)
		local marks = l.get_buf_marks(opts.buf)
		if #marks ~= 0 then
			l.delete_all_marks(opts.buf, marks)
		end
	end,
})
