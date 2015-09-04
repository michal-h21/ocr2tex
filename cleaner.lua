local M = {
  text = "",
  actions = {}
}

local new = function(filename)
  local x = {filename = filename}
  setmetatable(x,M)
  M.__index = M
  return x
end

function M.hello(self)
  print("Hello " .. self.filename)
end

function M.action(self, fun)
  table.insert(self.actions,fun)
end

function M.load_text(self)
  local f = io.open(self.filename, "r")
  local text = f:read("*all")
  f:close()
  return text
end

function M.save_text(self, text) 
  local f = io.open(self.filename,"w")
  f:write(text)
  f:close()
end

function M.run(self)
  local text = self:load_text() 
  if not text then return false end
  local count = 0
  for _, action in ipairs(self.actions) do
    count = count + 1
    text = action(text)
  end
  self:save_text(text)
  return  count
end

return new
  
