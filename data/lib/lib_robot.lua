local cust_lib = require("__Constructron-2__.data.lib.custom_lib")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local robot_animations = {}

robot_animations.sparks = {
    {
        filename = "__base__/graphics/entity/sparks/sparks-01.png",
        draw_as_glow = true,
        width = 39,
        height = 34,
        frame_count = 19,
        line_length = 19,
        shift = {-0.109375, 0.3125},
        tint = {r = 1.0, g = 0.9, b = 0.0, a = 1.0},
        animation_speed = 0.3
    },
    {
        filename = "__base__/graphics/entity/sparks/sparks-02.png",
        draw_as_glow = true,
        width = 36,
        height = 32,
        frame_count = 19,
        line_length = 19,
        shift = {0.03125, 0.125},
        tint = {r = 1.0, g = 0.9, b = 0.0, a = 1.0},
        animation_speed = 0.3
    },
    {
        filename = "__base__/graphics/entity/sparks/sparks-03.png",
        draw_as_glow = true,
        width = 42,
        height = 29,
        frame_count = 19,
        line_length = 19,
        shift = {-0.0625, 0.203125},
        tint = {r = 1.0, g = 0.9, b = 0.0, a = 1.0},
        animation_speed = 0.3
    },
    {
        filename = "__base__/graphics/entity/sparks/sparks-04.png",
        draw_as_glow = true,
        width = 40,
        height = 35,
        frame_count = 19,
        line_length = 19,
        shift = {-0.0625, 0.234375},
        tint = {r = 1.0, g = 0.9, b = 0.0, a = 1.0},
        animation_speed = 0.3
    },
    {
        filename = "__base__/graphics/entity/sparks/sparks-05.png",
        draw_as_glow = true,
        width = 39,
        height = 29,
        frame_count = 19,
        line_length = 19,
        shift = {-0.109375, 0.171875},
        tint = {r = 1.0, g = 0.9, b = 0.0, a = 1.0},
        animation_speed = 0.3
    },
    {
        filename = "__base__/graphics/entity/sparks/sparks-06.png",
        draw_as_glow = true,
        width = 44,
        height = 36,
        frame_count = 19,
        line_length = 19,
        shift = {0.03125, 0.3125},
        tint = {r = 1.0, g = 0.9, b = 0.0, a = 1.0},
        animation_speed = 0.3
    }
}

robot_animations.construction_robot = {
    idle = {
        filename = "__base__/graphics/entity/construction-robot/construction-robot.png",
        priority = "high",
        line_length = 16,
        width = 32,
        height = 36,
        frame_count = 1,
        shift = util.by_pixel(0, -4.5),
        direction_count = 16,
        hr_version = {
            filename = "__base__/graphics/entity/construction-robot/hr-construction-robot.png",
            priority = "high",
            line_length = 16,
            width = 66,
            height = 76,
            frame_count = 1,
            shift = util.by_pixel(0, -4.5),
            direction_count = 16,
            scale = 0.5
        }
    },
    in_motion = {
        filename = "__base__/graphics/entity/construction-robot/construction-robot.png",
        priority = "high",
        line_length = 16,
        width = 32,
        height = 36,
        frame_count = 1,
        shift = util.by_pixel(0, -4.5),
        direction_count = 16,
        y = 36,
        hr_version = {
            filename = "__base__/graphics/entity/construction-robot/hr-construction-robot.png",
            priority = "high",
            line_length = 16,
            width = 66,
            height = 76,
            frame_count = 1,
            shift = util.by_pixel(0, -4.5),
            direction_count = 16,
            y = 76,
            scale = 0.5
        }
    },
    shadow_idle = {
        filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 53,
        height = 25,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.5),
        direction_count = 16,
        draw_as_shadow = true,
        hr_version = {
            filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
            priority = "high",
            line_length = 16,
            width = 104,
            height = 49,
            frame_count = 1,
            shift = util.by_pixel(33.5, 18.75),
            direction_count = 16,
            scale = 0.5,
            draw_as_shadow = true
        }
    },
    shadow_in_motion = {
        filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 53,
        height = 25,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.5),
        direction_count = 16,
        draw_as_shadow = true,
        hr_version = {
            filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
            priority = "high",
            line_length = 16,
            width = 104,
            height = 49,
            frame_count = 1,
            shift = util.by_pixel(33.5, 18.75),
            direction_count = 16,
            scale = 0.5,
            draw_as_shadow = true
        }
    },
    working = {
        filename = "__base__/graphics/entity/construction-robot/construction-robot-working.png",
        priority = "high",
        line_length = 2,
        width = 28,
        height = 36,
        frame_count = 2,
        shift = util.by_pixel(-0.25, -5),
        direction_count = 16,
        animation_speed = 0.3,
        hr_version = {
            filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-working.png",
            priority = "high",
            line_length = 2,
            width = 57,
            height = 74,
            frame_count = 2,
            shift = util.by_pixel(-0.25, -5),
            direction_count = 16,
            animation_speed = 0.3,
            scale = 0.5
        }
    },
    shadow_working = {
        filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 53,
        height = 25,
        frame_count = 1,
        repeat_count = 2,
        shift = util.by_pixel(33.5, 18.5),
        direction_count = 16,
        draw_as_shadow = true,
        hr_version = {
            filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
            priority = "high",
            line_length = 16,
            width = 104,
            height = 49,
            frame_count = 1,
            repeat_count = 2,
            shift = util.by_pixel(33.5, 18.75),
            direction_count = 16,
            scale = 0.5,
            draw_as_shadow = true
        }
    }
}

