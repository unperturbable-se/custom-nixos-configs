Linemode:children_add(function(self)
  local file = self._file
  if file:is_selected() then
    return ui.Span(" [✓] "):fg("green")
  else
    return ui.Span(" [ ] "):fg("darkgray")
  end
end, 500, Linemode.LEFT)
