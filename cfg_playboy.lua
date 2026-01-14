cfg = {}

cfg.ipl = {
	["qnx_pb_int_3"] = {
		enable = true,
		ymap = "qnx_pb_int_3_milo_",
		name = "qnx_pb_int_3",
		coords = vector3(-1534.742,83.44898,57.83928),
		color = false,
		colorSet = 1,
		ipls = {
			["warehouse_empty"] = false, -- empty ( Changing only in 1 room )
			["warehouse_meduim"] = false, -- medium
			["warehouse_full"] = true, -- Full room warehouse in garage

		}
	},

	["qnx_pb_int_1"] = {
		enable = true,
		ymap = "qnx_pb_int_1_milo_",
		name = "qnx_pb_int_1",
		coords = vector3(-1527.524,107.2302,48.81472),
		color = false,
		colorSet = 1,
		ipls = {
			["Under_Ipl_Base"] = true, -- Base, shoould on with IPL weed ( full or half )
			["doors_open_1"] = true, -- Shoud chose open door, if u need all under ( 1 and 2 doors )
			["doors_open_2"] = true,
			["doors_closed_2"] = false, -- Closed door - woorking with 1-2
			["doors_closed_1"] = false,
			["full_ipl_under_drugs"] = true, -- Correct working with base
			["easy_ipl_under_weed"] = true, -- Light version weed
			["meduim_ipl_under_weed"] = false, -- Hard version weed
			["under_lab_meth_qnx"] = false, -- Turn on if u need meth lab in Under
			["full_pb_cocaine"] = false, -- Correct working with under_lab_meth_qnx
			["ipl_r3_meth_and_human"] = false, -- Meth creator in addon room
			["ipl_r3_weapon_storage"] = true, -- Weapon Storage in addon room
			["weapon_room_ipl"] = true, -- Weapon Room

		}
	},
	["qnx_pb_int_4"] = {
		enable = true,
		ymap = "qnx_pb_int_4_milo_",
		name = "qnx_pb_int_4",
		coords = vector3(-1524.108,107.7025,56.06447),
		color = false,
		colorSet = 1,
		ipls = {
			["ipl_r1"] = true, -- Turn to false if u need empty rooms
			["ipl_r2"] = true,
			["ipl_r3"] = true,
			["ipl_r4"] = true,
			["ipl_r5"] = true,
			["ipl_r6"] = true,
			["ipl_r7"] = true,
			["ipl_r8"] = true,
			["ipl_r9"] = true,
			["ipl_r10"] = true,
			["ipl_r11"] = true,
			["ipl_r12"] = true,

		}
	},
	["qnx_pb_int_5"] = {
		enable = true,
		ymap = "qnx_pb_int_5_milo_",
		name = "qnx_pb_int_5",
		coords = vector3(-1520.722,132.8905,58.25869),
		color = false,
		colorSet = 1,
		ipls = {
			["ipl_b2_r1"] = true, -- Turn to false if u need empty rooms
			["ipl_b2_r2"] = true,
			["ipl_b2_r3"] = true,
			["ipl_b2_r4"] = true,
			["ipl_b2_r6"] = true,
			["ipl_b2_r7"] = true,
			["ipl_b2_r8"] = true,
		}
	},
}

