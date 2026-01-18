local l = require("leree")

vim.api.nvim_set_hl(0, "LereeMark", { fg = "#ebaaf2", bg = "NONE", bold = true })

vim.api.nvim_create_user_command("LereeEnable", function(_)
	l.enable_marks()
end, {
	range = true,
	nargs = 0,
	desc = "Leree: Enable marks",
})

vim.api.nvim_create_user_command("LereeDisable", function(_)
	l.disable_marks()
end, {
	range = true,
	nargs = 0,
	desc = "Leree: Disable marks",
})

vim.api.nvim_create_user_command("LereeToggle", function(_)
	l.toggle_marks()
end, {
	range = true,
	nargs = 0,
	desc = "Leree: Toggle marks",
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	pattern = "*",
	callback = function()
		l.disable_marks()
	end,
})
