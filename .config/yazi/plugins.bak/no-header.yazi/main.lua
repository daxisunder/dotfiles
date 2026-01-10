local function setup()
	local old_layout = Tab.layout

	-- TODO: remove this check once v0.4 is released
	if Header.redraw then
		Header.redraw = function()
			return {}
		end
	else
		Header.render = function()
			return {}
		end
	end

	Tab.layout = function(self, ...)
		self._area = ui.Rect({ x = self._area.x, y = self._area.y - 1, w = self._area.w, h = self._area.h + 1 })
		return old_layout(self, ...)
	end
end

return { setup = setup }
