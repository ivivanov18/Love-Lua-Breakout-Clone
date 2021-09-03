CONFIG_TABLE = {}

function love.conf(t)
	t.title = "Breakout lua/love"
	t.version = "11.3"
	t.console = true
	t.window.width = 1280
	t.window.height = 720
	t.window.sync = 0
	configTable = t
end
