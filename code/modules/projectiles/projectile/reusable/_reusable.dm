/obj/projectile/bullet/reusable
	name = "reusable bullet"
	desc = "How do you even reuse a bullet?"
	impact_effect_type = null
	embedding = null
	shrapnel_type = null
	var/ammo_type = /obj/item/ammo_casing/caseless
	var/dropped = FALSE

/obj/projectile/bullet/reusable/on_hit(atom/target, blocked = FALSE)
	. = ..()
	handle_drop()

/obj/projectile/bullet/reusable/on_range()
	handle_drop()
	..()

/obj/projectile/bullet/reusable/proc/handle_drop()
	if(!dropped)
		var/turf/T = get_turf(src)
		if(iswallturf(T))
			for(var/turf/W in locs) // try to find non wall turfs to drop in
				if(!iswallturf(W))
					T = W
					break
		var/obj/A = new ammo_type(T)
		A.apply_material(materials)
		A.update_stats(grade)
		dropped = TRUE
