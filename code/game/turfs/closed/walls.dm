#define MAX_DENT_DECALS 15

/turf/closed/wall
	name = "wall"
	desc = "A wall."
	icon = 'icons/turf/walls/baywall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	explosion_block = 1
	baseturfs = /turf/open/genturf

	flags_ricochet = RICOCHET_HARD

	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDERS
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_MINERAL_WALLS, SMOOTH_GROUP_MINERAL_DOOR)

	///lower numbers are harder. Used to determine the probability of a hulk smashing through.
	hardness = 40
	var/slicing_duration = 100  //default time taken to slice the wall
	var/atom/sheet_type
	var/sheet_amount = 2

	var/list/dent_decals

	/// a list of tool behaviors and respective time how long will it take to mine src with said tool
	var/list/digging_tools = null


/turf/closed/wall/Initialize(mapload)
	. = ..()
	if(smoothing_flags & SMOOTH_DIAGONAL_CORNERS && fixed_underlay) //Set underlays for the diagonal walls.
		var/mutable_appearance/underlay_appearance = mutable_appearance(layer = TURF_LAYER, plane = FLOOR_PLANE)
		underlay_appearance.icon = fixed_underlay["icon"]
		underlay_appearance.icon_state = fixed_underlay["icon_state"]
		fixed_underlay = string_assoc_list(fixed_underlay)
		underlays += underlay_appearance

/turf/closed/wall/examine(mob/user)
	. += ..()
	. += "<hr>"
	// . += deconstruction_hints(user)

/turf/closed/wall/proc/deconstruction_hints(mob/user)
	return span_notice("The outer plating is <b>welded</b> firmly in place.</b>.")

/turf/closed/wall/proc/dismantle_wall(devastated=0, explode=0)
	if(devastated)
		devastate_wall()
	else
		playsound(src, 'sound/items/welder.ogg', 100, TRUE)
		var/newgirder = break_wall()
		if(newgirder) //maybe we don't /want/ a girder!
			transfer_fingerprints_to(newgirder)

	ScrapeAway()

/turf/closed/wall/proc/break_wall()
	var/obj/O = new sheet_type(src, sheet_amount)
	O.apply_material(initial(sheet_type.materials))

/turf/closed/wall/proc/devastate_wall()
	var/obj/O = new sheet_type(src, sheet_amount)
	O.apply_material(initial(sheet_type.materials))

/turf/closed/wall/ex_act(severity, target, prikolist)
	if(target == src)
		dismantle_wall(1,1)
		return
	switch(severity)
		if(1)
			//SN src = null
			var/turf/NT = ScrapeAway()
			NT.contents_explosion(severity, target)
			return
		if(2)
			if (prob(50))
				dismantle_wall(0,1)
			else
				dismantle_wall(1,1)
		if(3)
			if (prob(hardness))
				dismantle_wall(0,1)
	if(!density)
		..()

/turf/closed/wall/attack_paw(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	return attack_hand(user)


/turf/closed/wall/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if((M.environment_smash & ENVIRONMENT_SMASH_WALLS) || (M.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
		dismantle_wall(1)
		return

/turf/closed/wall/attackby(obj/item/C, mob/user, params)
	if(digging_tools && (C.tool_behaviour in digging_tools))
		try_mine(C, user)
		return
	. = ..()

/turf/closed/wall/proc/try_mine(obj/item/I, mob/user)
	var/dig_time = digging_tools[I.tool_behaviour]
	to_chat(user, span_notice("You start mining [src]..."))
	if(I.use_tool(src, user, dig_time, volume=50))
		mine(user)

/turf/closed/wall/proc/mine(mob/user)
	ScrapeAway()

/turf/closed/wall/proc/try_clean(obj/item/W, mob/user, turf/T)
	if((user.a_intent != INTENT_HELP) || !LAZYLEN(dent_decals))
		return FALSE

	return FALSE

/turf/closed/proc/try_wallmount(obj/item/W, mob/user)
	//Poster stuff
	if(istype(W, /obj/item/sconce))
		var/obj/item/sconce/F = W
		if(F.try_build(src, user))
			F.attach(src, user)
		return TRUE
	return FALSE

/turf/closed/wall/proc/try_decon(obj/item/I, mob/user, turf/T)
	return FALSE

/turf/closed/wall/get_dumping_location(obj/item/storage/source, mob/user)
	return null

/turf/closed/wall/acid_act(acidpwr, acid_volume)
	if(explosion_block >= 2)
		acidpwr = min(acidpwr, 50) //we reduce the power so strong walls never get melted.
	return ..()

/turf/closed/wall/acid_melt()
	dismantle_wall(1)

/turf/closed/wall/proc/add_dent(denttype, x=rand(-8, 8), y=rand(-8, 8))
	if(LAZYLEN(dent_decals) >= MAX_DENT_DECALS)
		return

	var/mutable_appearance/decal = mutable_appearance('icons/effects/effects.dmi', "", BULLET_HOLE_LAYER)
	switch(denttype)
		if(WALL_DENT_SHOT)
			decal.icon_state = "bullet_hole"
		if(WALL_DENT_HIT)
			decal.icon_state = "impact[rand(1, 3)]"

	decal.pixel_x = x
	decal.pixel_y = y

	if(LAZYLEN(dent_decals))
		cut_overlay(dent_decals)
		dent_decals += decal
	else
		dent_decals = list(decal)

	add_overlay(dent_decals)

#undef MAX_DENT_DECALS