local lib_robots = {}
lib_robots.templates = {
    construction = {
        type = "construction-robot",
        name = nil,
        icon = "__base__/graphics/icons/construction-robot.png",
        icon_size = 64,
        icon_mipmaps = 4,
        flags = {"placeable-off-grid", "not-on-map"},
        --minable = {mining_time = 0.1, result = "construction-robot"},
        resistances = {},
        max_health = 100,
        collision_box = {{0, 0}, {0, 0}},
        selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
        hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
        damaged_trigger_effect = hit_effects.flying_robot(),
        dying_explosion = "construction-robot-explosion",
        max_payload_size = 1,
        speed = 0.06,
        max_energy = "1.5MJ",
        energy_per_tick = "0.05kJ",
        speed_multiplier_when_out_of_energy = 0.5,
        selectable_in_game = false,
        energy_per_move = "5kJ",
        min_to_charge = 0.2,
        max_to_charge = 0.95,
        working_light = {intensity = 0.8, size = 3, color = {r = 0.8, g = 0.8, b = 0.8}},
        smoke = {
            filename = "__base__/graphics/entity/smoke-construction/smoke-01.png",
            width = 39,
            height = 32,
            frame_count = 19,
            line_length = 19,
            shift = {0.078125, -0.15625},
            animation_speed = 0.3
        },
        sparks = robot_animations.sparks,
        repairing_sound = {
            {filename = "__base__/sound/robot-repair-1.ogg", volume = 0.6},
            {filename = "__base__/sound/robot-repair-2.ogg", volume = 0.6},
            {filename = "__base__/sound/robot-repair-3.ogg", volume = 0.6},
            {filename = "__base__/sound/robot-repair-4.ogg", volume = 0.6},
            {filename = "__base__/sound/robot-repair-5.ogg", volume = 0.6},
            {filename = "__base__/sound/robot-repair-6.ogg", volume = 0.6}
        },
        working_sound = sounds.construction_robot(0.47),
        cargo_centered = {0.0, 0.2},
        construction_vector = {0.30, 0.22},
        water_reflection = robot_reflection(1),
        idle = robot_animations.construction_robot.idle,
        idle_with_cargo = robot_animations.construction_robot.idle_with_cargo,
        in_motion = robot_animations.construction_robot.in_motion,
        in_motion_with_cargo = robot_animations.construction_robot.in_motion_with_cargo,
        shadow_idle = robot_animations.construction_robot.shadow_idle,
        shadow_idle_with_cargo = robot_animations.construction_robot.shadow_idle_with_cargo,
        shadow_in_motion = robot_animations.construction_robot.shadow_in_motion,
        shadow_in_motion_with_cargo = robot_animations.construction_robot.shadow_in_motion_with_cargo,
        working = robot_animations.construction_robot.working,
        shadow_working = robot_animations.construction_robot.shadow_working
    },
    item = {
        type = "item",
        name = nil,
        place_result = nil,
        flags = {"hidden"},
        icon = "__base__/graphics/icons/construction-robot.png",
        icon_size = 64,
        order = "z",
        stack_size = 500
    }
}

function lib_robots.make_robot(template, params)
    if lib_robots.templates[template] then
        local prototype = table.deepcopy(lib_robots.templates[template])
        cust_lib.merge(prototype, params)
        return prototype
    end
end

return lib_robots
