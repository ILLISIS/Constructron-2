-- Adapted from k2 medium buffer chest, all credits to linver, krastor & raiguard
-- https://mods.factorio.com/mod/Krastorio2
local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

local icon_path = "__Constructron-2__/graphics/buffer-chest/medium-buffer-container_icon.png"
local _sprites_path = "__Constructron-2__/graphics/buffer-chest/"

local medium_buffer_chest_entity = {
    type = "logistic-container",
    name = "ctron-buffer-chest",
    icon = icon_path,
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {
        "placeable-player",
        "player-creation",
        "not-rotatable"
    },
    minable = {
        mining_time = 0.5,
        result = "ctron-buffer-chest"
    },
    max_health = 500,
    max_logistic_slots = 10,
    corpse = "big-remnants",
    collision_box = {
        {-0.8, -0.8},
        {0.8, 0.8}
    },
    selection_box = {
        {-1, -1},
        {1, 1}
    },
    damaged_trigger_effect = hit_effects.entity(),
    resistances = {
        {
            type = "physical",
            percent = 30
        },
        {
            type = "fire",
            percent = 50
        },
        {
            type = "impact",
            percent = 50
        }
    },
    fast_replaceable_group = "container",
    inventory_size = 60,
    scale_info_icons = false,
    logistic_mode = "buffer",
    vehicle_impact_sound = sounds.generic_impact,
    opened_duration = logistic_chest_opened_duration,
    animation = {
        filename = _sprites_path .. "medium-buffer-container.png",
        priority = "extra-high",
        width = 85,
        height = 85,
        frame_count = 6,
        hr_version = {
            filename = _sprites_path .. "hr-medium-buffer-container.png",
            priority = "extra-high",
            width = 340,
            height = 340,
            frame_count = 6,
            line_length = 3,
            scale = 0.25
        }
    },
    circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
    circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance,
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close
}
local medium_buffer_chest_item = {
    type = "item",
    name = "ctron-buffer-chest",
    icon = icon_path,
    stack_size = 50,
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "logistic-network",
    order = "b[medium-buffer-container]",
    place_result = "ctron-buffer-chest"
}

local medium_buffer_chest_recipe = {
    type = "recipe",
    name = "ctron-buffer-chest",
    energy_required = 1,
    enabled = false,
    ingredients = {
        {"logistic-chest-buffer", 1},
        {"radar", 1}
    },
    order = "b[medium-buffer-container]",
    result = "ctron-buffer-chest"
}

return {
    medium_buffer_chest_entity,
    medium_buffer_chest_recipe,
    medium_buffer_chest_item
}
