visual_functions = {}
render_t = {}

helpers = {
    RGBtoHEX = function(redArg, greenArg, blueArg)
        return string.format('%.2x%.2x%.2xFF', redArg, greenArg, blueArg)
    end,
}

local render_t.box = function(x, y, w , h, radius, r, g, b, a)
     renderer.rectangle(x+1, y+2, w-2, 2, 30, 30, 30, 255)
     renderer.rectangle(x, y+4, w, 15, 30, 30, 30, 255)
     renderer.circle_outline(x+5, y+4, r, g, b, a, 4, 180, 0.25, 2)
     renderer.circle_outline(x+w-5, y+4, r, g, b, a, 4, 270, 0.25, 2)
     renderer.rectangle(x+5, y, w-10, 2, r, g, b, a)
     renderer.gradient(x, y+4, 2, 9+radius, r, g, b, a, r, g, b, 0, false)
     renderer.gradient(x+w-2, y+4, 2, 9+radius, r, g, b, a, r, g, b, 0, false)
end

function visual_functions:watermark()
	local data_suffix = 'gamesense'

	local h, m, s, mst = client.system_time()

	local actual_time = ('%2d:%02d'):format(h, m) 
        local get_name = panorama.loadstring([[ return MyPersonaAPI.GetName() ]])

	local hex = helpers.RGBtoHEX(col[1], col[2], col[3])

	local latency = client.latency() * 1000
	local latency_text = (' %d'):format(latency) or ''

	text = ("\a"..hex.."%s\a737373FF [nighlty]\a737373FF | \a"..hex.."%s\a737373FF | ms:\a"..hex.."%s \a737373FF | time: \a"..hex.."%s \a737373FF  "):format(data_suffix, get_name(), latency_text, actual_time)
		
	local h, w = 18, renderer.measure_text(nil, text) 
	local x, y = client.screen_size(), 15 + (-3)
	x = x - w - 10

        render_t.box(x - 5, y, w, h, 4, 255, 255, 255, 255)

	renderer.text(x+ w / 2 - 3, y + 8, 255, 255, 255, 255, 'c', 0, text)

end

client.set_event_callback("paint", function()
    visual_functions:watermark()
end)

