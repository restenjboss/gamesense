misc_functions = {}

local hwnd_ptr = ((ffi.cast("uintptr_t***", ffi.cast("uintptr_t", raw_hwnd) + 2)[0])[0] + 2)
local FlashWindow = ffi.cast("int(__stdcall*)(uintptr_t, int)", raw_FlashWindow)
local insn_jmp_ecx = ffi.cast("int(__thiscall*)(uintptr_t)", raw_insn_jmp_ecx)
local GetForegroundWindow = (ffi.cast("uintptr_t**", ffi.cast("uintptr_t", raw_GetForegroundWindow) + 2)[0])[0]

function misc_functions:get_csgo_hwnd()
	return hwnd_ptr[0]
end

function misc_functions:get_foreground_hwnd()
	return insn_jmp_ecx(GetForegroundWindow)
end

function misc_functions:notify_user()
	local csgo_hwnd = misc_functions:get_csgo_hwnd()
	if misc_functions:get_foreground_hwnd() ~= csgo_hwnd then
		FlashWindow(csgo_hwnd, 1)
		return true
	end
	return false
end

function on_round_start()
	if misc_functions:notify_user() then
		client.delay_call(1, on_round_start)
	end
end

client.set_event_callback("round_start", function()
    on_round_start()
end)
