/obj/effect/temp_visual/point
	name = "pointer"
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "arrow"
	plane = POINT_PLANE
	duration = 25

/obj/effect/temp_visual/point/Initialize(mapload, set_invis = 0)
	. = ..()
	var/atom/old_loc = loc
	abstract_move(get_turf(src))
	pixel_x = old_loc.pixel_x
	pixel_y = old_loc.pixel_y
	invisibility = set_invis
