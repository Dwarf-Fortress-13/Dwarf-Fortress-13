/mob/living/simple_animal/hostile/frogman
	name = "frogman"
	desc = "Humanoid frog."
	icon_state = "frogman"
	icon_dead = "frogman_dead"
	speak_chance = 1
	speak = list("quack")
	speak_emote = list("quacks")
	turns_per_move = 2
	maxHealth = 120
	health = 120
	faction = list("mining")
	weather_immunities = list("ash")
	see_in_dark = 1
	butcher_results = list(/obj/item/food/meat/slab = list(1,2))
	response_help_continuous = "pushes"
	response_help_simple = "pushes"
	response_disarm_continuous = "pushes"
	response_disarm_simple = "pushes"
	response_harm_continuous = "hits"
	response_harm_simple = "hits"
	melee_damage_lower = 8
	melee_damage_upper = 15
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attacks"
	minbodytemp = 0
	maxbodytemp = 1600

/mob/living/simple_animal/hostile/shrooman
	name = "shrooman"
	desc = "When did it learn to walk?"
	icon_state = "muchroom2"
	icon_dead = "muchroom_dead"
	turns_per_move = 2
	faction = list("mining")
	maxHealth = 100
	health = 100
	weather_immunities = list("ash")
	see_in_dark = 1
	melee_damage_lower = 8
	melee_damage_upper = 12
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attacks"
	response_help_continuous = "pushes"
	response_help_simple = "pushes"
	response_disarm_continuous = "pushes"
	response_disarm_simple = "pushes"
	response_harm_continuous = "hits"
	response_harm_simple = "hits"
	minbodytemp = 0
	maxbodytemp = 1600
	loot =  list()

/mob/living/simple_animal/hostile/shrooman/death()
	// On death, create a small smoke of harmful gas (s-Acid)
	var/datum/effect_system/smoke_spread/chem/S = new
	var/turf/location = get_turf(src)

	// Create the reagents to put into the air
	create_reagents(10)
	reagents.add_reagent(/datum/reagent/drug, 10)

	// Attach the smoke spreader and setup/start it.
	S.attach(location)
	S.set_up(reagents, 1, location, silent = TRUE)
	S.start()
	..()


/mob/living/simple_animal/hostile/shrooman/fighter
	name = "fighter shrooman"
	desc = "Looks dangerous."
	icon_state = "muchroom1"
	icon_dead = "muchroom_dead"
	maxHealth = 140
	health = 140
	melee_damage_lower = 12
	melee_damage_upper = 20




/mob/living/simple_animal/hostile/mech_frog
	name = "mecha-frog"
	desc = "All systems nominal."
	icon_state = "frog_mech"
	icon_dead = "mech_dead"
	speak_chance = 1
	speak = list("quack", "ribbit")
	speak_emote = list("quacks")
	turns_per_move = 4
	maxHealth = 180
	health = 180
	faction = list("mining")
	weather_immunities = list("ash")
	see_in_dark = 1
	butcher_results = list(/obj/item/ingot = list(1,1), /obj/item/food/meat/slab = list(1,2))
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attacks"
	response_help_continuous = "pushes"
	response_help_simple = "pushes"
	response_disarm_continuous = "pushes"
	response_disarm_simple = "pushes"
	response_harm_continuous = "hits"
	response_harm_simple = "hits"
	melee_damage_lower = 12
	melee_damage_upper = 18
	minbodytemp = 0
	maxbodytemp = 1600

/mob/living/simple_animal/hostile/froggernaut
	name = "froggernaut"
	desc = "What the fuck?"
	icon_state = "umber_hulk"
	speed = 2
	move_to_delay = 2
	del_on_death = TRUE
	loot = list(/obj/item/stack/sheet/mineral/gem/diamond = 5)
	maxHealth = 600
	health = 600
	faction = list("mining")
	weather_immunities = list("ash")
	see_in_dark = 1
	attack_verb_continuous = "destroys"
	attack_verb_simple = "destroys"
	melee_damage_lower = 28
	melee_damage_upper = 35
	armour_penetration = 40
