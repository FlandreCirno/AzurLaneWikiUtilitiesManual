slot0 = require("protobuf")
slot1 = require("common_pb")

module("p24_pb")

CS_24002 = slot0.Descriptor()
SC_24003 = slot0.Descriptor()
CS_24004 = slot0.Descriptor()
SC_24005 = slot0.Descriptor()
SC_24010 = slot0.Descriptor()
CS_24011 = slot0.Descriptor()
SC_24012 = slot0.Descriptor()
GROUPINFO = slot0.Descriptor()
CHALLENGEINFO = slot0.Descriptor()
USERCHALLENGEINFO = slot0.Descriptor()
SHIPINCHALLENGE = slot0.Descriptor()
GROUPINFOINCHALLENGE = slot0.Descriptor()
COMMANDERINCHALLENGE = slot0.Descriptor()
({
	CS_24002_ACTIVITY_ID_FIELD = slot0.FieldDescriptor(),
	CS_24002_GROUP_LIST_FIELD = slot0.FieldDescriptor(),
	CS_24002_MODE_FIELD = slot0.FieldDescriptor(),
	SC_24003_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_24004_ACTIVITY_ID_FIELD = slot0.FieldDescriptor(),
	SC_24005_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_24005_CURRENT_CHALLENGE_FIELD = slot0.FieldDescriptor(),
	SC_24005_USER_CHALLENGE_FIELD = slot0.FieldDescriptor(),
	SC_24010_SCORE_FIELD = slot0.FieldDescriptor(),
	CS_24011_ACTIVITY_ID_FIELD = slot0.FieldDescriptor(),
	CS_24011_MODE_FIELD = slot0.FieldDescriptor(),
	SC_24012_RESULT_FIELD = slot0.FieldDescriptor(),
	GROUPINFO_ID_FIELD = slot0.FieldDescriptor(),
	GROUPINFO_SHIP_LIST_FIELD = slot0.FieldDescriptor(),
	GROUPINFO_COMMANDERS_FIELD = slot0.FieldDescriptor(),
	CHALLENGEINFO_SEASON_MAX_SCORE_FIELD = slot0.FieldDescriptor(),
	CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD = slot0.FieldDescriptor(),
	CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD = slot0.FieldDescriptor(),
	CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD = slot0.FieldDescriptor(),
	CHALLENGEINFO_SEASON_ID_FIELD = slot0.FieldDescriptor(),
	CHALLENGEINFO_DUNGEON_ID_LIST_FIELD = slot0.FieldDescriptor(),
	CHALLENGEINFO_BUFF_LIST_FIELD = slot0.FieldDescriptor(),
	USERCHALLENGEINFO_CURRENT_SCORE_FIELD = slot0.FieldDescriptor(),
	USERCHALLENGEINFO_LEVEL_FIELD = slot0.FieldDescriptor(),
	USERCHALLENGEINFO_GROUPINC_LIST_FIELD = slot0.FieldDescriptor(),
	USERCHALLENGEINFO_MODE_FIELD = slot0.FieldDescriptor(),
	USERCHALLENGEINFO_ISSL_FIELD = slot0.FieldDescriptor(),
	USERCHALLENGEINFO_SEASON_ID_FIELD = slot0.FieldDescriptor(),
	USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD = slot0.FieldDescriptor(),
	USERCHALLENGEINFO_BUFF_LIST_FIELD = slot0.FieldDescriptor(),
	SHIPINCHALLENGE_ID_FIELD = slot0.FieldDescriptor(),
	SHIPINCHALLENGE_HP_RANT_FIELD = slot0.FieldDescriptor(),
	SHIPINCHALLENGE_SHIP_INFO_FIELD = slot0.FieldDescriptor(),
	GROUPINFOINCHALLENGE_ID_FIELD = slot0.FieldDescriptor(),
	GROUPINFOINCHALLENGE_SHIPS_FIELD = slot0.FieldDescriptor(),
	GROUPINFOINCHALLENGE_COMMANDERS_FIELD = slot0.FieldDescriptor(),
	COMMANDERINCHALLENGE_POS_FIELD = slot0.FieldDescriptor(),
	COMMANDERINCHALLENGE_COMMANDERINFO_FIELD = slot0.FieldDescriptor()
})["CS_24002_ACTIVITY_ID_FIELD"].name = "activity_id"
()["CS_24002_ACTIVITY_ID_FIELD"].full_name = "p24.cs_24002.activity_id"
()["CS_24002_ACTIVITY_ID_FIELD"].number = 1
()["CS_24002_ACTIVITY_ID_FIELD"].index = 0
()["CS_24002_ACTIVITY_ID_FIELD"].label = 2
()["CS_24002_ACTIVITY_ID_FIELD"].has_default_value = false
()["CS_24002_ACTIVITY_ID_FIELD"].default_value = 0
()["CS_24002_ACTIVITY_ID_FIELD"].type = 13
()["CS_24002_ACTIVITY_ID_FIELD"].cpp_type = 3
()["CS_24002_GROUP_LIST_FIELD"].name = "group_list"
()["CS_24002_GROUP_LIST_FIELD"].full_name = "p24.cs_24002.group_list"
()["CS_24002_GROUP_LIST_FIELD"].number = 2
()["CS_24002_GROUP_LIST_FIELD"].index = 1
()["CS_24002_GROUP_LIST_FIELD"].label = 3
()["CS_24002_GROUP_LIST_FIELD"].has_default_value = false
()["CS_24002_GROUP_LIST_FIELD"].default_value = {}
()["CS_24002_GROUP_LIST_FIELD"].message_type = GROUPINFO
()["CS_24002_GROUP_LIST_FIELD"].type = 11
()["CS_24002_GROUP_LIST_FIELD"].cpp_type = 10
()["CS_24002_MODE_FIELD"].name = "mode"
()["CS_24002_MODE_FIELD"].full_name = "p24.cs_24002.mode"
()["CS_24002_MODE_FIELD"].number = 3
()["CS_24002_MODE_FIELD"].index = 2
()["CS_24002_MODE_FIELD"].label = 2
()["CS_24002_MODE_FIELD"].has_default_value = false
()["CS_24002_MODE_FIELD"].default_value = 0
()["CS_24002_MODE_FIELD"].type = 13
()["CS_24002_MODE_FIELD"].cpp_type = 3
CS_24002.name = "cs_24002"
CS_24002.full_name = "p24.cs_24002"
CS_24002.nested_types = {}
CS_24002.enum_types = {}
CS_24002.fields = {
	()["CS_24002_ACTIVITY_ID_FIELD"],
	()["CS_24002_GROUP_LIST_FIELD"],
	()["CS_24002_MODE_FIELD"]
}
CS_24002.is_extendable = false
CS_24002.extensions = {}
()["SC_24003_RESULT_FIELD"].name = "result"
()["SC_24003_RESULT_FIELD"].full_name = "p24.sc_24003.result"
()["SC_24003_RESULT_FIELD"].number = 1
()["SC_24003_RESULT_FIELD"].index = 0
()["SC_24003_RESULT_FIELD"].label = 2
()["SC_24003_RESULT_FIELD"].has_default_value = false
()["SC_24003_RESULT_FIELD"].default_value = 0
()["SC_24003_RESULT_FIELD"].type = 13
()["SC_24003_RESULT_FIELD"].cpp_type = 3
SC_24003.name = "sc_24003"
SC_24003.full_name = "p24.sc_24003"
SC_24003.nested_types = {}
SC_24003.enum_types = {}
SC_24003.fields = {
	()["SC_24003_RESULT_FIELD"]
}
SC_24003.is_extendable = false
SC_24003.extensions = {}
()["CS_24004_ACTIVITY_ID_FIELD"].name = "activity_id"
()["CS_24004_ACTIVITY_ID_FIELD"].full_name = "p24.cs_24004.activity_id"
()["CS_24004_ACTIVITY_ID_FIELD"].number = 1
()["CS_24004_ACTIVITY_ID_FIELD"].index = 0
()["CS_24004_ACTIVITY_ID_FIELD"].label = 2
()["CS_24004_ACTIVITY_ID_FIELD"].has_default_value = false
()["CS_24004_ACTIVITY_ID_FIELD"].default_value = 0
()["CS_24004_ACTIVITY_ID_FIELD"].type = 13
()["CS_24004_ACTIVITY_ID_FIELD"].cpp_type = 3
CS_24004.name = "cs_24004"
CS_24004.full_name = "p24.cs_24004"
CS_24004.nested_types = {}
CS_24004.enum_types = {}
CS_24004.fields = {
	()["CS_24004_ACTIVITY_ID_FIELD"]
}
CS_24004.is_extendable = false
CS_24004.extensions = {}
()["SC_24005_RESULT_FIELD"].name = "result"
()["SC_24005_RESULT_FIELD"].full_name = "p24.sc_24005.result"
()["SC_24005_RESULT_FIELD"].number = 1
()["SC_24005_RESULT_FIELD"].index = 0
()["SC_24005_RESULT_FIELD"].label = 2
()["SC_24005_RESULT_FIELD"].has_default_value = false
()["SC_24005_RESULT_FIELD"].default_value = 0
()["SC_24005_RESULT_FIELD"].type = 13
()["SC_24005_RESULT_FIELD"].cpp_type = 3
()["SC_24005_CURRENT_CHALLENGE_FIELD"].name = "current_challenge"
()["SC_24005_CURRENT_CHALLENGE_FIELD"].full_name = "p24.sc_24005.current_challenge"
()["SC_24005_CURRENT_CHALLENGE_FIELD"].number = 2
()["SC_24005_CURRENT_CHALLENGE_FIELD"].index = 1
()["SC_24005_CURRENT_CHALLENGE_FIELD"].label = 2
()["SC_24005_CURRENT_CHALLENGE_FIELD"].has_default_value = false
()["SC_24005_CURRENT_CHALLENGE_FIELD"].default_value = nil
()["SC_24005_CURRENT_CHALLENGE_FIELD"].message_type = CHALLENGEINFO
()["SC_24005_CURRENT_CHALLENGE_FIELD"].type = 11
()["SC_24005_CURRENT_CHALLENGE_FIELD"].cpp_type = 10
()["SC_24005_USER_CHALLENGE_FIELD"].name = "user_challenge"
()["SC_24005_USER_CHALLENGE_FIELD"].full_name = "p24.sc_24005.user_challenge"
()["SC_24005_USER_CHALLENGE_FIELD"].number = 3
()["SC_24005_USER_CHALLENGE_FIELD"].index = 2
()["SC_24005_USER_CHALLENGE_FIELD"].label = 3
()["SC_24005_USER_CHALLENGE_FIELD"].has_default_value = false
()["SC_24005_USER_CHALLENGE_FIELD"].default_value = {}
()["SC_24005_USER_CHALLENGE_FIELD"].message_type = USERCHALLENGEINFO
()["SC_24005_USER_CHALLENGE_FIELD"].type = 11
()["SC_24005_USER_CHALLENGE_FIELD"].cpp_type = 10
SC_24005.name = "sc_24005"
SC_24005.full_name = "p24.sc_24005"
SC_24005.nested_types = {}
SC_24005.enum_types = {}
SC_24005.fields = {
	()["SC_24005_RESULT_FIELD"],
	()["SC_24005_CURRENT_CHALLENGE_FIELD"],
	()["SC_24005_USER_CHALLENGE_FIELD"]
}
SC_24005.is_extendable = false
SC_24005.extensions = {}
()["SC_24010_SCORE_FIELD"].name = "score"
()["SC_24010_SCORE_FIELD"].full_name = "p24.sc_24010.score"
()["SC_24010_SCORE_FIELD"].number = 1
()["SC_24010_SCORE_FIELD"].index = 0
()["SC_24010_SCORE_FIELD"].label = 2
()["SC_24010_SCORE_FIELD"].has_default_value = false
()["SC_24010_SCORE_FIELD"].default_value = 0
()["SC_24010_SCORE_FIELD"].type = 13
()["SC_24010_SCORE_FIELD"].cpp_type = 3
SC_24010.name = "sc_24010"
SC_24010.full_name = "p24.sc_24010"
SC_24010.nested_types = {}
SC_24010.enum_types = {}
SC_24010.fields = {
	()["SC_24010_SCORE_FIELD"]
}
SC_24010.is_extendable = false
SC_24010.extensions = {}
()["CS_24011_ACTIVITY_ID_FIELD"].name = "activity_id"
()["CS_24011_ACTIVITY_ID_FIELD"].full_name = "p24.cs_24011.activity_id"
()["CS_24011_ACTIVITY_ID_FIELD"].number = 1
()["CS_24011_ACTIVITY_ID_FIELD"].index = 0
()["CS_24011_ACTIVITY_ID_FIELD"].label = 2
()["CS_24011_ACTIVITY_ID_FIELD"].has_default_value = false
()["CS_24011_ACTIVITY_ID_FIELD"].default_value = 0
()["CS_24011_ACTIVITY_ID_FIELD"].type = 13
()["CS_24011_ACTIVITY_ID_FIELD"].cpp_type = 3
()["CS_24011_MODE_FIELD"].name = "mode"
()["CS_24011_MODE_FIELD"].full_name = "p24.cs_24011.mode"
()["CS_24011_MODE_FIELD"].number = 2
()["CS_24011_MODE_FIELD"].index = 1
()["CS_24011_MODE_FIELD"].label = 2
()["CS_24011_MODE_FIELD"].has_default_value = false
()["CS_24011_MODE_FIELD"].default_value = 0
()["CS_24011_MODE_FIELD"].type = 13
()["CS_24011_MODE_FIELD"].cpp_type = 3
CS_24011.name = "cs_24011"
CS_24011.full_name = "p24.cs_24011"
CS_24011.nested_types = {}
CS_24011.enum_types = {}
CS_24011.fields = {
	()["CS_24011_ACTIVITY_ID_FIELD"],
	()["CS_24011_MODE_FIELD"]
}
CS_24011.is_extendable = false
CS_24011.extensions = {}
()["SC_24012_RESULT_FIELD"].name = "result"
()["SC_24012_RESULT_FIELD"].full_name = "p24.sc_24012.result"
()["SC_24012_RESULT_FIELD"].number = 1
()["SC_24012_RESULT_FIELD"].index = 0
()["SC_24012_RESULT_FIELD"].label = 2
()["SC_24012_RESULT_FIELD"].has_default_value = false
()["SC_24012_RESULT_FIELD"].default_value = 0
()["SC_24012_RESULT_FIELD"].type = 13
()["SC_24012_RESULT_FIELD"].cpp_type = 3
SC_24012.name = "sc_24012"
SC_24012.full_name = "p24.sc_24012"
SC_24012.nested_types = {}
SC_24012.enum_types = {}
SC_24012.fields = {
	()["SC_24012_RESULT_FIELD"]
}
SC_24012.is_extendable = false
SC_24012.extensions = {}
()["GROUPINFO_ID_FIELD"].name = "id"
()["GROUPINFO_ID_FIELD"].full_name = "p24.groupinfo.id"
()["GROUPINFO_ID_FIELD"].number = 1
()["GROUPINFO_ID_FIELD"].index = 0
()["GROUPINFO_ID_FIELD"].label = 2
()["GROUPINFO_ID_FIELD"].has_default_value = false
()["GROUPINFO_ID_FIELD"].default_value = 0
()["GROUPINFO_ID_FIELD"].type = 13
()["GROUPINFO_ID_FIELD"].cpp_type = 3
()["GROUPINFO_SHIP_LIST_FIELD"].name = "ship_list"
()["GROUPINFO_SHIP_LIST_FIELD"].full_name = "p24.groupinfo.ship_list"
()["GROUPINFO_SHIP_LIST_FIELD"].number = 2
()["GROUPINFO_SHIP_LIST_FIELD"].index = 1
()["GROUPINFO_SHIP_LIST_FIELD"].label = 3
()["GROUPINFO_SHIP_LIST_FIELD"].has_default_value = false
()["GROUPINFO_SHIP_LIST_FIELD"].default_value = {}
()["GROUPINFO_SHIP_LIST_FIELD"].type = 13
()["GROUPINFO_SHIP_LIST_FIELD"].cpp_type = 3
()["GROUPINFO_COMMANDERS_FIELD"].name = "commanders"
()["GROUPINFO_COMMANDERS_FIELD"].full_name = "p24.groupinfo.commanders"
()["GROUPINFO_COMMANDERS_FIELD"].number = 3
()["GROUPINFO_COMMANDERS_FIELD"].index = 2
()["GROUPINFO_COMMANDERS_FIELD"].label = 3
()["GROUPINFO_COMMANDERS_FIELD"].has_default_value = false
()["GROUPINFO_COMMANDERS_FIELD"].default_value = {}
()["GROUPINFO_COMMANDERS_FIELD"].message_type = slot1.COMMANDERSINFO
()["GROUPINFO_COMMANDERS_FIELD"].type = 11
()["GROUPINFO_COMMANDERS_FIELD"].cpp_type = 10
GROUPINFO.name = "groupinfo"
GROUPINFO.full_name = "p24.groupinfo"
GROUPINFO.nested_types = {}
GROUPINFO.enum_types = {}
GROUPINFO.fields = {
	()["GROUPINFO_ID_FIELD"],
	()["GROUPINFO_SHIP_LIST_FIELD"],
	()["GROUPINFO_COMMANDERS_FIELD"]
}
GROUPINFO.is_extendable = false
GROUPINFO.extensions = {}
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].name = "season_max_score"
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].full_name = "p24.challengeinfo.season_max_score"
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].number = 1
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].index = 0
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].label = 2
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].has_default_value = false
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].default_value = 0
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].type = 13
()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"].cpp_type = 3
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].name = "activity_max_score"
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].full_name = "p24.challengeinfo.activity_max_score"
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].number = 2
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].index = 1
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].label = 2
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].has_default_value = false
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].default_value = 0
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].type = 13
()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"].cpp_type = 3
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].name = "season_max_level"
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].full_name = "p24.challengeinfo.season_max_level"
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].number = 3
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].index = 2
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].label = 2
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].has_default_value = false
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].default_value = 0
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].type = 13
()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"].cpp_type = 3
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].name = "activity_max_level"
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].full_name = "p24.challengeinfo.activity_max_level"
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].number = 4
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].index = 3
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].label = 2
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].has_default_value = false
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].default_value = 0
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].type = 13
()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"].cpp_type = 3
()["CHALLENGEINFO_SEASON_ID_FIELD"].name = "season_id"
()["CHALLENGEINFO_SEASON_ID_FIELD"].full_name = "p24.challengeinfo.season_id"
()["CHALLENGEINFO_SEASON_ID_FIELD"].number = 5
()["CHALLENGEINFO_SEASON_ID_FIELD"].index = 4
()["CHALLENGEINFO_SEASON_ID_FIELD"].label = 2
()["CHALLENGEINFO_SEASON_ID_FIELD"].has_default_value = false
()["CHALLENGEINFO_SEASON_ID_FIELD"].default_value = 0
()["CHALLENGEINFO_SEASON_ID_FIELD"].type = 13
()["CHALLENGEINFO_SEASON_ID_FIELD"].cpp_type = 3
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].name = "dungeon_id_list"
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].full_name = "p24.challengeinfo.dungeon_id_list"
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].number = 6
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].index = 5
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].label = 3
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].has_default_value = false
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].default_value = {}
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].type = 13
()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].cpp_type = 3
()["CHALLENGEINFO_BUFF_LIST_FIELD"].name = "buff_list"
()["CHALLENGEINFO_BUFF_LIST_FIELD"].full_name = "p24.challengeinfo.buff_list"
()["CHALLENGEINFO_BUFF_LIST_FIELD"].number = 7
()["CHALLENGEINFO_BUFF_LIST_FIELD"].index = 6
()["CHALLENGEINFO_BUFF_LIST_FIELD"].label = 3
()["CHALLENGEINFO_BUFF_LIST_FIELD"].has_default_value = false
()["CHALLENGEINFO_BUFF_LIST_FIELD"].default_value = {}
()["CHALLENGEINFO_BUFF_LIST_FIELD"].type = 13
()["CHALLENGEINFO_BUFF_LIST_FIELD"].cpp_type = 3
CHALLENGEINFO.name = "challengeinfo"
CHALLENGEINFO.full_name = "p24.challengeinfo"
CHALLENGEINFO.nested_types = {}
CHALLENGEINFO.enum_types = {}
CHALLENGEINFO.fields = {
	()["CHALLENGEINFO_SEASON_MAX_SCORE_FIELD"],
	()["CHALLENGEINFO_ACTIVITY_MAX_SCORE_FIELD"],
	()["CHALLENGEINFO_SEASON_MAX_LEVEL_FIELD"],
	()["CHALLENGEINFO_ACTIVITY_MAX_LEVEL_FIELD"],
	()["CHALLENGEINFO_SEASON_ID_FIELD"],
	()["CHALLENGEINFO_DUNGEON_ID_LIST_FIELD"],
	()["CHALLENGEINFO_BUFF_LIST_FIELD"]
}
CHALLENGEINFO.is_extendable = false
CHALLENGEINFO.extensions = {}
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].name = "current_score"
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].full_name = "p24.userchallengeinfo.current_score"
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].number = 1
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].index = 0
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].label = 2
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].has_default_value = false
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].default_value = 0
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].type = 13
()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"].cpp_type = 3
()["USERCHALLENGEINFO_LEVEL_FIELD"].name = "level"
()["USERCHALLENGEINFO_LEVEL_FIELD"].full_name = "p24.userchallengeinfo.level"
()["USERCHALLENGEINFO_LEVEL_FIELD"].number = 2
()["USERCHALLENGEINFO_LEVEL_FIELD"].index = 1
()["USERCHALLENGEINFO_LEVEL_FIELD"].label = 2
()["USERCHALLENGEINFO_LEVEL_FIELD"].has_default_value = false
()["USERCHALLENGEINFO_LEVEL_FIELD"].default_value = 0
()["USERCHALLENGEINFO_LEVEL_FIELD"].type = 13
()["USERCHALLENGEINFO_LEVEL_FIELD"].cpp_type = 3
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].name = "groupinc_list"
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].full_name = "p24.userchallengeinfo.groupinc_list"
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].number = 3
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].index = 2
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].label = 3
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].has_default_value = false
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].default_value = {}
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].message_type = GROUPINFOINCHALLENGE
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].type = 11
()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"].cpp_type = 10
()["USERCHALLENGEINFO_MODE_FIELD"].name = "mode"
()["USERCHALLENGEINFO_MODE_FIELD"].full_name = "p24.userchallengeinfo.mode"
()["USERCHALLENGEINFO_MODE_FIELD"].number = 4
()["USERCHALLENGEINFO_MODE_FIELD"].index = 3
()["USERCHALLENGEINFO_MODE_FIELD"].label = 2
()["USERCHALLENGEINFO_MODE_FIELD"].has_default_value = false
()["USERCHALLENGEINFO_MODE_FIELD"].default_value = 0
()["USERCHALLENGEINFO_MODE_FIELD"].type = 13
()["USERCHALLENGEINFO_MODE_FIELD"].cpp_type = 3
()["USERCHALLENGEINFO_ISSL_FIELD"].name = "issl"
()["USERCHALLENGEINFO_ISSL_FIELD"].full_name = "p24.userchallengeinfo.issl"
()["USERCHALLENGEINFO_ISSL_FIELD"].number = 5
()["USERCHALLENGEINFO_ISSL_FIELD"].index = 4
()["USERCHALLENGEINFO_ISSL_FIELD"].label = 2
()["USERCHALLENGEINFO_ISSL_FIELD"].has_default_value = false
()["USERCHALLENGEINFO_ISSL_FIELD"].default_value = 0
()["USERCHALLENGEINFO_ISSL_FIELD"].type = 13
()["USERCHALLENGEINFO_ISSL_FIELD"].cpp_type = 3
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].name = "season_id"
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].full_name = "p24.userchallengeinfo.season_id"
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].number = 6
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].index = 5
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].label = 2
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].has_default_value = false
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].default_value = 0
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].type = 13
()["USERCHALLENGEINFO_SEASON_ID_FIELD"].cpp_type = 3
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].name = "dungeon_id_list"
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].full_name = "p24.userchallengeinfo.dungeon_id_list"
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].number = 7
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].index = 6
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].label = 3
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].has_default_value = false
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].default_value = {}
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].type = 13
()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"].cpp_type = 3
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].name = "buff_list"
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].full_name = "p24.userchallengeinfo.buff_list"
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].number = 8
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].index = 7
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].label = 3
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].has_default_value = false
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].default_value = {}
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].type = 13
()["USERCHALLENGEINFO_BUFF_LIST_FIELD"].cpp_type = 3
USERCHALLENGEINFO.name = "userchallengeinfo"
USERCHALLENGEINFO.full_name = "p24.userchallengeinfo"
USERCHALLENGEINFO.nested_types = {}
USERCHALLENGEINFO.enum_types = {}
USERCHALLENGEINFO.fields = {
	()["USERCHALLENGEINFO_CURRENT_SCORE_FIELD"],
	()["USERCHALLENGEINFO_LEVEL_FIELD"],
	()["USERCHALLENGEINFO_GROUPINC_LIST_FIELD"],
	()["USERCHALLENGEINFO_MODE_FIELD"],
	()["USERCHALLENGEINFO_ISSL_FIELD"],
	()["USERCHALLENGEINFO_SEASON_ID_FIELD"],
	()["USERCHALLENGEINFO_DUNGEON_ID_LIST_FIELD"],
	()["USERCHALLENGEINFO_BUFF_LIST_FIELD"]
}
USERCHALLENGEINFO.is_extendable = false
USERCHALLENGEINFO.extensions = {}
()["SHIPINCHALLENGE_ID_FIELD"].name = "id"
()["SHIPINCHALLENGE_ID_FIELD"].full_name = "p24.shipinchallenge.id"
()["SHIPINCHALLENGE_ID_FIELD"].number = 1
()["SHIPINCHALLENGE_ID_FIELD"].index = 0
()["SHIPINCHALLENGE_ID_FIELD"].label = 2
()["SHIPINCHALLENGE_ID_FIELD"].has_default_value = false
()["SHIPINCHALLENGE_ID_FIELD"].default_value = 0
()["SHIPINCHALLENGE_ID_FIELD"].type = 13
()["SHIPINCHALLENGE_ID_FIELD"].cpp_type = 3
()["SHIPINCHALLENGE_HP_RANT_FIELD"].name = "hp_rant"
()["SHIPINCHALLENGE_HP_RANT_FIELD"].full_name = "p24.shipinchallenge.hp_rant"
()["SHIPINCHALLENGE_HP_RANT_FIELD"].number = 2
()["SHIPINCHALLENGE_HP_RANT_FIELD"].index = 1
()["SHIPINCHALLENGE_HP_RANT_FIELD"].label = 2
()["SHIPINCHALLENGE_HP_RANT_FIELD"].has_default_value = false
()["SHIPINCHALLENGE_HP_RANT_FIELD"].default_value = 0
()["SHIPINCHALLENGE_HP_RANT_FIELD"].type = 13
()["SHIPINCHALLENGE_HP_RANT_FIELD"].cpp_type = 3
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].name = "ship_info"
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].full_name = "p24.shipinchallenge.ship_info"
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].number = 3
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].index = 2
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].label = 2
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].has_default_value = false
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].default_value = nil
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].message_type = slot1.SHIPINFO
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].type = 11
()["SHIPINCHALLENGE_SHIP_INFO_FIELD"].cpp_type = 10
SHIPINCHALLENGE.name = "shipinchallenge"
SHIPINCHALLENGE.full_name = "p24.shipinchallenge"
SHIPINCHALLENGE.nested_types = {}
SHIPINCHALLENGE.enum_types = {}
SHIPINCHALLENGE.fields = {
	()["SHIPINCHALLENGE_ID_FIELD"],
	()["SHIPINCHALLENGE_HP_RANT_FIELD"],
	()["SHIPINCHALLENGE_SHIP_INFO_FIELD"]
}
SHIPINCHALLENGE.is_extendable = false
SHIPINCHALLENGE.extensions = {}
()["GROUPINFOINCHALLENGE_ID_FIELD"].name = "id"
()["GROUPINFOINCHALLENGE_ID_FIELD"].full_name = "p24.groupinfoinchallenge.id"
()["GROUPINFOINCHALLENGE_ID_FIELD"].number = 1
()["GROUPINFOINCHALLENGE_ID_FIELD"].index = 0
()["GROUPINFOINCHALLENGE_ID_FIELD"].label = 2
()["GROUPINFOINCHALLENGE_ID_FIELD"].has_default_value = false
()["GROUPINFOINCHALLENGE_ID_FIELD"].default_value = 0
()["GROUPINFOINCHALLENGE_ID_FIELD"].type = 13
()["GROUPINFOINCHALLENGE_ID_FIELD"].cpp_type = 3
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].name = "ships"
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].full_name = "p24.groupinfoinchallenge.ships"
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].number = 2
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].index = 1
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].label = 3
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].has_default_value = false
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].default_value = {}
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].message_type = SHIPINCHALLENGE
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].type = 11
()["GROUPINFOINCHALLENGE_SHIPS_FIELD"].cpp_type = 10
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].name = "commanders"
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].full_name = "p24.groupinfoinchallenge.commanders"
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].number = 3
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].index = 2
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].label = 3
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].has_default_value = false
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].default_value = {}
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].message_type = COMMANDERINCHALLENGE
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].type = 11
()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"].cpp_type = 10
GROUPINFOINCHALLENGE.name = "groupinfoinchallenge"
GROUPINFOINCHALLENGE.full_name = "p24.groupinfoinchallenge"
GROUPINFOINCHALLENGE.nested_types = {}
GROUPINFOINCHALLENGE.enum_types = {}
GROUPINFOINCHALLENGE.fields = {
	()["GROUPINFOINCHALLENGE_ID_FIELD"],
	()["GROUPINFOINCHALLENGE_SHIPS_FIELD"],
	()["GROUPINFOINCHALLENGE_COMMANDERS_FIELD"]
}
GROUPINFOINCHALLENGE.is_extendable = false
GROUPINFOINCHALLENGE.extensions = {}
()["COMMANDERINCHALLENGE_POS_FIELD"].name = "pos"
()["COMMANDERINCHALLENGE_POS_FIELD"].full_name = "p24.commanderinchallenge.pos"
()["COMMANDERINCHALLENGE_POS_FIELD"].number = 1
()["COMMANDERINCHALLENGE_POS_FIELD"].index = 0
()["COMMANDERINCHALLENGE_POS_FIELD"].label = 2
()["COMMANDERINCHALLENGE_POS_FIELD"].has_default_value = false
()["COMMANDERINCHALLENGE_POS_FIELD"].default_value = 0
()["COMMANDERINCHALLENGE_POS_FIELD"].type = 13
()["COMMANDERINCHALLENGE_POS_FIELD"].cpp_type = 3
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].name = "commanderinfo"
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].full_name = "p24.commanderinchallenge.commanderinfo"
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].number = 2
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].index = 1
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].label = 2
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].has_default_value = false
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].default_value = nil
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].message_type = slot1.COMMANDERINFO
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].type = 11
()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"].cpp_type = 10
COMMANDERINCHALLENGE.name = "commanderinchallenge"
COMMANDERINCHALLENGE.full_name = "p24.commanderinchallenge"
COMMANDERINCHALLENGE.nested_types = {}
COMMANDERINCHALLENGE.enum_types = {}
COMMANDERINCHALLENGE.fields = {
	()["COMMANDERINCHALLENGE_POS_FIELD"],
	()["COMMANDERINCHALLENGE_COMMANDERINFO_FIELD"]
}
COMMANDERINCHALLENGE.is_extendable = false
COMMANDERINCHALLENGE.extensions = {}
challengeinfo = slot0.Message(CHALLENGEINFO)
commanderinchallenge = slot0.Message(COMMANDERINCHALLENGE)
cs_24002 = slot0.Message(CS_24002)
cs_24004 = slot0.Message(CS_24004)
cs_24011 = slot0.Message(CS_24011)
groupinfo = slot0.Message(GROUPINFO)
groupinfoinchallenge = slot0.Message(GROUPINFOINCHALLENGE)
sc_24003 = slot0.Message(SC_24003)
sc_24005 = slot0.Message(SC_24005)
sc_24010 = slot0.Message(SC_24010)
sc_24012 = slot0.Message(SC_24012)
shipinchallenge = slot0.Message(SHIPINCHALLENGE)
userchallengeinfo = slot0.Message(USERCHALLENGEINFO)

return
