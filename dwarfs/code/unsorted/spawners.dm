/obj/effect/spawner/smithy

/obj/effect/spawner/smithy/Initialize(mapload)
	. = ..()
	var/turf/center = get_turf(src)
	var/turf/left = locate(center.x-1, center.y, center.z)
	var/turf/right = locate(center.x+1, center.y, center.z)
	var/turf/down = locate(center.x, center.y-1, center.z)
	new /obj/structure/anvil(center)
	left.PlaceOnTop(/turf/open/lava)
	right.PlaceOnTop(/turf/open/water)
	new /obj/item/smithing_hammer(down)
	new /obj/item/tongs(down)
	new /obj/item/ingot(down)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/metal_showcase/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	var/list/armor = list(
		/obj/item/clothing/suit/heavy_plate,
		/obj/item/clothing/shoes/plate_boots,
		/obj/item/clothing/under/chainmail,
		/obj/item/clothing/gloves/plate_gloves,
		/obj/item/clothing/head/heavy_plate
	)
	for(var/material_type in subtypesof(/datum/material))
		var/datum/material/M = get_material(material_type)
		if(M && M.mat == MATERIAL_METAL)
			var/turf/U = get_step(T, NORTH)
			var/turf/D = get_step(T, SOUTH)
			var/mob/living/carbon/human/dwarf = new/mob/living/carbon/human/species/dwarf(U)
			dwarf.equipOutfit(/datum/outfit)
			for(var/item_path in armor)
				var/obj/O = new item_path(T)
				O.apply_material(material_type)
				dwarf.equip_to_appropriate_slot(O)
			var/obj/I = new/obj/item/ingot(T)
			I.apply_material(material_type)
			if(M.resource)
				new M.resource(D)
			T = get_step(T, EAST)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/alloy_smelter/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	var/turf/D = get_step(T, SOUTH)
	new/obj/structure/alloy_smelter(T)
	new/obj/item/ingot(D)
	var/obj/copper = new/obj/item/ingot(D)
	copper.apply_material(/datum/material/copper)
	var/obj/tin = new/obj/item/ingot(D)
	tin.apply_material(/datum/material/tin)
	new/obj/item/stack/ore/coal(D, 50)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/crafters/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	var/turf/D = get_step(T, SOUTH)
	var/turf/R = locate(T.x+2, T.y, T.z)
	new/obj/structure/crafter/carpenter_table(T)
	new/obj/structure/crafter/workbench(R)
	new/obj/item/stack/sheet/planks(D, 20)
	var/obj/P = new/obj/item/partial/pickaxe(D)
	P.apply_material(/datum/material/steel)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/wood_showcase/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	for(var/material_type in subtypesof(/datum/material/wood))
		var/datum/material/wood/M = get_material(material_type)
		if(M.resource && M.palettes.len == 1)
			continue
		var/turf/R = get_step(T, EAST)
		var/turf/W = get_step(T, SOUTH)
		var/obj/S
		if(M.palettes.len == 2)
			S = new/obj/item/log(T)
			S.apply_material(material_type)
			S = new/obj/item/log/large(R)
			S.apply_material(material_type)
		for(var/wtype in subtypesof(/obj/structure/crafter))
			S = new wtype(W)
			S.apply_material(list(PART_INGOT=/datum/material/iron, PART_PLANKS=M.treated_type ? M.treated_type : material_type))
			W = get_step(W, SOUTH)
		S = new/obj/structure/closet/crate/wooden(W)
		S.apply_material(list(PART_INGOT=/datum/material/iron, PART_PLANKS=M.treated_type ? M.treated_type : material_type))
		S = new/obj/item/stack/sheet/planks(get_step(W, EAST))
		S.apply_material(M.treated_type ? M.treated_type : material_type)
		T = locate(T.x+2, T.y, T.z)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/kitchen/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	var/turf/S = get_step(T, NORTH)
	var/list/stations = list(/obj/structure/oven,/obj/structure/stove,/obj/structure/brewery/spawner)
	var/list/tools = list(/obj/item/kitchen/knife, /obj/item/kitchen/rollingpin, /obj/item/reagent_containers/glass/baking_sheet,/obj/item/reagent_containers/glass/pan,/obj/item/reagent_containers/glass/cake_pan,/obj/item/reagent_containers/glass/plate/bowl,/obj/item/reagent_containers/glass/plate/flat,/obj/item/reagent_containers/glass/plate/regular)
	for(var/stype in stations)
		new stype(S)
		S = get_step(S, EAST)
	for(var/ttype in tools)
		new ttype(T)
	T = get_step(T, SOUTH)
	for(var/gtype in subtypesof(/obj/item/growable)-typesof(/obj/item/growable/seeds))
		for(var/i in 1 to 5)
			new gtype(T)
	return INITIALIZE_HINT_QDEL
