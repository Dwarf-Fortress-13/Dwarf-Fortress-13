/obj/structure/smelter
	name = "smelter"
	desc = "Smelts that precious mineral you mined into useful ingot."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "smelter"
	density = TRUE
	anchored = TRUE
	light_range = 3
	light_color = "#BB661E"
	materials = /datum/material/stone
	particles = new/particles/smoke/smelter
	var/working = FALSE
	var/fuel = 0
	var/fuel_consumption = 0.5
	var/smelting_time = 30 SECONDS
	var/max_items = 5
	var/timerid

/obj/structure/smelter/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	set_light_on(working)
	update_light()

/obj/structure/smelter/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/smelter/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/structure/smelter/examine(mob/user)
	. = ..()
	if(contents.len)
		. += "<br>\The [src] is smelting \a [contents[1]]."
	else
		. += "<br>\The [src] is empty!"

/obj/structure/smelter/update_icon_state()
	. = ..()
	if(working)
		icon_state = "smelter_working"
	else if(fuel)
		icon_state = "smelter_fueled"
	else
		icon_state = "smelter"

/obj/structure/smelter/proc/smelted_thing()
	var/obj/item/I = contents[1]
	I.forceMove(get_turf(src))
	if(contents.len)
		start_smelting()

/obj/structure/smelter/proc/start_smelting()
	timerid = addtimer(CALLBACK(src, PROC_REF(smelted_thing)), smelting_time, TIMER_STOPPABLE)

/obj/structure/smelter/proc/remove_timer()
	if(active_timers)
		deltimer(timerid)

/obj/structure/smelter/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/stack/ore/smeltable))
		var/obj/item/stack/ore/smeltable/S = I
		if(contents.len == max_items)
			to_chat(user, span_warning("[src] is full!"))
			return
		if(!S.use(5))
			to_chat(user, span_warning("You need at least 5 pieces."))
			return
		to_chat(user, span_notice("You place [S] into [src]."))
		if(working && !contents.len)
			start_smelting()
		var/obj/O = new S.refined_type(src)
		if(S.materials)
			O.apply_material(S.materials)
		O.update_stats()
	else if(I.get_temperature())
		if(!fuel)
			to_chat(user, span_warning("[src] has no fuel."))
			return
		if(working)
			to_chat(user, span_warning("[src] is already lit."))
			return
		set_light_on(TRUE)
		update_light()
		to_chat(user, span_notice("You light up [src]."))
		playsound(src, 'dwarfs/sounds/effects/ignite.ogg', 50, TRUE)
		working = TRUE
		particles.spawning = 0.3
		if(contents.len)
			start_smelting()
		update_appearance()
	else if(I.get_fuel())
		fuel += I.get_fuel()
		qdel(I)
		user.visible_message(span_notice("[user] throws [I] into [src]."), span_notice("You throw [I] into [src]."))
		update_appearance()
	else
		. = ..()

/obj/structure/smelter/process(delta_time)
	if(!working)
		return
	if(prob(20))
		playsound(src, 'dwarfs/sounds/effects/fire_cracking_short.ogg', 100, TRUE)
	if(!fuel)
		working = FALSE
		set_light_on(FALSE)
		update_light()
		update_appearance()
		remove_timer()
		particles.spawning = 0
		return
	fuel = max(fuel-fuel_consumption, 0)
