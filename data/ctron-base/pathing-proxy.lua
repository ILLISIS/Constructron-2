local collision_mask_util_extended = require("__Constructron-2__.data.lib.collision-mask-util-extended")
local pathing_collision_mask = {"water-tile", "colliding-with-tiles-only", "not-colliding-with-itself"}

if mods["space-exploration"] then
    local spaceship_collision_layer = collision_mask_util_extended.get_named_collision_mask("moving-tile")
    local empty_space_collision_layer = collision_mask_util_extended.get_named_collision_mask("empty-space-tile")
    table.insert(pathing_collision_mask, spaceship_collision_layer)
    table.insert(pathing_collision_mask, empty_space_collision_layer)
end

local template_entity = {
    type = "simple-entity",
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    icon_mipmaps = 0,
    flags = {"placeable-neutral", "not-on-map"},
    order = "z",
    max_health = 1,
    render_layer = "object",
    collision_mask = pathing_collision_mask,
    pictures = {
        {
            filename = "__core__/graphics/empty.png",
            width = 1,
            height = 1
        }
    }
}

local template_item = {
    type = "item",
    flags = {"hidden"},
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    order = "z",
    stack_size = 1
}

local proxy = {}

for _, size in pairs({8, 6, 4, 2, 1}) do
    local proxy_entity = table.deepcopy(template_entity)
    proxy_entity.collision_box = {{-size / 2, -size / 2}, {size / 2, size / 2}}
    proxy_entity.selection_box = {{-size / 2, -size / 2}, {size / 2, size / 2}}
    proxy_entity.name = "constructron_pathing_proxy_" .. size

    local proxy_item = table.deepcopy(template_item)
    proxy_item.name = "constructron_pathing_proxy_" .. size
    proxy_item.place_result = "constructron_pathing_proxy_" .. size

    table.insert(proxy, proxy_entity)
    table.insert(proxy, proxy_item)
end

return proxy
