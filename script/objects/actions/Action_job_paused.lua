local custom_lib = require("__Constructron-2__.data.lib.custom_lib")
local Debug = require("__Constructron-2__.script.objects.Debug")

-- class Type Action_job_paused, nil members exist just to describe fields
local Action_job_paused = {
    class_name = "Action_job_paused",
}
Action_job_paused.__index = Action_job_paused

setmetatable(
    Action_job_paused,
    {
        __index = Action, -- this is what makes the inheritance work
        __call = function(cls, ...)
            local self = setmetatable({}, cls)
            self:new(...)
            return self
        end
    }
)
-- Action_job_paused Constructor
function Action_job_paused:new(surfacemanager)
    self:log()
    Action.new(self,surfacemanager)
end

-- Class Methods
function Action_job_paused:handleStateTransition(job)
    self:log()
    local newState = nil
    return newState
end


return Action_job_paused
