assert(SMODS.load_file("globals.lua"))()

local content_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "content")
for _, file in ipairs(content_src) do
    assert(SMODS.load_file("content/" .. file))()
end