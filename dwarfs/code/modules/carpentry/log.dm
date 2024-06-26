/obj/item/log
	name = "log"
	desc = "Wooden tree trunk requiring heavy labor."
	icon = 'dwarfs/icons/items/components.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "log"
	throw_range = 0
	w_class = WEIGHT_CLASS_BULKY

/obj/item/log/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/log/get_fuel()
	return 50 // 5 planks

/obj/item/log/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	pixel_x += rand(-8,8)
	pixel_y += rand(-8,8)

/obj/item/log/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_AXE)
		to_chat(user, span_notice("You start cutting [src] into planks..."))
		if(!I.use_tool(src, user, 10 SECONDS, volume=50, used_skill=/datum/skill/logging))
			return
		var/my_turf = get_turf(src)
		user.adjust_experience(/datum/skill/logging, 12)
		var/plank_amt = rand(4, 6)
		var/obj/item/stack/sheet/planks/planks = new (my_turf, plank_amt)
		var/obj/item/stack/sheet/bark/bark = new (my_turf, rand(1, 2))
		var/datum/material/wood/W = get_material(materials)
		planks.apply_material(W.treated_type)
		bark.apply_material(materials)
		qdel(src)
	else
		return ..()

/obj/item/log/large
	name = "large log"
	desc = "Huge, wooden tree trunk requiring very heavy labor."
	icon_state = "log_large"
	density = 1
	w_class = WEIGHT_CLASS_GIGANTIC
	var/small_log_type = /obj/item/log

/obj/item/log/large/get_fuel()
	return 3 * 50 // 3 logs each 5 planks

/obj/item/log/large/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	pixel_x = rand(-3,3)
	pixel_y = rand(-3,3)

/obj/item/log/large/pickup(mob/user)
	to_chat(user, span_notice("You start lifting [src]..."))
	if(!do_after(user, 2 SECONDS, src))
		return FALSE
	. = ..()

/obj/item/log/large/dropped(mob/user, silent)
	. = ..()
	dir = user.dir

/obj/item/log/large/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_AXE)
		to_chat(user, span_notice("You start cutting [src] into pieces..."))
		if(!I.use_tool(src, user, 10 SECONDS, volume=50, used_skill=/datum/skill/logging))
			return
		var/my_turf = get_turf(src)
		user.adjust_experience(/datum/skill/logging, 12)
		for(var/i in 1 to 3)
			var/obj/O = new small_log_type(my_turf)
			O.apply_material(materials)
		qdel(src)
	else
		return ..()
