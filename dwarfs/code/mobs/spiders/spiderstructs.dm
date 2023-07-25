/obj/structure/spider
	name = "web"
	icon = 'dwarfs/icons/structures/spider.dmi'
	desc = "It's stringy and sticky."
	anchored = TRUE
	density = FALSE
	max_integrity = 15
	var/datum/callback/web_sensed
	var/datum/callback/web_unsensed

/obj/structure/spider/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(damage_type == BURN)//the stickiness of the web mutes all attack sounds except fire damage type
		playsound(loc, 'sound/items/welder.ogg', 100, 1)

/obj/structure/spider/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == "melee")
		switch(damage_type)
			if(BURN)
				damage_amount *= 2
			if(BRUTE)
				damage_amount *= 0.25
	. = ..()

/obj/structure/spider/stickyweb
	icon_state = "stickyweb1"

/obj/structure/spider/stickyweb/Initialize(mapload)
	. = ..()
	icon_state = "stickyweb[rand(1,2)]"

/obj/structure/spider/stickyweb/Destroy()
	. = ..()
	UnregisterSignal(get_turf(src),COMSIG_ATOM_ENTERED)
	UnregisterSignal(get_turf(src),COMSIG_ATOM_EXITED)

/obj/structure/spider/stickyweb/proc/register_spider(enter_callback,leave_callback)
	web_sensed = enter_callback
	web_unsensed = leave_callback
	RegisterSignal(get_turf(src), COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	RegisterSignal(get_turf(src), COMSIG_ATOM_EXITED, PROC_REF(on_exited))

/obj/structure/spider/stickyweb/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(web_sensed)
		web_sensed.InvokeAsync(arrived)

/obj/structure/spider/stickyweb/proc/on_exited(atom/movable/source, atom/movable/gone, direction)
	SIGNAL_HANDLER
	if(web_unsensed && !locate(/obj/structure/spider/stickyweb) in get_step(src,direction))
		web_unsensed.InvokeAsync(gone)

/obj/structure/spider/stickyweb/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover, /mob/living/simple_animal/hostile/giant_spider))
		return TRUE
	else if(isliving(mover))
		if(istype(mover.pulledby, /mob/living/simple_animal/hostile/giant_spider))
			return TRUE
		if(prob(50))
			to_chat(mover, "<span class='danger'>You get stuck in \the [src] for a moment.</span>")
			return FALSE

/obj/structure/spider/stickyweb/attack_hand(mob/user)
	to_chat(user, span_notice("You start collecting [src]..."))
	if(!do_after(user, 5 SECONDS, src))
		return
	to_chat(user, span_notice("You collect some webs."))
	var/obj/item/stack/sheet/string/string = new(get_turf(src), rand(1, 3))
	string.apply_material(/datum/material/cloth/silk)
	qdel(src)

/obj/structure/spider/cocoon
	name = "cocoon"
	desc = "contains very poor prey to be sucked up by the huntress."
	icon_state = "cocoon1"
	max_integrity = 50
	var/mob/living/carbon/human/prey
	var/child =  /mob/living/simple_animal/hostile/giant_spider
	var/hatch_time = 2 MINUTES

/obj/structure/spider/cocoon/proc/encase(mob/living/carbon/human/target)
	prey = target
	target.forceMove(src)
	target.death(FALSE)

/obj/structure/spider/cocoon/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(hatch)), hatch_time)
	icon_state = "cocoon[rand(1,4)]"

/obj/structure/spider/cocoon/Destroy()
	prey?.forceMove(src.loc)
	. = ..()

/obj/structure/spider/cocoon/proc/hatch()
	if(src && child)
		new child(src.loc)
		prey?.gib(TRUE, FALSE,FALSE, TRUE)
		qdel(src)
