
sceneControl = { x = -244.5149230957, y = 214.16836547852, z = 92.086631774902, h = 90.941024780273}

interiorID = 0

showPrint = false



if not IsDuplicityVersion() then --(Client Side)
	interiorID =  GetInteriorAtCoords(-257.04330444336,216.21157836914,91.889678955078)
	if showPrint then
		print("interiorID : "..tostring(interiorID))
	end
end

entitySet = {
	["jeu1"] = {name = "Talk Show"},
	["jeu2"] = {name = "Quizz"},
	["jeu3"] = {name = "Stand Up"},
	["jeu4"] = {name = "Gouvernement"},
	["jeu5"] = {name = "Music"},
	["jeu6"] = {name = "Weazel"},
	["jeu7"] = {name = "MMA"},
	["jeu8"] = {name = "TalkToYou"},
	["jeu9"] = {name = "Talent"},
	["jeu10"] = {name = "Big Quizz"}
}

Animation = {dict="friends@fra@ig_1", anim="over_here_idle_a"}

Quizz = {
	["MasterBuzz"] = {
		coords = { x = -256.58120727539, y = 214.08918762207, z = 92.057395935059, h = 39.836688995361},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge4",
		textureVariation2 = "buzzervert4",
		textureSlot = "buzzeractuel4",
	},
	
	["buzz1"] = {
		coords = { x = -260.02914428711, y = 212.49822998047, z = 92.057395935059, h = 309.86529541016},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge1",
		textureVariation2 = "buzzervert1",
		textureSlot = "buzzeractuel1",
	},
	["buzz2"] = {
		coords = { x = -260.91989135742, y = 213.36994934082, z = 92.057395935059, h = 313.39447021484},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge2",
		textureVariation2 = "buzzervert2",
		textureSlot = "buzzeractuel2",
	},
	["buzz3"] = {
		coords = { x = -261.69100952148, y = 214.24423217773, z = 92.057395935059, h = 305.81628417969},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge3",
		textureVariation2 = "buzzervert3",
		textureSlot = "buzzeractuel3",
	},
	["buzz4"] = {
		coords = { x = -262.57553100586, y = 215.0906829834,z = 92.057395935059,h = 307.74066162109},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge4",
		textureVariation2 = "buzzervert4",
		textureSlot = "buzzeractuel4",
	},
}

Quizz2 = {
	["MasterBuzz"] = {
		coords = { x = -256.58120727539, y = 214.08918762207, z = 92.057395935059, h = 39.836688995361},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge4",
		textureVariation2 = "buzzervert4",
		textureSlot = "buzzeractuel4",
	},
	
	["buzz1"] = {
		coords = { x = -259.69854736328, y = 211.29299926758, z = 92.079132080078, h = 302.20388793945},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge1",
		textureVariation2 = "buzzervert1",
		textureSlot = "buzzeractuel1",
	},
	["buzz2"] = {
		coords = { x = -260.41348266602, y = 212.33827209473, z = 92.079132080078, h = 301.7995300293},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge2",
		textureVariation2 = "buzzervert2",
		textureSlot = "buzzeractuel2",
	},
	["buzz3"] = {
		coords = { x = -261.13836669922, y = 213.3796081543, z = 92.079132080078, h = 302.95327758789},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge3",
		textureVariation2 = "buzzervert3",
		textureSlot = "buzzeractuel3",
	},
	["buzz4"] = {
		coords = { x = -261.85028076172, y = 214.47242736816,z = 92.079132080078,h = 301.13247680664},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge4",
		textureVariation2 = "buzzervert4",
		textureSlot = "buzzeractuel4",
	},
	["buzz5"] = {
		coords = { x = -262.53317260742, y = 215.51406860352,z = 92.079132080078,h = 301.04290771484},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge5",
		textureVariation2 = "buzzervert5",
		textureSlot = "buzzeractuel5",
	},
	["buzz6"] = {
		coords = { x = -261.13287353516, y = 211.14859008789,z = 92.319351196289,h = 296.70172119141},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge6",
		textureVariation2 = "buzzervert6",
		textureSlot = "buzzeractuel6",
	},
	["buzz7"] = {
		coords = { x = -261.89526367188, y = 212.13771057129,z = 92.319351196289,h = 299.853515625},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge7",
		textureVariation2 = "buzzervert7",
		textureSlot = "buzzeractuel7",
	},
	["buzz8"] = {
		coords = { x = -262.48733520508, y = 213.1934967041,z = 92.079132080078,h = 307.41189575195},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge8",
		textureVariation2 = "buzzervert8",
		textureSlot = "buzzeractuel8",
	},
	["buzz9"] = {
		coords = { x = -263.23776245117, y = 214.29383850098,z = 92.079132080078,h = 304.71621704102},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge9",
		textureVariation2 = "buzzervert9",
		textureSlot = "buzzeractuel9",
	},
	["buzz10"] = {
		coords = { x = -261.6008605957, y = 209.85580444336,z = 92.559593200684,h = 308.32135009766},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge10",
		textureVariation2 = "buzzervert10",
		textureSlot = "buzzeractuel10",
	},
	["buzz11"] = {
		coords = { x = -262.43273925781, y = 211.07948303223,z = 92.559593200684,h = 302.05151367188},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge11",
		textureVariation2 = "buzzervert11",
		textureSlot = "buzzeractuel11",
	},
	["buzz12"] = {
		coords = { x = -263.07513427734, y = 212.05271911621,z = 92.559669494629,h = 304.30322265625},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge12",
		textureVariation2 = "buzzervert12",
		textureSlot = "buzzeractuel12",
	},
	["buzz13"] = {
		coords = { x = -263.82669067383, y = 213.13446044922,z = 92.559669494629,h = 303.78552246094},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge13",
		textureVariation2 = "buzzervert13",
		textureSlot = "buzzeractuel13",
	},
	["buzz14"] = {
		coords = { x = -264.52493286133, y = 214.19100952148,z = 92.559669494629,h = 302.21603393555},
		textureDict = "buzzertexture",
		textureVariation1 = "buzzerrouge14",
		textureVariation2 = "buzzervert14",
		textureSlot = "buzzeractuel14",
	},
}

Talent = {
	["Reset"] = {
		coords = { x = -252.97052001953, y = 220.40798950195, z = 92.087142944336, h = 136.87577819824 },
		textureDict = "buzzertexture",
		textureVariation1 = "talentbuzzervert1",
		textureVariation2 = "talentbuzzerrouge1",
		textureSlot = "buzzertalentactuel1",
	},
	["buzz1"] = {
		coords = { x = -256.90673828125, y = 220.3645324707, z = 91.974891662598, h = 175.35293579102 },
		textureDict = "buzzertexture",
		textureVariation1 = "talentbuzzervert1",
		textureVariation2 = "talentbuzzerrouge1",
		textureSlot = "talentbuzzervert1",
	},
	["buzz2"] = {
		coords = { x = -258.57266235352, y = 220.25704956055, z = 91.974891662598, h = 185.5403137207 },
		textureDict = "buzzertexture",
		textureVariation1 = "talentbuzzervert1",
		textureVariation2 = "talentbuzzerrouge1",
		textureSlot = "talentbuzzervert2",
	},
	["buzz3"] = {
		coords = { x = -260.43688964844, y = 220.32751464844, z = 91.974891662598, h = 176.31385803223 },
		textureDict = "buzzertexture",
		textureVariation1 = "talentbuzzervert1",
		textureVariation2 = "talentbuzzerrouge1",
		textureSlot = "talentbuzzervert3",
	},
}
