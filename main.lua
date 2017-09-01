dpl = {}

function dpl.s(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	local i = 1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function dpl.exe(comm)
	local handle = io.popen(comm)
	local res = handle:read("*a")
	handle:close()
	return res
end


function ls()
	local rawls = dpl.exe("ls " .. dir)
	rawls = "..\n" .. rawls
	list = dpl.s(rawls, "\n")
	local line = table.concat(list, ", ")
	print(line)	
end

dir = "/"
size = 23
ls()
love.graphics.setNewFont(size)

function love.mousepressed(x, y)
	x = math.floor(x / size) + 1
	if list[x] == nil then list[x] = "." end
	ndir = dir .. list[x]
	if string.sub(ndir, #ndir - 3, #ndir) == ".lua" then
		os.execute("cd " .. dir)
		package.path = dir
		dofile(ndir)
	else
		dir = ndir .. "/"
		ls()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.draw()
	love.graphics.translate(0, love.graphics.getHeight())
	love.graphics.rotate(math.rad(-90))
	for line, directory in ipairs(list) do
		love.graphics.print(directory, 5, (line - 1) * size)
	end
end