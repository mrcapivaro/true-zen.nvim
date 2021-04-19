

local opts = require("config").options
local left_service = require("services.left.service")
local mode_minimalist = require("services.mode-minimalist.init")

local cmd = vim.cmd


local function fillchars()
	cmd([[set fillchars+=vert:\ ]])
	cmd([[set fillchars+=stl:\ ]])
	cmd([[set fillchars+=stlnc:\ ]])
end

function ataraxis_true()		-- show

	cmd("wincmd h")
	cmd("q")
	cmd("wincmd l")
	cmd("q")
	mode_minimalist.main(1)
	cmd([[call BufDo("lua require'services.left.init'.main(1)")]])
end

function ataraxis_false()		-- don't show

	-- padding
	-- local padding_cmd = "vertical resize "..cmd_settings.map_settings["ataraxis"]["left_right_padding"]..""
	local padding_cmd = "vertical resize "..opts["ataraxis"]["left_right_padding"]..""

	-- left buffer
	cmd("leftabove vnew")
	cmd(padding_cmd)
	cmd("setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler noshowmode noshowcmd laststatus=0")
	fillchars()

	-- middle buffer
	cmd("wincmd l")

	-- right buffer
	cmd("vnew")
	cmd(padding_cmd)
	cmd("setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler noshowmode noshowcmd laststatus=0")
	fillchars()



	-- middle buffer
	cmd("wincmd h")
	fillchars()
	mode_minimalist.main(2)

	vim.api.nvim_exec([[
		" Like bufdo but restore the current buffer.
		function! BufDo(command)
			let currBuff=bufnr("%")
			execute 'bufdo ' . a:command
			execute 'buffer ' . currBuff
		endfunction
		com! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

		" escape backward slash
		" mental note: don't use simple quotation marks
		call BufDo("set fillchars+=vert:\\ ")

		" since the function is global, it can be called outside of this nvim_exec statement like so:
		" vim.cmd([[call BufDo("set fillchars+=vert:\\ "
		" don't forget to complete the statement, is just becuase I can't do that within nvim_exec statement
	]], false)

	
	-- worked
	-- cmd([[call BufDo("lua require'services.left.service'.left_false()")]])
	cmd([[call BufDo("lua require'services.left.init'.main(2)")]])




	-- leaves you in another place
	-- cmd([[bufdo set fillchars+=vert:\ ]])
end



return {
	ataraxis_true = ataraxis_true,
	ataraxis_false = ataraxis_false
}
