--local prompt = require("fzf-lua.profiles.default-prompt")
M = {}

function M.cheat(opts)
	local fzf = require("fzf-lua")

	opts = opts or {}
	opts.languages = opts.languages or { "rust", "cpp", "c", "lua", "python", "go" }
	opts.core = opts.core or { "xargs", "find", "mv", "sed", "awk" }
	opts.default_query = opts.default_query or ""

	--local args = table.concat(opts.core, "\n") .. "\n" .. table.concat(opts.languages, "\n")

	local args = vim.deepcopy(opts.languages)

	for _, value in ipairs(opts.core) do
		table.insert(args, value)
	end

	fzf.fzf_exec(args, {
		prompt = "Cheat > ",
		actions = {
			["default"] = function(selected)
				local buf = vim.api.nvim_create_buf(false, true)

				vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "loading..." })

				-- Window size
				local width = opts.width or 100
				local height = opts.height or 30

				-- Center it
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)

				-- Open the window
				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = width,
					height = height,
					row = row,
					col = col,
					border = "rounded",
				})

				vim.wo[win].number = false
				vim.wo[win].relativenumber = false
				vim.wo[win].signcolumn = "no"
				vim.wo[win].fillchars = "eob: "
				vim.wo[win].signcolumn = "no"

				vim.keymap.set("n", "q", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf, desc = "closes the windows" })

				local choice = selected[1]

				local query = "avadakadavera"

				vim.ui.input({ prompt = "query: " }, function(input)
					query = input or query
					local if_lang = {}

					for _, value in ipairs(opts.languages) do
						if_lang[value] = true
					end

					local formatted = ""

					local output = { "test" }

					if if_lang[choice] then
						vim.schedule(function()
							formatted = query:gsub(" ", "+")
							vim.schedule(function()
								local prompt = "cht.sh/" .. choice .. "/" .. formatted
								vim.system({
									"curl",
									"-s",
									prompt,
								}, { text = true }, function(out)
									vim.schedule(function()
										output = vim.split(out.stdout, "\n")
										vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
										local baleia = require("baleia").setup({})

										baleia.once(buf)
									end)
								end)
							end)
						end)
					else
						vim.schedule(function()
							vim.schedule(function()
								formatted = query:gsub(" ", "+")
								local prompt = "cht.sh/" .. choice .. "/" .. formatted
								vim.system({
									"curl",
									"-s",
									prompt,
								}, { text = true }, function(out)
									vim.schedule(function()
										output = vim.split(out.stdout, "\n")
										vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
										local baleia = require("baleia").setup({})

										baleia.once(buf)
									end)
								end)
							end)
						end)
					end
				end)
			end,
		},
	})
end

function M.setup(opts)
	vim.keymap.set("n", "<leader>c", function()
		M.cheat(opts)
	end, { desc = "opens the cheat sheet" })
end

return M
