-------------------------------------------------------------------------------
--  requires/includes
-------------------------------------------------------------------------------
-- libraries and static objects
local technology_unlocker = require("__Constructron-2__.script.reload_technology_unlock")
local custom_lib = require("__Constructron-2__.data.lib.custom_lib")
local control_lib = require("__Constructron-2__.script.lib.control_lib")

-- Classe based things requireing initialization
local Ctron = require("__Constructron-2__.script.objects.Ctron")
local Surface_manager = require("__Constructron-2__.script.objects.Surface-manager")
local Task = require("__Constructron-2__.script.objects.Task")
local Job = require("__Constructron-2__.script.objects.Job")
local Spidertron_Pathfinder = require("__Constructron-2__.script.objects.Spidertron-pathfinder")
local Entity_processing_queue = require("__Constructron-2__.script.objects.Entity-processing-queue")

local EntityClass = {
    ["ctron-classic"] = require("__Constructron-2__.script.objects.Ctron-classic"),
    ["ctron-steam-powered"] = require("__Constructron-2__.script.objects.Ctron-steam-powered"),
    ["ctron-solar-powered"] = require("__Constructron-2__.script.objects.Ctron-solar-powered"),
    ["ctron-nuclear-powered"] = require("__Constructron-2__.script.objects.Ctron-nuclear-powered"),
    ["service-station"] = require("__Constructron-2__.script.objects.Station")
}

-- will be replaced later
--local simple_movement_controller = require("__Constructron-2__.script.simple_movement_controller")

-------------------------------------------------------------------------------
--  runtime variables & Class instanciation
-------------------------------------------------------------------------------

Ctron.pathfinder = Spidertron_Pathfinder()
local player_forces = {"player"} -- object model supports multiple forces, but we dont care about setting it up for now
local surface_managers = {}
local entity_processing_queue =
    Entity_processing_queue(
    (function(entity)
        if surface_managers[entity.surface.index] and surface_managers[entity.surface.index][entity.force.index] then
            surface_managers[entity.surface.index][entity.force.index]:register_entity(entity)
        end
    end)
)

-------------------------------------------------------------------------------
-- various scripting
-------------------------------------------------------------------------------
local function setup_surfaces()
    log("control:setup_surfaces")
    Surface_manager.validate_all()
    for _, force_name in pairs(player_forces) do
        local force = game.forces[force_name]
        if force and force.valid then
            surface_managers[force.index] = surface_managers[force.index] or {}
            for _, surface in pairs(game.surfaces) do
                if surface and surface.valid then
                    surface_managers[force.index][surface.index] = Surface_manager.get_surface_manager(surface, force) or Surface_manager(surface, force)
                end
            end
        end
    end
end

--- Sets up a Entity-Wrapper-Instance for the given entity.
-- @param entity a factorio:LuaEntity object
local function init_entity_instance(entity)
    log("control:init_entity_instance")
    if EntityClass[entity.name] then
        local obj = EntityClass[entity.name](entity)
        if entity.name == "service-station" then
            surface_managers[entity.surface.index][entity.force.index]:add_station(obj)
        elseif custom_lib.table_has_value({"ctron-classic", "ctron-steam-powered", "ctron-solar-powered", "ctron-nuclear-powered"}, entity.name) then
            obj:set_request_items()
            surface_managers[entity.surface.index][entity.force.index]:add_constructron(obj)
        end
    end
end

-------------------------------------------------------------------------------
-- event callback
-------------------------------------------------------------------------------
--- Initializes required globals
-- @see https://lua-api.factorio.com/latest/Data-Lifecycle.html
local on_init = function()
    log("control:on_init")
    global.pause_processing = global.pause_processing or false
    Surface_manager.init_globals()
    Ctron.init_globals()
    EntityClass["service-station"].init_globals()
    Spidertron_Pathfinder.init_globals()
    Surface_manager.init_globals()
    Entity_processing_queue.init_globals()
    --[[
        technology_unlocker.reload_tech("spidertron")
        Task.init_globals()
    ]]
end

