slot0 = require("protobuf")

module("p14_pb")

SC_14001 = slot0.Descriptor()
CS_14002 = slot0.Descriptor()
SC_14003 = slot0.Descriptor()
CS_14004 = slot0.Descriptor()
SC_14005 = slot0.Descriptor()
CS_14006 = slot0.Descriptor()
SC_14007 = slot0.Descriptor()
CS_14008 = slot0.Descriptor()
SC_14009 = slot0.Descriptor()
CS_14010 = slot0.Descriptor()
SC_14011 = slot0.Descriptor()
CS_14013 = slot0.Descriptor()
SC_14014 = slot0.Descriptor()
CS_14015 = slot0.Descriptor()
SC_14016 = slot0.Descriptor()
EQUIPINFO = slot0.Descriptor()
SC_14101 = slot0.Descriptor()
EQUIPSKININFO = slot0.Descriptor()
({
	SC_14001_EQUIP_LIST_FIELD = slot0.FieldDescriptor(),
	SC_14001_SHIP_ID_LIST_FIELD = slot0.FieldDescriptor(),
	CS_14002_SHIP_ID_FIELD = slot0.FieldDescriptor(),
	CS_14002_POS_FIELD = slot0.FieldDescriptor(),
	SC_14003_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_14004_EQUIP_ID_FIELD = slot0.FieldDescriptor(),
	CS_14004_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_14005_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_14006_ID_FIELD = slot0.FieldDescriptor(),
	CS_14006_NUM_FIELD = slot0.FieldDescriptor(),
	SC_14007_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_14008_EQUIP_LIST_FIELD = slot0.FieldDescriptor(),
	SC_14009_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_14010_EQUIP_ID_FIELD = slot0.FieldDescriptor(),
	SC_14011_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_14013_SHIP_ID_FIELD = slot0.FieldDescriptor(),
	CS_14013_POS_FIELD = slot0.FieldDescriptor(),
	CS_14013_UPGRADE_ID_FIELD = slot0.FieldDescriptor(),
	SC_14014_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_14015_EQUIP_ID_FIELD = slot0.FieldDescriptor(),
	CS_14015_UPGRADE_ID_FIELD = slot0.FieldDescriptor(),
	SC_14016_RESULT_FIELD = slot0.FieldDescriptor(),
	EQUIPINFO_ID_FIELD = slot0.FieldDescriptor(),
	EQUIPINFO_COUNT_FIELD = slot0.FieldDescriptor(),
	SC_14101_EQUIP_SKIN_LIST_FIELD = slot0.FieldDescriptor(),
	EQUIPSKININFO_ID_FIELD = slot0.FieldDescriptor(),
	EQUIPSKININFO_COUNT_FIELD = slot0.FieldDescriptor()
})["SC_14001_EQUIP_LIST_FIELD"].name = "equip_list"
()["SC_14001_EQUIP_LIST_FIELD"].full_name = "p14.sc_14001.equip_list"
()["SC_14001_EQUIP_LIST_FIELD"].number = 1
()["SC_14001_EQUIP_LIST_FIELD"].index = 0
()["SC_14001_EQUIP_LIST_FIELD"].label = 3
()["SC_14001_EQUIP_LIST_FIELD"].has_default_value = false
()["SC_14001_EQUIP_LIST_FIELD"].default_value = {}
()["SC_14001_EQUIP_LIST_FIELD"].message_type = EQUIPINFO
()["SC_14001_EQUIP_LIST_FIELD"].type = 11
()["SC_14001_EQUIP_LIST_FIELD"].cpp_type = 10
()["SC_14001_SHIP_ID_LIST_FIELD"].name = "ship_id_list"
()["SC_14001_SHIP_ID_LIST_FIELD"].full_name = "p14.sc_14001.ship_id_list"
()["SC_14001_SHIP_ID_LIST_FIELD"].number = 3
()["SC_14001_SHIP_ID_LIST_FIELD"].index = 1
()["SC_14001_SHIP_ID_LIST_FIELD"].label = 3
()["SC_14001_SHIP_ID_LIST_FIELD"].has_default_value = false
()["SC_14001_SHIP_ID_LIST_FIELD"].default_value = {}
()["SC_14001_SHIP_ID_LIST_FIELD"].type = 13
()["SC_14001_SHIP_ID_LIST_FIELD"].cpp_type = 3
SC_14001.name = "sc_14001"
SC_14001.full_name = "p14.sc_14001"
SC_14001.nested_types = {}
SC_14001.enum_types = {}
SC_14001.fields = {
	()["SC_14001_EQUIP_LIST_FIELD"],
	()["SC_14001_SHIP_ID_LIST_FIELD"]
}
SC_14001.is_extendable = false
SC_14001.extensions = {}
()["CS_14002_SHIP_ID_FIELD"].name = "ship_id"
()["CS_14002_SHIP_ID_FIELD"].full_name = "p14.cs_14002.ship_id"
()["CS_14002_SHIP_ID_FIELD"].number = 1
()["CS_14002_SHIP_ID_FIELD"].index = 0
()["CS_14002_SHIP_ID_FIELD"].label = 2
()["CS_14002_SHIP_ID_FIELD"].has_default_value = false
()["CS_14002_SHIP_ID_FIELD"].default_value = 0
()["CS_14002_SHIP_ID_FIELD"].type = 13
()["CS_14002_SHIP_ID_FIELD"].cpp_type = 3
()["CS_14002_POS_FIELD"].name = "pos"
()["CS_14002_POS_FIELD"].full_name = "p14.cs_14002.pos"
()["CS_14002_POS_FIELD"].number = 2
()["CS_14002_POS_FIELD"].index = 1
()["CS_14002_POS_FIELD"].label = 2
()["CS_14002_POS_FIELD"].has_default_value = false
()["CS_14002_POS_FIELD"].default_value = 0
()["CS_14002_POS_FIELD"].type = 13
()["CS_14002_POS_FIELD"].cpp_type = 3
CS_14002.name = "cs_14002"
CS_14002.full_name = "p14.cs_14002"
CS_14002.nested_types = {}
CS_14002.enum_types = {}
CS_14002.fields = {
	()["CS_14002_SHIP_ID_FIELD"],
	()["CS_14002_POS_FIELD"]
}
CS_14002.is_extendable = false
CS_14002.extensions = {}
()["SC_14003_RESULT_FIELD"].name = "result"
()["SC_14003_RESULT_FIELD"].full_name = "p14.sc_14003.result"
()["SC_14003_RESULT_FIELD"].number = 1
()["SC_14003_RESULT_FIELD"].index = 0
()["SC_14003_RESULT_FIELD"].label = 2
()["SC_14003_RESULT_FIELD"].has_default_value = false
()["SC_14003_RESULT_FIELD"].default_value = 0
()["SC_14003_RESULT_FIELD"].type = 13
()["SC_14003_RESULT_FIELD"].cpp_type = 3
SC_14003.name = "sc_14003"
SC_14003.full_name = "p14.sc_14003"
SC_14003.nested_types = {}
SC_14003.enum_types = {}
SC_14003.fields = {
	()["SC_14003_RESULT_FIELD"]
}
SC_14003.is_extendable = false
SC_14003.extensions = {}
()["CS_14004_EQUIP_ID_FIELD"].name = "equip_id"
()["CS_14004_EQUIP_ID_FIELD"].full_name = "p14.cs_14004.equip_id"
()["CS_14004_EQUIP_ID_FIELD"].number = 1
()["CS_14004_EQUIP_ID_FIELD"].index = 0
()["CS_14004_EQUIP_ID_FIELD"].label = 2
()["CS_14004_EQUIP_ID_FIELD"].has_default_value = false
()["CS_14004_EQUIP_ID_FIELD"].default_value = 0
()["CS_14004_EQUIP_ID_FIELD"].type = 13
()["CS_14004_EQUIP_ID_FIELD"].cpp_type = 3
()["CS_14004_TYPE_FIELD"].name = "type"
()["CS_14004_TYPE_FIELD"].full_name = "p14.cs_14004.type"
()["CS_14004_TYPE_FIELD"].number = 2
()["CS_14004_TYPE_FIELD"].index = 1
()["CS_14004_TYPE_FIELD"].label = 2
()["CS_14004_TYPE_FIELD"].has_default_value = false
()["CS_14004_TYPE_FIELD"].default_value = 0
()["CS_14004_TYPE_FIELD"].type = 13
()["CS_14004_TYPE_FIELD"].cpp_type = 3
CS_14004.name = "cs_14004"
CS_14004.full_name = "p14.cs_14004"
CS_14004.nested_types = {}
CS_14004.enum_types = {}
CS_14004.fields = {
	()["CS_14004_EQUIP_ID_FIELD"],
	()["CS_14004_TYPE_FIELD"]
}
CS_14004.is_extendable = false
CS_14004.extensions = {}
()["SC_14005_RESULT_FIELD"].name = "result"
()["SC_14005_RESULT_FIELD"].full_name = "p14.sc_14005.result"
()["SC_14005_RESULT_FIELD"].number = 1
()["SC_14005_RESULT_FIELD"].index = 0
()["SC_14005_RESULT_FIELD"].label = 2
()["SC_14005_RESULT_FIELD"].has_default_value = false
()["SC_14005_RESULT_FIELD"].default_value = 0
()["SC_14005_RESULT_FIELD"].type = 13
()["SC_14005_RESULT_FIELD"].cpp_type = 3
SC_14005.name = "sc_14005"
SC_14005.full_name = "p14.sc_14005"
SC_14005.nested_types = {}
SC_14005.enum_types = {}
SC_14005.fields = {
	()["SC_14005_RESULT_FIELD"]
}
SC_14005.is_extendable = false
SC_14005.extensions = {}
()["CS_14006_ID_FIELD"].name = "id"
()["CS_14006_ID_FIELD"].full_name = "p14.cs_14006.id"
()["CS_14006_ID_FIELD"].number = 1
()["CS_14006_ID_FIELD"].index = 0
()["CS_14006_ID_FIELD"].label = 2
()["CS_14006_ID_FIELD"].has_default_value = false
()["CS_14006_ID_FIELD"].default_value = 0
()["CS_14006_ID_FIELD"].type = 13
()["CS_14006_ID_FIELD"].cpp_type = 3
()["CS_14006_NUM_FIELD"].name = "num"
()["CS_14006_NUM_FIELD"].full_name = "p14.cs_14006.num"
()["CS_14006_NUM_FIELD"].number = 2
()["CS_14006_NUM_FIELD"].index = 1
()["CS_14006_NUM_FIELD"].label = 2
()["CS_14006_NUM_FIELD"].has_default_value = false
()["CS_14006_NUM_FIELD"].default_value = 0
()["CS_14006_NUM_FIELD"].type = 13
()["CS_14006_NUM_FIELD"].cpp_type = 3
CS_14006.name = "cs_14006"
CS_14006.full_name = "p14.cs_14006"
CS_14006.nested_types = {}
CS_14006.enum_types = {}
CS_14006.fields = {
	()["CS_14006_ID_FIELD"],
	()["CS_14006_NUM_FIELD"]
}
CS_14006.is_extendable = false
CS_14006.extensions = {}
()["SC_14007_RESULT_FIELD"].name = "result"
()["SC_14007_RESULT_FIELD"].full_name = "p14.sc_14007.result"
()["SC_14007_RESULT_FIELD"].number = 1
()["SC_14007_RESULT_FIELD"].index = 0
()["SC_14007_RESULT_FIELD"].label = 2
()["SC_14007_RESULT_FIELD"].has_default_value = false
()["SC_14007_RESULT_FIELD"].default_value = 0
()["SC_14007_RESULT_FIELD"].type = 13
()["SC_14007_RESULT_FIELD"].cpp_type = 3
SC_14007.name = "sc_14007"
SC_14007.full_name = "p14.sc_14007"
SC_14007.nested_types = {}
SC_14007.enum_types = {}
SC_14007.fields = {
	()["SC_14007_RESULT_FIELD"]
}
SC_14007.is_extendable = false
SC_14007.extensions = {}
()["CS_14008_EQUIP_LIST_FIELD"].name = "equip_list"
()["CS_14008_EQUIP_LIST_FIELD"].full_name = "p14.cs_14008.equip_list"
()["CS_14008_EQUIP_LIST_FIELD"].number = 1
()["CS_14008_EQUIP_LIST_FIELD"].index = 0
()["CS_14008_EQUIP_LIST_FIELD"].label = 3
()["CS_14008_EQUIP_LIST_FIELD"].has_default_value = false
()["CS_14008_EQUIP_LIST_FIELD"].default_value = {}
()["CS_14008_EQUIP_LIST_FIELD"].message_type = EQUIPINFO
()["CS_14008_EQUIP_LIST_FIELD"].type = 11
()["CS_14008_EQUIP_LIST_FIELD"].cpp_type = 10
CS_14008.name = "cs_14008"
CS_14008.full_name = "p14.cs_14008"
CS_14008.nested_types = {}
CS_14008.enum_types = {}
CS_14008.fields = {
	()["CS_14008_EQUIP_LIST_FIELD"]
}
CS_14008.is_extendable = false
CS_14008.extensions = {}
()["SC_14009_RESULT_FIELD"].name = "result"
()["SC_14009_RESULT_FIELD"].full_name = "p14.sc_14009.result"
()["SC_14009_RESULT_FIELD"].number = 1
()["SC_14009_RESULT_FIELD"].index = 0
()["SC_14009_RESULT_FIELD"].label = 2
()["SC_14009_RESULT_FIELD"].has_default_value = false
()["SC_14009_RESULT_FIELD"].default_value = 0
()["SC_14009_RESULT_FIELD"].type = 13
()["SC_14009_RESULT_FIELD"].cpp_type = 3
SC_14009.name = "sc_14009"
SC_14009.full_name = "p14.sc_14009"
SC_14009.nested_types = {}
SC_14009.enum_types = {}
SC_14009.fields = {
	()["SC_14009_RESULT_FIELD"]
}
SC_14009.is_extendable = false
SC_14009.extensions = {}
()["CS_14010_EQUIP_ID_FIELD"].name = "equip_id"
()["CS_14010_EQUIP_ID_FIELD"].full_name = "p14.cs_14010.equip_id"
()["CS_14010_EQUIP_ID_FIELD"].number = 1
()["CS_14010_EQUIP_ID_FIELD"].index = 0
()["CS_14010_EQUIP_ID_FIELD"].label = 2
()["CS_14010_EQUIP_ID_FIELD"].has_default_value = false
()["CS_14010_EQUIP_ID_FIELD"].default_value = 0
()["CS_14010_EQUIP_ID_FIELD"].type = 13
()["CS_14010_EQUIP_ID_FIELD"].cpp_type = 3
CS_14010.name = "cs_14010"
CS_14010.full_name = "p14.cs_14010"
CS_14010.nested_types = {}
CS_14010.enum_types = {}
CS_14010.fields = {
	()["CS_14010_EQUIP_ID_FIELD"]
}
CS_14010.is_extendable = false
CS_14010.extensions = {}
()["SC_14011_RESULT_FIELD"].name = "result"
()["SC_14011_RESULT_FIELD"].full_name = "p14.sc_14011.result"
()["SC_14011_RESULT_FIELD"].number = 1
()["SC_14011_RESULT_FIELD"].index = 0
()["SC_14011_RESULT_FIELD"].label = 2
()["SC_14011_RESULT_FIELD"].has_default_value = false
()["SC_14011_RESULT_FIELD"].default_value = 0
()["SC_14011_RESULT_FIELD"].type = 13
()["SC_14011_RESULT_FIELD"].cpp_type = 3
SC_14011.name = "sc_14011"
SC_14011.full_name = "p14.sc_14011"
SC_14011.nested_types = {}
SC_14011.enum_types = {}
SC_14011.fields = {
	()["SC_14011_RESULT_FIELD"]
}
SC_14011.is_extendable = false
SC_14011.extensions = {}
()["CS_14013_SHIP_ID_FIELD"].name = "ship_id"
()["CS_14013_SHIP_ID_FIELD"].full_name = "p14.cs_14013.ship_id"
()["CS_14013_SHIP_ID_FIELD"].number = 1
()["CS_14013_SHIP_ID_FIELD"].index = 0
()["CS_14013_SHIP_ID_FIELD"].label = 2
()["CS_14013_SHIP_ID_FIELD"].has_default_value = false
()["CS_14013_SHIP_ID_FIELD"].default_value = 0
()["CS_14013_SHIP_ID_FIELD"].type = 13
()["CS_14013_SHIP_ID_FIELD"].cpp_type = 3
()["CS_14013_POS_FIELD"].name = "pos"
()["CS_14013_POS_FIELD"].full_name = "p14.cs_14013.pos"
()["CS_14013_POS_FIELD"].number = 2
()["CS_14013_POS_FIELD"].index = 1
()["CS_14013_POS_FIELD"].label = 2
()["CS_14013_POS_FIELD"].has_default_value = false
()["CS_14013_POS_FIELD"].default_value = 0
()["CS_14013_POS_FIELD"].type = 13
()["CS_14013_POS_FIELD"].cpp_type = 3
()["CS_14013_UPGRADE_ID_FIELD"].name = "upgrade_id"
()["CS_14013_UPGRADE_ID_FIELD"].full_name = "p14.cs_14013.upgrade_id"
()["CS_14013_UPGRADE_ID_FIELD"].number = 3
()["CS_14013_UPGRADE_ID_FIELD"].index = 2
()["CS_14013_UPGRADE_ID_FIELD"].label = 2
()["CS_14013_UPGRADE_ID_FIELD"].has_default_value = false
()["CS_14013_UPGRADE_ID_FIELD"].default_value = 0
()["CS_14013_UPGRADE_ID_FIELD"].type = 13
()["CS_14013_UPGRADE_ID_FIELD"].cpp_type = 3
CS_14013.name = "cs_14013"
CS_14013.full_name = "p14.cs_14013"
CS_14013.nested_types = {}
CS_14013.enum_types = {}
CS_14013.fields = {
	()["CS_14013_SHIP_ID_FIELD"],
	()["CS_14013_POS_FIELD"],
	()["CS_14013_UPGRADE_ID_FIELD"]
}
CS_14013.is_extendable = false
CS_14013.extensions = {}
()["SC_14014_RESULT_FIELD"].name = "result"
()["SC_14014_RESULT_FIELD"].full_name = "p14.sc_14014.result"
()["SC_14014_RESULT_FIELD"].number = 1
()["SC_14014_RESULT_FIELD"].index = 0
()["SC_14014_RESULT_FIELD"].label = 2
()["SC_14014_RESULT_FIELD"].has_default_value = false
()["SC_14014_RESULT_FIELD"].default_value = 0
()["SC_14014_RESULT_FIELD"].type = 13
()["SC_14014_RESULT_FIELD"].cpp_type = 3
SC_14014.name = "sc_14014"
SC_14014.full_name = "p14.sc_14014"
SC_14014.nested_types = {}
SC_14014.enum_types = {}
SC_14014.fields = {
	()["SC_14014_RESULT_FIELD"]
}
SC_14014.is_extendable = false
SC_14014.extensions = {}
()["CS_14015_EQUIP_ID_FIELD"].name = "equip_id"
()["CS_14015_EQUIP_ID_FIELD"].full_name = "p14.cs_14015.equip_id"
()["CS_14015_EQUIP_ID_FIELD"].number = 1
()["CS_14015_EQUIP_ID_FIELD"].index = 0
()["CS_14015_EQUIP_ID_FIELD"].label = 2
()["CS_14015_EQUIP_ID_FIELD"].has_default_value = false
()["CS_14015_EQUIP_ID_FIELD"].default_value = 0
()["CS_14015_EQUIP_ID_FIELD"].type = 13
()["CS_14015_EQUIP_ID_FIELD"].cpp_type = 3
()["CS_14015_UPGRADE_ID_FIELD"].name = "upgrade_id"
()["CS_14015_UPGRADE_ID_FIELD"].full_name = "p14.cs_14015.upgrade_id"
()["CS_14015_UPGRADE_ID_FIELD"].number = 2
()["CS_14015_UPGRADE_ID_FIELD"].index = 1
()["CS_14015_UPGRADE_ID_FIELD"].label = 2
()["CS_14015_UPGRADE_ID_FIELD"].has_default_value = false
()["CS_14015_UPGRADE_ID_FIELD"].default_value = 0
()["CS_14015_UPGRADE_ID_FIELD"].type = 13
()["CS_14015_UPGRADE_ID_FIELD"].cpp_type = 3
CS_14015.name = "cs_14015"
CS_14015.full_name = "p14.cs_14015"
CS_14015.nested_types = {}
CS_14015.enum_types = {}
CS_14015.fields = {
	()["CS_14015_EQUIP_ID_FIELD"],
	()["CS_14015_UPGRADE_ID_FIELD"]
}
CS_14015.is_extendable = false
CS_14015.extensions = {}
()["SC_14016_RESULT_FIELD"].name = "result"
()["SC_14016_RESULT_FIELD"].full_name = "p14.sc_14016.result"
()["SC_14016_RESULT_FIELD"].number = 1
()["SC_14016_RESULT_FIELD"].index = 0
()["SC_14016_RESULT_FIELD"].label = 2
()["SC_14016_RESULT_FIELD"].has_default_value = false
()["SC_14016_RESULT_FIELD"].default_value = 0
()["SC_14016_RESULT_FIELD"].type = 13
()["SC_14016_RESULT_FIELD"].cpp_type = 3
SC_14016.name = "sc_14016"
SC_14016.full_name = "p14.sc_14016"
SC_14016.nested_types = {}
SC_14016.enum_types = {}
SC_14016.fields = {
	()["SC_14016_RESULT_FIELD"]
}
SC_14016.is_extendable = false
SC_14016.extensions = {}
()["EQUIPINFO_ID_FIELD"].name = "id"
()["EQUIPINFO_ID_FIELD"].full_name = "p14.equipinfo.id"
()["EQUIPINFO_ID_FIELD"].number = 1
()["EQUIPINFO_ID_FIELD"].index = 0
()["EQUIPINFO_ID_FIELD"].label = 2
()["EQUIPINFO_ID_FIELD"].has_default_value = false
()["EQUIPINFO_ID_FIELD"].default_value = 0
()["EQUIPINFO_ID_FIELD"].type = 13
()["EQUIPINFO_ID_FIELD"].cpp_type = 3
()["EQUIPINFO_COUNT_FIELD"].name = "count"
()["EQUIPINFO_COUNT_FIELD"].full_name = "p14.equipinfo.count"
()["EQUIPINFO_COUNT_FIELD"].number = 2
()["EQUIPINFO_COUNT_FIELD"].index = 1
()["EQUIPINFO_COUNT_FIELD"].label = 2
()["EQUIPINFO_COUNT_FIELD"].has_default_value = false
()["EQUIPINFO_COUNT_FIELD"].default_value = 0
()["EQUIPINFO_COUNT_FIELD"].type = 13
()["EQUIPINFO_COUNT_FIELD"].cpp_type = 3
EQUIPINFO.name = "equipinfo"
EQUIPINFO.full_name = "p14.equipinfo"
EQUIPINFO.nested_types = {}
EQUIPINFO.enum_types = {}
EQUIPINFO.fields = {
	()["EQUIPINFO_ID_FIELD"],
	()["EQUIPINFO_COUNT_FIELD"]
}
EQUIPINFO.is_extendable = false
EQUIPINFO.extensions = {}
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].name = "equip_skin_list"
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].full_name = "p14.sc_14101.equip_skin_list"
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].number = 1
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].index = 0
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].label = 3
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].has_default_value = false
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].default_value = {}
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].message_type = EQUIPSKININFO
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].type = 11
()["SC_14101_EQUIP_SKIN_LIST_FIELD"].cpp_type = 10
SC_14101.name = "sc_14101"
SC_14101.full_name = "p14.sc_14101"
SC_14101.nested_types = {}
SC_14101.enum_types = {}
SC_14101.fields = {
	()["SC_14101_EQUIP_SKIN_LIST_FIELD"]
}
SC_14101.is_extendable = false
SC_14101.extensions = {}
()["EQUIPSKININFO_ID_FIELD"].name = "id"
()["EQUIPSKININFO_ID_FIELD"].full_name = "p14.equipskininfo.id"
()["EQUIPSKININFO_ID_FIELD"].number = 1
()["EQUIPSKININFO_ID_FIELD"].index = 0
()["EQUIPSKININFO_ID_FIELD"].label = 2
()["EQUIPSKININFO_ID_FIELD"].has_default_value = false
()["EQUIPSKININFO_ID_FIELD"].default_value = 0
()["EQUIPSKININFO_ID_FIELD"].type = 13
()["EQUIPSKININFO_ID_FIELD"].cpp_type = 3
()["EQUIPSKININFO_COUNT_FIELD"].name = "count"
()["EQUIPSKININFO_COUNT_FIELD"].full_name = "p14.equipskininfo.count"
()["EQUIPSKININFO_COUNT_FIELD"].number = 2
()["EQUIPSKININFO_COUNT_FIELD"].index = 1
()["EQUIPSKININFO_COUNT_FIELD"].label = 2
()["EQUIPSKININFO_COUNT_FIELD"].has_default_value = false
()["EQUIPSKININFO_COUNT_FIELD"].default_value = 0
()["EQUIPSKININFO_COUNT_FIELD"].type = 13
()["EQUIPSKININFO_COUNT_FIELD"].cpp_type = 3
EQUIPSKININFO.name = "equipskininfo"
EQUIPSKININFO.full_name = "p14.equipskininfo"
EQUIPSKININFO.nested_types = {}
EQUIPSKININFO.enum_types = {}
EQUIPSKININFO.fields = {
	()["EQUIPSKININFO_ID_FIELD"],
	()["EQUIPSKININFO_COUNT_FIELD"]
}
EQUIPSKININFO.is_extendable = false
EQUIPSKININFO.extensions = {}
cs_14002 = slot0.Message(CS_14002)
cs_14004 = slot0.Message(CS_14004)
cs_14006 = slot0.Message(CS_14006)
cs_14008 = slot0.Message(CS_14008)
cs_14010 = slot0.Message(CS_14010)
cs_14013 = slot0.Message(CS_14013)
cs_14015 = slot0.Message(CS_14015)
equipinfo = slot0.Message(EQUIPINFO)
equipskininfo = slot0.Message(EQUIPSKININFO)
sc_14001 = slot0.Message(SC_14001)
sc_14003 = slot0.Message(SC_14003)
sc_14005 = slot0.Message(SC_14005)
sc_14007 = slot0.Message(SC_14007)
sc_14009 = slot0.Message(SC_14009)
sc_14011 = slot0.Message(SC_14011)
sc_14014 = slot0.Message(SC_14014)
sc_14016 = slot0.Message(SC_14016)
sc_14101 = slot0.Message(SC_14101)

return
