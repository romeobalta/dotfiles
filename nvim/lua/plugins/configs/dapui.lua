local config = {
	layouts = {
		{
			elements = {
				{
					id = "watches",
					size = 0.45,
				},
				{
					id = "breakpoints",
					size = 0.25,
				},
				{
					id = "scopes",
					size = 0.15,
				},
				{
					id = "stacks",
					size = 0.15,
				},
			},
			position = "left",
			size = 60,
		},
		{
			elements = {
				{
					id = "console",
					size = 0.5,
				},
				{
					id = "repl",
					size = 0.5,
				},
			},
			position = "bottom",
			size = 10,
		},
	},
}

return config