--- main worker for unit/job processing
-- @param event from factorio framework
local on_nth_tick_120 = function(event)
    log("control:on_nth_tick_120")
    if global.pause_processing then
        log("paused")
        return
    end
    -- work-work

    -- todo weave processing limit through all calls
    entity_processing_queue:process_chunk_queue()
    entity_processing_queue:process_entity_queue()

    for force_index, _ in pairs(surface_managers) do
        for _, surface_manager in pairs(surface_managers[force_index]) do
            surface_manager:assign_tasks()
        end
        for _, surface_manager in pairs(surface_managers[force_index]) do
            surface_manager:assign_jobs()
        end
        for _, surface_manager in pairs(surface_managers[force_index]) do
            surface_manager:run_jobs()
        end
    end
end

--- main object initialization is expected to be scheduled to run on_tick
-- on_tick will be unscheduled
-- schedules on_nth_tick_120
-- @param event from factorio framework
local on_tick_once = function(_)
    log("control:on_tick_once")
    Ctron.init_managed_gear()
    Spidertron_Pathfinder.check_pathfinder_requests_timeout()

    --create surface-manager objects
    setup_surfaces()
    --create constructron objects
    for unit_number, entity in pairs(global.constructrons.units) do
        if entity and entity.valid then
            local obj = EntityClass[entity.name](entity)
            surface_managers[entity.surface.index][entity.force.index]:add_constructron(obj)
        else
            global.constructrons.units[unit_number] = nil
        end
    end
    --create station objects
    for unit_number, entity in pairs(global.service_stations.entities) do
        if entity and entity.valid then
            local obj = EntityClass[entity.name](entity)
            surface_managers[entity.surface.index][entity.force.index]:add_station(obj)
        else
            global.service_stations.entities[unit_number] = nil
        end
    end
    -- unschduel self and schedule main worker
    script.on_event(defines.events.on_tick, nil)
    script.on_nth_tick(120, on_nth_tick_120)
end

--- Event handler on_player_removed_equipment
-- @param event from factorio framework
local on_player_removed_equipment = function(event)
    log("control:on_player_removed_equipment")
    -- assumption: our managed gear if only exists in spidertrons, whenever a known gear is removed we treat the unit as a spidertron
    -- every prototype has a fixed location where if will be placed which is csv encoded in the order field
    if Ctron.managed_equipment[event.equipment] then
        game.players[event.player_index].remove_item {
            name = event.equipment,
            count = 100
        }
        Ctron.restore_gear(event.grid, event.equipment)
    end
end

local on_research = function(_)
    Ctron.update_tech_unlocks()
end

--- Event handler on_built_entity
-- @param event from factorio framework
local function on_built_entity(event)
    game.print("on_built_entity")
    local entity = event.created_entity
    if entity and entity.valid then
        if not entity_processing_queue:queue_entity(entity, event.tick, "construction") then
            init_entity_instance(entity)
        end
    end
end

--- Event handler on_post_entity_died
-- @param event from factorio framework
local function on_post_entity_died(event)
    game.print("on_post_entity_died")
    local entity = event.ghost
    entity_processing_queue:queue_entity(entity, event.tick, "construction")
end

--- Event handler on_entity_marked_for_upgrade and on_entity_marked_for_deconstruction
-- @param event from factorio framework
local function on_entity_marked(event)
    log("on_entity_marked_for_*")
    local entity = event.entity
    entity_processing_queue:queue_entity(entity, event.tick, "upgrade/deconstruction")
end

--- Event handler on_entity_damaged
-- @param event from factorio framework
local function on_entity_damaged(event)
    log("on_entity_damaged ")
    local entity = event.entity
    if event.force == "player" and (event.final_health / (event.final_damage_amount + event.final_health)) < 0.95 then
        --custom_lib.table_has_value(player_forces,event.force)
        entity_processing_queue:queue_entity(entity, event.tick, "repair")
    end
end

--[[
    --- Event handler on_entity_destroyed
-- @param event from factorio framework
local on_entity_destroyed = function(event)
    log("on_entity_destroyed")
    if Ctron.get_registered_unit(event.registration_number) then
        local unit_number = Ctron.get_registered_unit(event.registration_number)
        if ctrons[unit_number] then
            ctrons[unit_number]:destroy()
            ctrons[unit_number] = nil
        end
    elseif Station.get_registered_entity(event.registration_number) then
        local unit_number = Station.get_registered_entity(event.registration_number)
        if stations[unit_number] then
            stations[unit_number]:destroy()
            stations[unit_number] = nil
        end
    end
end
]]
-------------------------------------------------------------------------------
-- event registration
-------------------------------------------------------------------------------
local ev = defines.events
script.on_init(on_init)
script.on_configuration_changed(on_init)
script.on_event({ev.on_surface_created, ev.on_surface_deleted, ev.on_force_created, ev.on_force_deleted}, setup_surfaces)
script.on_event(ev.on_tick, on_tick_once) -- replaced by on_nth_tick --> simple_movement_controller.main after 1st tick

