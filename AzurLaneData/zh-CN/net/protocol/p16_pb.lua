slot0 = require("protobuf")
slot1 = require("common_pb")

module("p16_pb")

CS_16001 = slot0.Descriptor()
SC_16002 = slot0.Descriptor()
CS_16100 = slot0.Descriptor()
SC_16101 = slot0.Descriptor()
CS_16102 = slot0.Descriptor()
SC_16103 = slot0.Descriptor()
CS_16104 = slot0.Descriptor()
SC_16105 = slot0.Descriptor()
CS_16106 = slot0.Descriptor()
SC_16107 = slot0.Descriptor()
CS_16108 = slot0.Descriptor()
SC_16109 = slot0.Descriptor()
SC_16200 = slot0.Descriptor()
CS_16201 = slot0.Descriptor()
SC_16202 = slot0.Descriptor()
SHOPINFO = slot0.Descriptor()
({
	CS_16001_ID_FIELD = slot0.FieldDescriptor(),
	CS_16001_NUMBER_FIELD = slot0.FieldDescriptor(),
	SC_16002_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_16002_DROP_LIST_FIELD = slot0.FieldDescriptor(),
	CS_16100_TIME_FIELD = slot0.FieldDescriptor(),
	SC_16101_SHIP_ID_LIST_FIELD = slot0.FieldDescriptor(),
	SC_16101_FETCHED_INDEX_LIST_FIELD = slot0.FieldDescriptor(),
	SC_16101_FLASH_TIME_FIELD = slot0.FieldDescriptor(),
	SC_16101_FLAG_SHIP_FLASH_TIME_FIELD = slot0.FieldDescriptor(),
	CS_16102_INDEX_FIELD = slot0.FieldDescriptor(),
	CS_16102_FLASH_TIME_FIELD = slot0.FieldDescriptor(),
	SC_16103_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_16103_SHIP_INFO_FIELD = slot0.FieldDescriptor(),
	CS_16104_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_16105_FIRST_PAY_LIST_FIELD = slot0.FieldDescriptor(),
	SC_16105_PAY_LIST_FIELD = slot0.FieldDescriptor(),
	SC_16105_NORMAL_LIST_FIELD = slot0.FieldDescriptor(),
	SC_16105_NORMAL_GROUP_LIST_FIELD = slot0.FieldDescriptor(),
	CS_16106_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_16107_ITEM_FLASH_TIME_FIELD = slot0.FieldDescriptor(),
	SC_16107_ITEM_SHOP_ID_LIST_FIELD = slot0.FieldDescriptor(),
	SC_16107_ITEM_FETCH_LIST_FIELD = slot0.FieldDescriptor(),
	CS_16108_SHOP_ID_FIELD = slot0.FieldDescriptor(),
	CS_16108_FLASH_TIME_FIELD = slot0.FieldDescriptor(),
	SC_16109_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_16200_CORE_SHOP_LIST_FIELD = slot0.FieldDescriptor(),
	SC_16200_BLUE_SHOP_LIST_FIELD = slot0.FieldDescriptor(),
	SC_16200_NORMAL_SHOP_LIST_FIELD = slot0.FieldDescriptor(),
	CS_16201_TYPE_FIELD = slot0.FieldDescriptor(),
	CS_16201_ID_FIELD = slot0.FieldDescriptor(),
	CS_16201_COUNT_FIELD = slot0.FieldDescriptor(),
	SC_16202_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_16202_DROP_LIST_FIELD = slot0.FieldDescriptor(),
	SHOPINFO_SHOP_ID_FIELD = slot0.FieldDescriptor(),
	SHOPINFO_PAY_COUNT_FIELD = slot0.FieldDescriptor()
})["CS_16001_ID_FIELD"].name = "id"
()["CS_16001_ID_FIELD"].full_name = "p16.cs_16001.id"
()["CS_16001_ID_FIELD"].number = 1
()["CS_16001_ID_FIELD"].index = 0
()["CS_16001_ID_FIELD"].label = 2
()["CS_16001_ID_FIELD"].has_default_value = false
()["CS_16001_ID_FIELD"].default_value = 0
()["CS_16001_ID_FIELD"].type = 13
()["CS_16001_ID_FIELD"].cpp_type = 3
()["CS_16001_NUMBER_FIELD"].name = "number"
()["CS_16001_NUMBER_FIELD"].full_name = "p16.cs_16001.number"
()["CS_16001_NUMBER_FIELD"].number = 2
()["CS_16001_NUMBER_FIELD"].index = 1
()["CS_16001_NUMBER_FIELD"].label = 2
()["CS_16001_NUMBER_FIELD"].has_default_value = false
()["CS_16001_NUMBER_FIELD"].default_value = 0
()["CS_16001_NUMBER_FIELD"].type = 13
()["CS_16001_NUMBER_FIELD"].cpp_type = 3
CS_16001.name = "cs_16001"
CS_16001.full_name = "p16.cs_16001"
CS_16001.nested_types = {}
CS_16001.enum_types = {}
CS_16001.fields = {
	()["CS_16001_ID_FIELD"],
	()["CS_16001_NUMBER_FIELD"]
}
CS_16001.is_extendable = false
CS_16001.extensions = {}
()["SC_16002_RESULT_FIELD"].name = "result"
()["SC_16002_RESULT_FIELD"].full_name = "p16.sc_16002.result"
()["SC_16002_RESULT_FIELD"].number = 1
()["SC_16002_RESULT_FIELD"].index = 0
()["SC_16002_RESULT_FIELD"].label = 2
()["SC_16002_RESULT_FIELD"].has_default_value = false
()["SC_16002_RESULT_FIELD"].default_value = 0
()["SC_16002_RESULT_FIELD"].type = 13
()["SC_16002_RESULT_FIELD"].cpp_type = 3
()["SC_16002_DROP_LIST_FIELD"].name = "drop_list"
()["SC_16002_DROP_LIST_FIELD"].full_name = "p16.sc_16002.drop_list"
()["SC_16002_DROP_LIST_FIELD"].number = 2
()["SC_16002_DROP_LIST_FIELD"].index = 1
()["SC_16002_DROP_LIST_FIELD"].label = 3
()["SC_16002_DROP_LIST_FIELD"].has_default_value = false
()["SC_16002_DROP_LIST_FIELD"].default_value = {}
()["SC_16002_DROP_LIST_FIELD"].message_type = slot1.DROPINFO
()["SC_16002_DROP_LIST_FIELD"].type = 11
()["SC_16002_DROP_LIST_FIELD"].cpp_type = 10
SC_16002.name = "sc_16002"
SC_16002.full_name = "p16.sc_16002"
SC_16002.nested_types = {}
SC_16002.enum_types = {}
SC_16002.fields = {
	()["SC_16002_RESULT_FIELD"],
	()["SC_16002_DROP_LIST_FIELD"]
}
SC_16002.is_extendable = false
SC_16002.extensions = {}
()["CS_16100_TIME_FIELD"].name = "time"
()["CS_16100_TIME_FIELD"].full_name = "p16.cs_16100.time"
()["CS_16100_TIME_FIELD"].number = 1
()["CS_16100_TIME_FIELD"].index = 0
()["CS_16100_TIME_FIELD"].label = 2
()["CS_16100_TIME_FIELD"].has_default_value = false
()["CS_16100_TIME_FIELD"].default_value = 0
()["CS_16100_TIME_FIELD"].type = 13
()["CS_16100_TIME_FIELD"].cpp_type = 3
CS_16100.name = "cs_16100"
CS_16100.full_name = "p16.cs_16100"
CS_16100.nested_types = {}
CS_16100.enum_types = {}
CS_16100.fields = {
	()["CS_16100_TIME_FIELD"]
}
CS_16100.is_extendable = false
CS_16100.extensions = {}
()["SC_16101_SHIP_ID_LIST_FIELD"].name = "ship_id_list"
()["SC_16101_SHIP_ID_LIST_FIELD"].full_name = "p16.sc_16101.ship_id_list"
()["SC_16101_SHIP_ID_LIST_FIELD"].number = 1
()["SC_16101_SHIP_ID_LIST_FIELD"].index = 0
()["SC_16101_SHIP_ID_LIST_FIELD"].label = 3
()["SC_16101_SHIP_ID_LIST_FIELD"].has_default_value = false
()["SC_16101_SHIP_ID_LIST_FIELD"].default_value = {}
()["SC_16101_SHIP_ID_LIST_FIELD"].type = 13
()["SC_16101_SHIP_ID_LIST_FIELD"].cpp_type = 3
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].name = "fetched_index_list"
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].full_name = "p16.sc_16101.fetched_index_list"
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].number = 2
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].index = 1
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].label = 3
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].has_default_value = false
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].default_value = {}
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].type = 13
()["SC_16101_FETCHED_INDEX_LIST_FIELD"].cpp_type = 3
()["SC_16101_FLASH_TIME_FIELD"].name = "flash_time"
()["SC_16101_FLASH_TIME_FIELD"].full_name = "p16.sc_16101.flash_time"
()["SC_16101_FLASH_TIME_FIELD"].number = 3
()["SC_16101_FLASH_TIME_FIELD"].index = 2
()["SC_16101_FLASH_TIME_FIELD"].label = 2
()["SC_16101_FLASH_TIME_FIELD"].has_default_value = false
()["SC_16101_FLASH_TIME_FIELD"].default_value = 0
()["SC_16101_FLASH_TIME_FIELD"].type = 13
()["SC_16101_FLASH_TIME_FIELD"].cpp_type = 3
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].name = "flag_ship_flash_time"
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].full_name = "p16.sc_16101.flag_ship_flash_time"
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].number = 4
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].index = 3
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].label = 2
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].has_default_value = false
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].default_value = 0
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].type = 13
()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"].cpp_type = 3
SC_16101.name = "sc_16101"
SC_16101.full_name = "p16.sc_16101"
SC_16101.nested_types = {}
SC_16101.enum_types = {}
SC_16101.fields = {
	()["SC_16101_SHIP_ID_LIST_FIELD"],
	()["SC_16101_FETCHED_INDEX_LIST_FIELD"],
	()["SC_16101_FLASH_TIME_FIELD"],
	()["SC_16101_FLAG_SHIP_FLASH_TIME_FIELD"]
}
SC_16101.is_extendable = false
SC_16101.extensions = {}
()["CS_16102_INDEX_FIELD"].name = "index"
()["CS_16102_INDEX_FIELD"].full_name = "p16.cs_16102.index"
()["CS_16102_INDEX_FIELD"].number = 1
()["CS_16102_INDEX_FIELD"].index = 0
()["CS_16102_INDEX_FIELD"].label = 2
()["CS_16102_INDEX_FIELD"].has_default_value = false
()["CS_16102_INDEX_FIELD"].default_value = 0
()["CS_16102_INDEX_FIELD"].type = 13
()["CS_16102_INDEX_FIELD"].cpp_type = 3
()["CS_16102_FLASH_TIME_FIELD"].name = "flash_time"
()["CS_16102_FLASH_TIME_FIELD"].full_name = "p16.cs_16102.flash_time"
()["CS_16102_FLASH_TIME_FIELD"].number = 2
()["CS_16102_FLASH_TIME_FIELD"].index = 1
()["CS_16102_FLASH_TIME_FIELD"].label = 2
()["CS_16102_FLASH_TIME_FIELD"].has_default_value = false
()["CS_16102_FLASH_TIME_FIELD"].default_value = 0
()["CS_16102_FLASH_TIME_FIELD"].type = 13
()["CS_16102_FLASH_TIME_FIELD"].cpp_type = 3
CS_16102.name = "cs_16102"
CS_16102.full_name = "p16.cs_16102"
CS_16102.nested_types = {}
CS_16102.enum_types = {}
CS_16102.fields = {
	()["CS_16102_INDEX_FIELD"],
	()["CS_16102_FLASH_TIME_FIELD"]
}
CS_16102.is_extendable = false
CS_16102.extensions = {}
()["SC_16103_RESULT_FIELD"].name = "result"
()["SC_16103_RESULT_FIELD"].full_name = "p16.sc_16103.result"
()["SC_16103_RESULT_FIELD"].number = 1
()["SC_16103_RESULT_FIELD"].index = 0
()["SC_16103_RESULT_FIELD"].label = 2
()["SC_16103_RESULT_FIELD"].has_default_value = false
()["SC_16103_RESULT_FIELD"].default_value = 0
()["SC_16103_RESULT_FIELD"].type = 13
()["SC_16103_RESULT_FIELD"].cpp_type = 3
()["SC_16103_SHIP_INFO_FIELD"].name = "ship_info"
()["SC_16103_SHIP_INFO_FIELD"].full_name = "p16.sc_16103.ship_info"
()["SC_16103_SHIP_INFO_FIELD"].number = 2
()["SC_16103_SHIP_INFO_FIELD"].index = 1
()["SC_16103_SHIP_INFO_FIELD"].label = 1
()["SC_16103_SHIP_INFO_FIELD"].has_default_value = false
()["SC_16103_SHIP_INFO_FIELD"].default_value = nil
()["SC_16103_SHIP_INFO_FIELD"].message_type = slot1.SHIPINFO
()["SC_16103_SHIP_INFO_FIELD"].type = 11
()["SC_16103_SHIP_INFO_FIELD"].cpp_type = 10
SC_16103.name = "sc_16103"
SC_16103.full_name = "p16.sc_16103"
SC_16103.nested_types = {}
SC_16103.enum_types = {}
SC_16103.fields = {
	()["SC_16103_RESULT_FIELD"],
	()["SC_16103_SHIP_INFO_FIELD"]
}
SC_16103.is_extendable = false
SC_16103.extensions = {}
()["CS_16104_TYPE_FIELD"].name = "type"
()["CS_16104_TYPE_FIELD"].full_name = "p16.cs_16104.type"
()["CS_16104_TYPE_FIELD"].number = 1
()["CS_16104_TYPE_FIELD"].index = 0
()["CS_16104_TYPE_FIELD"].label = 2
()["CS_16104_TYPE_FIELD"].has_default_value = false
()["CS_16104_TYPE_FIELD"].default_value = 0
()["CS_16104_TYPE_FIELD"].type = 13
()["CS_16104_TYPE_FIELD"].cpp_type = 3
CS_16104.name = "cs_16104"
CS_16104.full_name = "p16.cs_16104"
CS_16104.nested_types = {}
CS_16104.enum_types = {}
CS_16104.fields = {
	()["CS_16104_TYPE_FIELD"]
}
CS_16104.is_extendable = false
CS_16104.extensions = {}
()["SC_16105_FIRST_PAY_LIST_FIELD"].name = "first_pay_list"
()["SC_16105_FIRST_PAY_LIST_FIELD"].full_name = "p16.sc_16105.first_pay_list"
()["SC_16105_FIRST_PAY_LIST_FIELD"].number = 1
()["SC_16105_FIRST_PAY_LIST_FIELD"].index = 0
()["SC_16105_FIRST_PAY_LIST_FIELD"].label = 3
()["SC_16105_FIRST_PAY_LIST_FIELD"].has_default_value = false
()["SC_16105_FIRST_PAY_LIST_FIELD"].default_value = {}
()["SC_16105_FIRST_PAY_LIST_FIELD"].type = 13
()["SC_16105_FIRST_PAY_LIST_FIELD"].cpp_type = 3
()["SC_16105_PAY_LIST_FIELD"].name = "pay_list"
()["SC_16105_PAY_LIST_FIELD"].full_name = "p16.sc_16105.pay_list"
()["SC_16105_PAY_LIST_FIELD"].number = 2
()["SC_16105_PAY_LIST_FIELD"].index = 1
()["SC_16105_PAY_LIST_FIELD"].label = 3
()["SC_16105_PAY_LIST_FIELD"].has_default_value = false
()["SC_16105_PAY_LIST_FIELD"].default_value = {}
()["SC_16105_PAY_LIST_FIELD"].message_type = SHOPINFO
()["SC_16105_PAY_LIST_FIELD"].type = 11
()["SC_16105_PAY_LIST_FIELD"].cpp_type = 10
()["SC_16105_NORMAL_LIST_FIELD"].name = "normal_list"
()["SC_16105_NORMAL_LIST_FIELD"].full_name = "p16.sc_16105.normal_list"
()["SC_16105_NORMAL_LIST_FIELD"].number = 3
()["SC_16105_NORMAL_LIST_FIELD"].index = 2
()["SC_16105_NORMAL_LIST_FIELD"].label = 3
()["SC_16105_NORMAL_LIST_FIELD"].has_default_value = false
()["SC_16105_NORMAL_LIST_FIELD"].default_value = {}
()["SC_16105_NORMAL_LIST_FIELD"].message_type = SHOPINFO
()["SC_16105_NORMAL_LIST_FIELD"].type = 11
()["SC_16105_NORMAL_LIST_FIELD"].cpp_type = 10
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].name = "normal_group_list"
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].full_name = "p16.sc_16105.normal_group_list"
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].number = 4
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].index = 3
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].label = 3
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].has_default_value = false
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].default_value = {}
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].message_type = SHOPINFO
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].type = 11
()["SC_16105_NORMAL_GROUP_LIST_FIELD"].cpp_type = 10
SC_16105.name = "sc_16105"
SC_16105.full_name = "p16.sc_16105"
SC_16105.nested_types = {}
SC_16105.enum_types = {}
SC_16105.fields = {
	()["SC_16105_FIRST_PAY_LIST_FIELD"],
	()["SC_16105_PAY_LIST_FIELD"],
	()["SC_16105_NORMAL_LIST_FIELD"],
	()["SC_16105_NORMAL_GROUP_LIST_FIELD"]
}
SC_16105.is_extendable = false
SC_16105.extensions = {}
()["CS_16106_TYPE_FIELD"].name = "type"
()["CS_16106_TYPE_FIELD"].full_name = "p16.cs_16106.type"
()["CS_16106_TYPE_FIELD"].number = 1
()["CS_16106_TYPE_FIELD"].index = 0
()["CS_16106_TYPE_FIELD"].label = 2
()["CS_16106_TYPE_FIELD"].has_default_value = false
()["CS_16106_TYPE_FIELD"].default_value = 0
()["CS_16106_TYPE_FIELD"].type = 13
()["CS_16106_TYPE_FIELD"].cpp_type = 3
CS_16106.name = "cs_16106"
CS_16106.full_name = "p16.cs_16106"
CS_16106.nested_types = {}
CS_16106.enum_types = {}
CS_16106.fields = {
	()["CS_16106_TYPE_FIELD"]
}
CS_16106.is_extendable = false
CS_16106.extensions = {}
()["SC_16107_ITEM_FLASH_TIME_FIELD"].name = "item_flash_time"
()["SC_16107_ITEM_FLASH_TIME_FIELD"].full_name = "p16.sc_16107.item_flash_time"
()["SC_16107_ITEM_FLASH_TIME_FIELD"].number = 1
()["SC_16107_ITEM_FLASH_TIME_FIELD"].index = 0
()["SC_16107_ITEM_FLASH_TIME_FIELD"].label = 2
()["SC_16107_ITEM_FLASH_TIME_FIELD"].has_default_value = false
()["SC_16107_ITEM_FLASH_TIME_FIELD"].default_value = 0
()["SC_16107_ITEM_FLASH_TIME_FIELD"].type = 13
()["SC_16107_ITEM_FLASH_TIME_FIELD"].cpp_type = 3
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].name = "item_shop_id_list"
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].full_name = "p16.sc_16107.item_shop_id_list"
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].number = 2
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].index = 1
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].label = 3
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].has_default_value = false
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].default_value = {}
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].type = 13
()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"].cpp_type = 3
()["SC_16107_ITEM_FETCH_LIST_FIELD"].name = "item_fetch_list"
()["SC_16107_ITEM_FETCH_LIST_FIELD"].full_name = "p16.sc_16107.item_fetch_list"
()["SC_16107_ITEM_FETCH_LIST_FIELD"].number = 3
()["SC_16107_ITEM_FETCH_LIST_FIELD"].index = 2
()["SC_16107_ITEM_FETCH_LIST_FIELD"].label = 3
()["SC_16107_ITEM_FETCH_LIST_FIELD"].has_default_value = false
()["SC_16107_ITEM_FETCH_LIST_FIELD"].default_value = {}
()["SC_16107_ITEM_FETCH_LIST_FIELD"].type = 13
()["SC_16107_ITEM_FETCH_LIST_FIELD"].cpp_type = 3
SC_16107.name = "sc_16107"
SC_16107.full_name = "p16.sc_16107"
SC_16107.nested_types = {}
SC_16107.enum_types = {}
SC_16107.fields = {
	()["SC_16107_ITEM_FLASH_TIME_FIELD"],
	()["SC_16107_ITEM_SHOP_ID_LIST_FIELD"],
	()["SC_16107_ITEM_FETCH_LIST_FIELD"]
}
SC_16107.is_extendable = false
SC_16107.extensions = {}
()["CS_16108_SHOP_ID_FIELD"].name = "shop_id"
()["CS_16108_SHOP_ID_FIELD"].full_name = "p16.cs_16108.shop_id"
()["CS_16108_SHOP_ID_FIELD"].number = 1
()["CS_16108_SHOP_ID_FIELD"].index = 0
()["CS_16108_SHOP_ID_FIELD"].label = 2
()["CS_16108_SHOP_ID_FIELD"].has_default_value = false
()["CS_16108_SHOP_ID_FIELD"].default_value = 0
()["CS_16108_SHOP_ID_FIELD"].type = 13
()["CS_16108_SHOP_ID_FIELD"].cpp_type = 3
()["CS_16108_FLASH_TIME_FIELD"].name = "flash_time"
()["CS_16108_FLASH_TIME_FIELD"].full_name = "p16.cs_16108.flash_time"
()["CS_16108_FLASH_TIME_FIELD"].number = 2
()["CS_16108_FLASH_TIME_FIELD"].index = 1
()["CS_16108_FLASH_TIME_FIELD"].label = 2
()["CS_16108_FLASH_TIME_FIELD"].has_default_value = false
()["CS_16108_FLASH_TIME_FIELD"].default_value = 0
()["CS_16108_FLASH_TIME_FIELD"].type = 13
()["CS_16108_FLASH_TIME_FIELD"].cpp_type = 3
CS_16108.name = "cs_16108"
CS_16108.full_name = "p16.cs_16108"
CS_16108.nested_types = {}
CS_16108.enum_types = {}
CS_16108.fields = {
	()["CS_16108_SHOP_ID_FIELD"],
	()["CS_16108_FLASH_TIME_FIELD"]
}
CS_16108.is_extendable = false
CS_16108.extensions = {}
()["SC_16109_RESULT_FIELD"].name = "result"
()["SC_16109_RESULT_FIELD"].full_name = "p16.sc_16109.result"
()["SC_16109_RESULT_FIELD"].number = 1
()["SC_16109_RESULT_FIELD"].index = 0
()["SC_16109_RESULT_FIELD"].label = 2
()["SC_16109_RESULT_FIELD"].has_default_value = false
()["SC_16109_RESULT_FIELD"].default_value = 0
()["SC_16109_RESULT_FIELD"].type = 13
()["SC_16109_RESULT_FIELD"].cpp_type = 3
SC_16109.name = "sc_16109"
SC_16109.full_name = "p16.sc_16109"
SC_16109.nested_types = {}
SC_16109.enum_types = {}
SC_16109.fields = {
	()["SC_16109_RESULT_FIELD"]
}
SC_16109.is_extendable = false
SC_16109.extensions = {}
()["SC_16200_CORE_SHOP_LIST_FIELD"].name = "core_shop_list"
()["SC_16200_CORE_SHOP_LIST_FIELD"].full_name = "p16.sc_16200.core_shop_list"
()["SC_16200_CORE_SHOP_LIST_FIELD"].number = 1
()["SC_16200_CORE_SHOP_LIST_FIELD"].index = 0
()["SC_16200_CORE_SHOP_LIST_FIELD"].label = 3
()["SC_16200_CORE_SHOP_LIST_FIELD"].has_default_value = false
()["SC_16200_CORE_SHOP_LIST_FIELD"].default_value = {}
()["SC_16200_CORE_SHOP_LIST_FIELD"].message_type = SHOPINFO
()["SC_16200_CORE_SHOP_LIST_FIELD"].type = 11
()["SC_16200_CORE_SHOP_LIST_FIELD"].cpp_type = 10
()["SC_16200_BLUE_SHOP_LIST_FIELD"].name = "blue_shop_list"
()["SC_16200_BLUE_SHOP_LIST_FIELD"].full_name = "p16.sc_16200.blue_shop_list"
()["SC_16200_BLUE_SHOP_LIST_FIELD"].number = 2
()["SC_16200_BLUE_SHOP_LIST_FIELD"].index = 1
()["SC_16200_BLUE_SHOP_LIST_FIELD"].label = 3
()["SC_16200_BLUE_SHOP_LIST_FIELD"].has_default_value = false
()["SC_16200_BLUE_SHOP_LIST_FIELD"].default_value = {}
()["SC_16200_BLUE_SHOP_LIST_FIELD"].message_type = SHOPINFO
()["SC_16200_BLUE_SHOP_LIST_FIELD"].type = 11
()["SC_16200_BLUE_SHOP_LIST_FIELD"].cpp_type = 10
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].name = "normal_shop_list"
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].full_name = "p16.sc_16200.normal_shop_list"
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].number = 3
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].index = 2
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].label = 3
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].has_default_value = false
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].default_value = {}
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].message_type = SHOPINFO
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].type = 11
()["SC_16200_NORMAL_SHOP_LIST_FIELD"].cpp_type = 10
SC_16200.name = "sc_16200"
SC_16200.full_name = "p16.sc_16200"
SC_16200.nested_types = {}
SC_16200.enum_types = {}
SC_16200.fields = {
	()["SC_16200_CORE_SHOP_LIST_FIELD"],
	()["SC_16200_BLUE_SHOP_LIST_FIELD"],
	()["SC_16200_NORMAL_SHOP_LIST_FIELD"]
}
SC_16200.is_extendable = false
SC_16200.extensions = {}
()["CS_16201_TYPE_FIELD"].name = "type"
()["CS_16201_TYPE_FIELD"].full_name = "p16.cs_16201.type"
()["CS_16201_TYPE_FIELD"].number = 1
()["CS_16201_TYPE_FIELD"].index = 0
()["CS_16201_TYPE_FIELD"].label = 2
()["CS_16201_TYPE_FIELD"].has_default_value = false
()["CS_16201_TYPE_FIELD"].default_value = 0
()["CS_16201_TYPE_FIELD"].type = 13
()["CS_16201_TYPE_FIELD"].cpp_type = 3
()["CS_16201_ID_FIELD"].name = "id"
()["CS_16201_ID_FIELD"].full_name = "p16.cs_16201.id"
()["CS_16201_ID_FIELD"].number = 2
()["CS_16201_ID_FIELD"].index = 1
()["CS_16201_ID_FIELD"].label = 2
()["CS_16201_ID_FIELD"].has_default_value = false
()["CS_16201_ID_FIELD"].default_value = 0
()["CS_16201_ID_FIELD"].type = 13
()["CS_16201_ID_FIELD"].cpp_type = 3
()["CS_16201_COUNT_FIELD"].name = "count"
()["CS_16201_COUNT_FIELD"].full_name = "p16.cs_16201.count"
()["CS_16201_COUNT_FIELD"].number = 3
()["CS_16201_COUNT_FIELD"].index = 2
()["CS_16201_COUNT_FIELD"].label = 2
()["CS_16201_COUNT_FIELD"].has_default_value = false
()["CS_16201_COUNT_FIELD"].default_value = 0
()["CS_16201_COUNT_FIELD"].type = 13
()["CS_16201_COUNT_FIELD"].cpp_type = 3
CS_16201.name = "cs_16201"
CS_16201.full_name = "p16.cs_16201"
CS_16201.nested_types = {}
CS_16201.enum_types = {}
CS_16201.fields = {
	()["CS_16201_TYPE_FIELD"],
	()["CS_16201_ID_FIELD"],
	()["CS_16201_COUNT_FIELD"]
}
CS_16201.is_extendable = false
CS_16201.extensions = {}
()["SC_16202_RESULT_FIELD"].name = "result"
()["SC_16202_RESULT_FIELD"].full_name = "p16.sc_16202.result"
()["SC_16202_RESULT_FIELD"].number = 1
()["SC_16202_RESULT_FIELD"].index = 0
()["SC_16202_RESULT_FIELD"].label = 2
()["SC_16202_RESULT_FIELD"].has_default_value = false
()["SC_16202_RESULT_FIELD"].default_value = 0
()["SC_16202_RESULT_FIELD"].type = 13
()["SC_16202_RESULT_FIELD"].cpp_type = 3
()["SC_16202_DROP_LIST_FIELD"].name = "drop_list"
()["SC_16202_DROP_LIST_FIELD"].full_name = "p16.sc_16202.drop_list"
()["SC_16202_DROP_LIST_FIELD"].number = 2
()["SC_16202_DROP_LIST_FIELD"].index = 1
()["SC_16202_DROP_LIST_FIELD"].label = 3
()["SC_16202_DROP_LIST_FIELD"].has_default_value = false
()["SC_16202_DROP_LIST_FIELD"].default_value = {}
()["SC_16202_DROP_LIST_FIELD"].message_type = slot1.DROPINFO
()["SC_16202_DROP_LIST_FIELD"].type = 11
()["SC_16202_DROP_LIST_FIELD"].cpp_type = 10
SC_16202.name = "sc_16202"
SC_16202.full_name = "p16.sc_16202"
SC_16202.nested_types = {}
SC_16202.enum_types = {}
SC_16202.fields = {
	()["SC_16202_RESULT_FIELD"],
	()["SC_16202_DROP_LIST_FIELD"]
}
SC_16202.is_extendable = false
SC_16202.extensions = {}
()["SHOPINFO_SHOP_ID_FIELD"].name = "shop_id"
()["SHOPINFO_SHOP_ID_FIELD"].full_name = "p16.shopinfo.shop_id"
()["SHOPINFO_SHOP_ID_FIELD"].number = 1
()["SHOPINFO_SHOP_ID_FIELD"].index = 0
()["SHOPINFO_SHOP_ID_FIELD"].label = 2
()["SHOPINFO_SHOP_ID_FIELD"].has_default_value = false
()["SHOPINFO_SHOP_ID_FIELD"].default_value = 0
()["SHOPINFO_SHOP_ID_FIELD"].type = 13
()["SHOPINFO_SHOP_ID_FIELD"].cpp_type = 3
()["SHOPINFO_PAY_COUNT_FIELD"].name = "pay_count"
()["SHOPINFO_PAY_COUNT_FIELD"].full_name = "p16.shopinfo.pay_count"
()["SHOPINFO_PAY_COUNT_FIELD"].number = 2
()["SHOPINFO_PAY_COUNT_FIELD"].index = 1
()["SHOPINFO_PAY_COUNT_FIELD"].label = 2
()["SHOPINFO_PAY_COUNT_FIELD"].has_default_value = false
()["SHOPINFO_PAY_COUNT_FIELD"].default_value = 0
()["SHOPINFO_PAY_COUNT_FIELD"].type = 13
()["SHOPINFO_PAY_COUNT_FIELD"].cpp_type = 3
SHOPINFO.name = "shopinfo"
SHOPINFO.full_name = "p16.shopinfo"
SHOPINFO.nested_types = {}
SHOPINFO.enum_types = {}
SHOPINFO.fields = {
	()["SHOPINFO_SHOP_ID_FIELD"],
	()["SHOPINFO_PAY_COUNT_FIELD"]
}
SHOPINFO.is_extendable = false
SHOPINFO.extensions = {}
cs_16001 = slot0.Message(CS_16001)
cs_16100 = slot0.Message(CS_16100)
cs_16102 = slot0.Message(CS_16102)
cs_16104 = slot0.Message(CS_16104)
cs_16106 = slot0.Message(CS_16106)
cs_16108 = slot0.Message(CS_16108)
cs_16201 = slot0.Message(CS_16201)
sc_16002 = slot0.Message(SC_16002)
sc_16101 = slot0.Message(SC_16101)
sc_16103 = slot0.Message(SC_16103)
sc_16105 = slot0.Message(SC_16105)
sc_16107 = slot0.Message(SC_16107)
sc_16109 = slot0.Message(SC_16109)
sc_16200 = slot0.Message(SC_16200)
sc_16202 = slot0.Message(SC_16202)
shopinfo = slot0.Message(SHOPINFO)

return
