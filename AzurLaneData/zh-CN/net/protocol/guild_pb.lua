slot0 = require("protobuf")

module("guild_pb")

CAPITAL_LOG = slot0.Descriptor()
WEEKLY_TASK = slot0.Descriptor()
GUILD_TECHNOLOGY = slot0.Descriptor()
FLEET_INFO = slot0.Descriptor()
({
	CAPITAL_LOG_MEMBER_ID_FIELD = slot0.FieldDescriptor(),
	CAPITAL_LOG_NAME_FIELD = slot0.FieldDescriptor(),
	CAPITAL_LOG_EVENT_TYPE_FIELD = slot0.FieldDescriptor(),
	CAPITAL_LOG_EVENT_TARGET_FIELD = slot0.FieldDescriptor(),
	CAPITAL_LOG_TIME_FIELD = slot0.FieldDescriptor(),
	WEEKLY_TASK_ID_FIELD = slot0.FieldDescriptor(),
	WEEKLY_TASK_PROGRESS_FIELD = slot0.FieldDescriptor(),
	WEEKLY_TASK_MONDAY_0CLOCK_FIELD = slot0.FieldDescriptor(),
	GUILD_TECHNOLOGY_ID_FIELD = slot0.FieldDescriptor(),
	GUILD_TECHNOLOGY_STATE_FIELD = slot0.FieldDescriptor(),
	GUILD_TECHNOLOGY_PROGRESS_FIELD = slot0.FieldDescriptor(),
	FLEET_INFO_ID_FIELD = slot0.FieldDescriptor(),
	FLEET_INFO_SHIP_LIST_FIELD = slot0.FieldDescriptor()
})["CAPITAL_LOG_MEMBER_ID_FIELD"].name = "member_id"
()["CAPITAL_LOG_MEMBER_ID_FIELD"].full_name = "guild.capital_log.member_id"
()["CAPITAL_LOG_MEMBER_ID_FIELD"].number = 1
()["CAPITAL_LOG_MEMBER_ID_FIELD"].index = 0
()["CAPITAL_LOG_MEMBER_ID_FIELD"].label = 2
()["CAPITAL_LOG_MEMBER_ID_FIELD"].has_default_value = false
()["CAPITAL_LOG_MEMBER_ID_FIELD"].default_value = 0
()["CAPITAL_LOG_MEMBER_ID_FIELD"].type = 13
()["CAPITAL_LOG_MEMBER_ID_FIELD"].cpp_type = 3
()["CAPITAL_LOG_NAME_FIELD"].name = "name"
()["CAPITAL_LOG_NAME_FIELD"].full_name = "guild.capital_log.name"
()["CAPITAL_LOG_NAME_FIELD"].number = 2
()["CAPITAL_LOG_NAME_FIELD"].index = 1
()["CAPITAL_LOG_NAME_FIELD"].label = 2
()["CAPITAL_LOG_NAME_FIELD"].has_default_value = false
()["CAPITAL_LOG_NAME_FIELD"].default_value = ""
()["CAPITAL_LOG_NAME_FIELD"].type = 9
()["CAPITAL_LOG_NAME_FIELD"].cpp_type = 9
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].name = "event_type"
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].full_name = "guild.capital_log.event_type"
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].number = 3
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].index = 2
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].label = 2
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].has_default_value = false
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].default_value = 0
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].type = 13
()["CAPITAL_LOG_EVENT_TYPE_FIELD"].cpp_type = 3
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].name = "event_target"
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].full_name = "guild.capital_log.event_target"
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].number = 4
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].index = 3
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].label = 3
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].has_default_value = false
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].default_value = {}
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].type = 13
()["CAPITAL_LOG_EVENT_TARGET_FIELD"].cpp_type = 3
()["CAPITAL_LOG_TIME_FIELD"].name = "time"
()["CAPITAL_LOG_TIME_FIELD"].full_name = "guild.capital_log.time"
()["CAPITAL_LOG_TIME_FIELD"].number = 5
()["CAPITAL_LOG_TIME_FIELD"].index = 4
()["CAPITAL_LOG_TIME_FIELD"].label = 2
()["CAPITAL_LOG_TIME_FIELD"].has_default_value = false
()["CAPITAL_LOG_TIME_FIELD"].default_value = 0
()["CAPITAL_LOG_TIME_FIELD"].type = 13
()["CAPITAL_LOG_TIME_FIELD"].cpp_type = 3
CAPITAL_LOG.name = "capital_log"
CAPITAL_LOG.full_name = "guild.capital_log"
CAPITAL_LOG.nested_types = {}
CAPITAL_LOG.enum_types = {}
CAPITAL_LOG.fields = {
	()["CAPITAL_LOG_MEMBER_ID_FIELD"],
	()["CAPITAL_LOG_NAME_FIELD"],
	()["CAPITAL_LOG_EVENT_TYPE_FIELD"],
	()["CAPITAL_LOG_EVENT_TARGET_FIELD"],
	()["CAPITAL_LOG_TIME_FIELD"]
}
CAPITAL_LOG.is_extendable = false
CAPITAL_LOG.extensions = {}
()["WEEKLY_TASK_ID_FIELD"].name = "id"
()["WEEKLY_TASK_ID_FIELD"].full_name = "guild.weekly_task.id"
()["WEEKLY_TASK_ID_FIELD"].number = 1
()["WEEKLY_TASK_ID_FIELD"].index = 0
()["WEEKLY_TASK_ID_FIELD"].label = 2
()["WEEKLY_TASK_ID_FIELD"].has_default_value = false
()["WEEKLY_TASK_ID_FIELD"].default_value = 0
()["WEEKLY_TASK_ID_FIELD"].type = 13
()["WEEKLY_TASK_ID_FIELD"].cpp_type = 3
()["WEEKLY_TASK_PROGRESS_FIELD"].name = "progress"
()["WEEKLY_TASK_PROGRESS_FIELD"].full_name = "guild.weekly_task.progress"
()["WEEKLY_TASK_PROGRESS_FIELD"].number = 2
()["WEEKLY_TASK_PROGRESS_FIELD"].index = 1
()["WEEKLY_TASK_PROGRESS_FIELD"].label = 2
()["WEEKLY_TASK_PROGRESS_FIELD"].has_default_value = false
()["WEEKLY_TASK_PROGRESS_FIELD"].default_value = 0
()["WEEKLY_TASK_PROGRESS_FIELD"].type = 13
()["WEEKLY_TASK_PROGRESS_FIELD"].cpp_type = 3
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].name = "monday_0clock"
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].full_name = "guild.weekly_task.monday_0clock"
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].number = 3
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].index = 2
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].label = 2
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].has_default_value = false
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].default_value = 0
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].type = 13
()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"].cpp_type = 3
WEEKLY_TASK.name = "weekly_task"
WEEKLY_TASK.full_name = "guild.weekly_task"
WEEKLY_TASK.nested_types = {}
WEEKLY_TASK.enum_types = {}
WEEKLY_TASK.fields = {
	()["WEEKLY_TASK_ID_FIELD"],
	()["WEEKLY_TASK_PROGRESS_FIELD"],
	()["WEEKLY_TASK_MONDAY_0CLOCK_FIELD"]
}
WEEKLY_TASK.is_extendable = false
WEEKLY_TASK.extensions = {}
()["GUILD_TECHNOLOGY_ID_FIELD"].name = "id"
()["GUILD_TECHNOLOGY_ID_FIELD"].full_name = "guild.guild_technology.id"
()["GUILD_TECHNOLOGY_ID_FIELD"].number = 1
()["GUILD_TECHNOLOGY_ID_FIELD"].index = 0
()["GUILD_TECHNOLOGY_ID_FIELD"].label = 2
()["GUILD_TECHNOLOGY_ID_FIELD"].has_default_value = false
()["GUILD_TECHNOLOGY_ID_FIELD"].default_value = 0
()["GUILD_TECHNOLOGY_ID_FIELD"].type = 13
()["GUILD_TECHNOLOGY_ID_FIELD"].cpp_type = 3
()["GUILD_TECHNOLOGY_STATE_FIELD"].name = "state"
()["GUILD_TECHNOLOGY_STATE_FIELD"].full_name = "guild.guild_technology.state"
()["GUILD_TECHNOLOGY_STATE_FIELD"].number = 2
()["GUILD_TECHNOLOGY_STATE_FIELD"].index = 1
()["GUILD_TECHNOLOGY_STATE_FIELD"].label = 2
()["GUILD_TECHNOLOGY_STATE_FIELD"].has_default_value = false
()["GUILD_TECHNOLOGY_STATE_FIELD"].default_value = 0
()["GUILD_TECHNOLOGY_STATE_FIELD"].type = 13
()["GUILD_TECHNOLOGY_STATE_FIELD"].cpp_type = 3
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].name = "progress"
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].full_name = "guild.guild_technology.progress"
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].number = 3
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].index = 2
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].label = 2
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].has_default_value = false
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].default_value = 0
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].type = 13
()["GUILD_TECHNOLOGY_PROGRESS_FIELD"].cpp_type = 3
GUILD_TECHNOLOGY.name = "guild_technology"
GUILD_TECHNOLOGY.full_name = "guild.guild_technology"
GUILD_TECHNOLOGY.nested_types = {}
GUILD_TECHNOLOGY.enum_types = {}
GUILD_TECHNOLOGY.fields = {
	()["GUILD_TECHNOLOGY_ID_FIELD"],
	()["GUILD_TECHNOLOGY_STATE_FIELD"],
	()["GUILD_TECHNOLOGY_PROGRESS_FIELD"]
}
GUILD_TECHNOLOGY.is_extendable = false
GUILD_TECHNOLOGY.extensions = {}
()["FLEET_INFO_ID_FIELD"].name = "id"
()["FLEET_INFO_ID_FIELD"].full_name = "guild.fleet_info.id"
()["FLEET_INFO_ID_FIELD"].number = 1
()["FLEET_INFO_ID_FIELD"].index = 0
()["FLEET_INFO_ID_FIELD"].label = 2
()["FLEET_INFO_ID_FIELD"].has_default_value = false
()["FLEET_INFO_ID_FIELD"].default_value = 0
()["FLEET_INFO_ID_FIELD"].type = 13
()["FLEET_INFO_ID_FIELD"].cpp_type = 3
()["FLEET_INFO_SHIP_LIST_FIELD"].name = "ship_list"
()["FLEET_INFO_SHIP_LIST_FIELD"].full_name = "guild.fleet_info.ship_list"
()["FLEET_INFO_SHIP_LIST_FIELD"].number = 2
()["FLEET_INFO_SHIP_LIST_FIELD"].index = 1
()["FLEET_INFO_SHIP_LIST_FIELD"].label = 3
()["FLEET_INFO_SHIP_LIST_FIELD"].has_default_value = false
()["FLEET_INFO_SHIP_LIST_FIELD"].default_value = {}
()["FLEET_INFO_SHIP_LIST_FIELD"].type = 13
()["FLEET_INFO_SHIP_LIST_FIELD"].cpp_type = 3
FLEET_INFO.name = "fleet_info"
FLEET_INFO.full_name = "guild.fleet_info"
FLEET_INFO.nested_types = {}
FLEET_INFO.enum_types = {}
FLEET_INFO.fields = {
	()["FLEET_INFO_ID_FIELD"],
	()["FLEET_INFO_SHIP_LIST_FIELD"]
}
FLEET_INFO.is_extendable = false
FLEET_INFO.extensions = {}
capital_log = slot0.Message(CAPITAL_LOG)
fleet_info = slot0.Message(FLEET_INFO)
guild_technology = slot0.Message(GUILD_TECHNOLOGY)
weekly_task = slot0.Message(WEEKLY_TASK)

return