script.on_event(ev.on_player_removed_equipment, on_player_removed_equipment)
script.on_event({ev.on_research_finished, ev.on_research_reversed}, on_research)

--script.on_event(ev.on_entity_cloned, ctron.on_entity_cloned)
--script.on_event({ev.on_entity_destroyed, ev.script_raised_destroy}, on_entity_destroyed)

-- entity queue events
script.on_event(
    {
        ev.on_built_entity,
        ev.script_raised_built,
        ev.on_robot_built_entity
    },
    on_built_entity
)

script.on_event(
    ev.on_script_path_request_finished,
    (function(event)
        Spidertron_Pathfinder:on_script_path_request_finished(event)
    end)
)

script.on_event(
    ev.on_entity_damaged,
    on_entity_damaged,
    {
        {filter = "final-damage-amount", comparison = ">", value = 20, mode = "and"},
        {filter = "final-health", comparison = ">", value = 0, mode = "and"},
        {filter = "robot-with-logistics-interface", invert = true, mode = "and"},
        {filter = "vehicle", invert = true, mode = "and"},
        {filter = "rolling-stock", invert = true, mode = "and"},
        {filter = "type", type = "character", invert = true, mode = "and"},
        {filter = "type", type = "fish", invert = true, mode = "and"}
    }
)

script.on_event(
    ev.on_marked_for_upgrade,
    on_entity_marked,
    {
        {filter = "vehicle", invert = true, mode = "and"},
        {filter = "rolling-stock", invert = true, mode = "and"}
    }
)

script.on_event(
    ev.on_marked_for_deconstruction,
    on_entity_marked,
    {
        {filter = "name", name = "item-on-ground", invert = true, mode = "and"},
        {filter = "type", type = "fish", invert = true, mode = "and"}
    }
)

script.on_event(ev.on_post_entity_died, on_post_entity_died)

-------------------------------------------------------------------------------
-- command & interfaces function
-------------------------------------------------------------------------------

--- full hardreset of everything
-- not implemented
local function reset()
    game.print("hard reset only partially implemented")
    -- #1 kill all globals
    for k, _ in pairs(global) do
        global[k] = nil
    end
    -- kill all objects
    --      ctrons = {}
    --      stations = {}
    --      surfacesmanagers = {}
    -- rescan all surfaces for stations and constructrons
    -- re-queue all ghosts
    --      rescan_all_surfaces()
end

--- pauses statemachine and queue processing
-- only pauses statemachine and queue processing, not initial event capture
-- on unpause every ctron might have it's current task run into timeout
local function toggle_pause()
    log("control:toggle_pause")
    global.pause_processing = not global.pause_processing
    game.print("paused: " .. tostring(global.pause_processing))
    return global.pause_processing
end

--- Resets the queues, And requeues all chunks on all surfaces to be scanned
local function rescan_all_surfaces()
    log("control:rescan_all_surfaces")
    global.chunk_processing_queue = {}
    global.entity_processing_queue = {}
    for surface_key, surface in pairs(game.surfaces) do
        if surface.valid then
            for chunk in surface.get_chunks() do
                entity_processing_queue:queue_chunk(chunk)
            end
        end
    end
end
-------------------------------------------------------------------------------
-- commands & interfaces
-------------------------------------------------------------------------------
local ctron_commands = {
    rescan = rescan_all_surfaces,
    reset = reset,
    pause = toggle_pause
    --report = get_status_report
}
commands.add_command(
    "ctron",
    "type /ctron rescan to queue all surfaces for a ghost rescan",
    function(param)
        log("/ctron " .. (param.parameter or ""))
        --local player = game.players[param.player_index]
        if param.parameter and ctron_commands[param.parameter] then
            ctron_commands[param.parameter]()
        end
    end
)
--- Game interfaces
remote.add_interface("ctron_interface", ctron_commands)
