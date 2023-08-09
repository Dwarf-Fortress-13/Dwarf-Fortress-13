/turf/closed/wall/stone
	name = "stone wall"
	desc = "Just a regular stone wall."
	icon = 'dwarfs/icons/turf/walls_dwarven.dmi'
	icon_state = "rich_wall-0"
	base_icon_state = "rich_wall"
	sheet_type = /obj/item/stack/sheet/stone
	baseturfs = /turf/open/floor/tiles
	sheet_amount = 3

/turf/closed/mineral/stone/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_CHISEL)
		var/turf/T = src
		var/time = 5 SECONDS * user.get_skill_modifier(/datum/skill/masonry, SKILL_SPEED_MODIFIER)
		to_chat(user, span_notice("You start carving stone wall..."))
		if(I.use_tool(src, user, time, volume=50))
			to_chat(user, span_notice("You finish carving stone wall."))
			user.adjust_experience(/datum/skill/masonry, rand(2,6))
			var/turf/wall = T.PlaceOnTop(/turf/closed/wall/stone)
			wall.apply_material(materials)
	else
		. = ..()

/turf/closed/mineral/stone/gets_drilled(mob/user, give_exp)
	. = ..()
	if(prob(40))
		for(var/i in 1 to rand(1, 4))
			new /obj/item/stack/ore/stone(src)

	if(prob(SSevents.troll_spawn_change))
		to_chat(user, span_userdanger("THIS ROCK APPEARS TO BE ESPECIALLY SOFT!"))
		new /mob/living/simple_animal/hostile/troll(src)

/turf/closed/mineral/sand
	name = "sand"
	baseturfs = /turf/open/floor/sand
	smooth_icon = 'dwarfs/icons/turf/walls_sandstone.dmi'
	base_icon_state = "rockwall"
	icon = 'dwarfs/icons/turf/walls_sandstone.dmi'
	icon_state = "rockwall-0"
	materials = /datum/material/sandstone

/turf/closed/mineral/sand/gets_drilled(user, give_exp)
	. = ..()
	if(prob(33))
		new /obj/item/stack/ore/smeltable/sand(src)

/turf/closed/wall/wooden
	name = "wooden wall"
	icon = 'dwarfs/icons/turf/walls_wooden.dmi'
	base_icon_state = "wooden_wall"
	icon_state = "wooden_wall-0"
	baseturfs = /turf/open/floor/wooden
	hardness = 60
	sheet_type = /obj/item/stack/sheet/planks

/turf/closed/wall/wooden/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/turf/closed/wall/sand
	name = "sand wall"
	icon = 'dwarfs/icons/turf/walls_sand.dmi'
	base_icon_state = "sand_wall"
	icon_state = "sand_wall-0"
	baseturfs = /turf/open/floor/bigtiles
	sheet_type = /obj/item/stack/ore/smeltable/sand
