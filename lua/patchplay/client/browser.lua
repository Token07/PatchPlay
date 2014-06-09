cl_PPlay.browser = {}

cl_PPlay.browser.currentBrowse = {

	url = "",
	stage = 0,
	args = {}

}

cl_PPlay.browser.history = {}

cl_PPlay.BrowseURL = {

	dirble = { 

	"primaryCategories/apikey/" .. cl_PPlay.APIKeys.dirble,
	"childCategories/apikey/" .. cl_PPlay.APIKeys.dirble .. "/primaryid/[id]",
	"stations/apikey/" .. cl_PPlay.APIKeys.dirble .. "/id/[id]"

	},

	soundcloud = {

		search = "tracks.json?client_id=" .. cl_PPlay.APIKeys.soundcloud .. "&q=[searchquery]"

	}

}

function cl_PPlay.resetBrowse()

	cl_PPlay.browser.currentBrowse = {

		url = "",
		stage = 0,
		args = {}
	}

	cl_PPlay.browser.history = {}

end

function cl_PPlay.browse( list )

	if table.Count(list.selected) == 0 and cl_PPlay.browser.currentBrowse.stage != 0 then return end

	if cl_PPlay.browser.currentBrowse.stage == 3 then

		if list.mode == "server" then
			cl_PPlay.sendToServer( blist.selected.streamurl, blist.selected.name, "play" )
		else
			cl_PPlay.play( blist.selected.streamurl, blist.selected.name, "private" )
		end
		return

	end

	cl_PPlay.browser.currentBrowse.url = ""

	cl_PPlay.browser.currentBrowse.stage = cl_PPlay.browser.currentBrowse.stage + 1

	local rawURL = cl_PPlay.BrowseURL.dirble[cl_PPlay.browser.currentBrowse.stage]
	local newURL = string.gsub( rawURL, "%[(%w+)%]", blist.selected )

	cl_PPlay.browser.currentBrowse.url = "http://api.dirble.com/v1/" .. newURL .. "/format/json"

	table.insert( cl_PPlay.browser.history, cl_PPlay.browser.currentBrowse.url )

	cl_PPlay.getJSONInfo( cl_PPlay.browser.currentBrowse.url, function(entry)

		list:Clear()

		table.foreach(entry, function( key, value )

			if cl_PPlay.browser.currentBrowse.stage == 3 and !cl_PPlay.checkValidURL( value.streamurl ) or value.status == 0 then return end
			

			local line = list:AddLine( value.name )
			if cl_PPlay.browser.currentBrowse.stage == 3 then
				line.url = value.streamurl
				line.name = value.name
			end
			line.id = value.id

		end)

		blist.selected = {}


	end)



end

function cl_PPlay.browseback( list )

	if #cl_PPlay.browser.history == 0 then return end

	cl_PPlay.browser.currentBrowse.url = cl_PPlay.browser.history[#cl_PPlay.browser.history - 1]

	cl_PPlay.getJSONInfo( cl_PPlay.browser.currentBrowse.url, function(entry)

		list:Clear()

		table.foreach(entry, function( key, value )

			local line = list:AddLine( value.name )
			line.id = value.id

		end)

	end)

	table.remove( cl_PPlay.browser.history, #cl_PPlay.browser.history )
	cl_PPlay.browser.currentBrowse.stage = cl_PPlay.browser.currentBrowse.stage - 1

end

function cl_PPlay.search( txt )

	local rawURL = "http://api.soundcloud.com/" .. cl_PPlay.BrowseURL.soundcloud.search
	local newURL = string.gsub( rawURL, "%[(%w+)%]", string.lower(txt:GetValue()) )
	newURL = string.gsub( newURL, "%s", "%%20" )

	cl_PPlay.getJSONInfo( newURL, function(entry)

		table.foreach(entry, function(key, track)

			if track.streamable then

				local line = txt.target:AddLine( track.title )
				line.title = track.title
				line.uri = track.stream_url .. "?client_id=" .. cl_PPlay.APIKeys.soundcloud

			end

		end)

	end)

end

function cl_PPlay.searchplay( list )

	if !list.selected.uri then return end

	if list.mode == "server" then
		cl_PPlay.sendToServer( list.selected.uri, list.selected.title, "play" )
	else
		cl_PPlay.play( list.selected.uri, list.selected.title, "private" )
	end

end

function cl_PPlay.addtomy( list )

	if list.type == "station" then

		if cl_PPlay.browser.currentBrowse.stage != 3 or table.Count(cl_PPlay.browser.currentBrowse.args) == 0 then return end

		if list.mode == "server" then

			cl_PPlay.saveNewStream(cl_PPlay.browser.currentBrowse.args.streamurl, cl_PPlay.browser.currentBrowse.args.name, list.type, true)

		else

			cl_PPlay.saveNewStream( cl_PPlay.browser.currentBrowse.args.streamurl, cl_PPlay.browser.currentBrowse.args.name, list.type )
			cl_PPlay.getStreamList()

		end

	else

		if list.mode == "server" then

			cl_PPlay.saveNewStream(list.selected.uri, list.selected.title, list.type, true)

		else

			cl_PPlay.saveNewStream( list.selected.uri, list.selected.title, list.type )
			cl_PPlay.getStreamList()

		end

	end

end