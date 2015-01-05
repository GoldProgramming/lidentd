local arg = ...
if arg then
	local function dr( arg ) -- detect posix, run code
		assert( (pcall( require, "posix" )), "POSIX library not found" )
		local k, err = loadfile( arg )
		assert( k, err )
		k()
		os.exit()
	end
	if arg == "restart" then
		dr( "restart.lua" )
	elseif arg == "status" then
		dr( "status.lua" )
	elseif arg == "stop" then
		dr( "stop.lua" )
	elseif arg == "makeconf" then
		local k, err = loadfile( "makeconf.lua" )
		assert( k, err )
		k()
	elseif arg:match( "^-?-?(help)" ) == "help" then
		print( "Usage: " )
		print( "\tstart.lua restart  | restarts the ident sockets" )
		print( "\tstart.lua stop     | stop the ident daemon" )
		print( "" )
		print( "Programmed by AlissaSquared" )
		print( "\tAlissaSquared@gmail.com | alissa.ml" )
	else
		print( "Unknown argument -- " .. arg )
		print( "Usage: " )
		print( "\tstart.lua restart  | restarts the ident sockets" )
		print( "\tstart.lua stop     | stop the ident daemon" )
		print( "" )
		print( "Programmed by AlissaSquared" )
		print( "\tAlissaSquared@gmail.com | alissa.ml" )
	end
	os.exit()
end
local f = io.open( "settings.ini" )
assert( f, "Unable to open settings.ini - please remake the file with 'start.lua makeconf'" )
local text = f:read( "*a" ):gsub( "\r", "" )
local settings = {}
local n = 0
for line in text:gmatch( "[^\n]+" ) do
	n = n + 1
	if line:match( ".-=.+$" ) then
		local dat = line:match( ".-=(.+)" )
		if dat == "true" then dat = true elseif dat == "false" then dat = false else dat = tonumber( dat ) or dat end
		settings[line:match( "^(.-)=" )] = dat
	elseif not line:match( "^[%s\t*]#" ) then
		error( "Unable to parse settings.ini - line " .. tostring( n ), 0 )
	end
end
--settings.ini has somewhat of a Windows INI scheme, excluding the []'s
if settings['daemon'] == true then
	local k, err = loadfile( "daemon.lua" )
	assert( k, err )
	k(settings)
else
	local k, err = loadfile( "ident.lua" )
	assert( k, err )
	k(settings)
end
