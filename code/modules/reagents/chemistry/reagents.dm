#define REM REAGENTS_EFFECT_MULTIPLIER

GLOBAL_LIST_INIT(name2reagent, build_name2reagent())

/proc/build_name2reagent()
	. = list()
	for (var/t in subtypesof(/datum/reagent))
		var/datum/reagent/R = t
		if (length(initial(R.name)))
			.[lowertext(initial(R.name))] = t

//Various reagents
//Toxin & acid reagents
//Hydroponics stuff

/// A single reagent
/datum/reagent
	/// datums don't have names by default
	var/name = "Reagent"
	/// nor do they have descriptions
	var/description = ""
	///J/(K*mol)
	var/specific_heat = SPECIFIC_HEAT_DEFAULT
	/// used by taste messages
	var/taste_description = "something"
	///how this taste compares to others. Higher values means it is more noticable
	var/taste_mult = 1
	/// use for specialty drinks.
	var/glass_name = "glass of ...what?"
	/// desc applied to glasses with this reagent
	var/glass_desc = "You can't really tell what this is."
	/// Otherwise just sets the icon to a normal glass with the mixture of the reagents in the glass.
	var/glass_icon_state = null
	/// used for shot glasses, mostly for alcohol
	var/shot_glass_icon_state = null
	/// fallback icon if  the reagent has no glass or shot glass icon state. Used for restaurants.
	var/fallback_icon_state = null
	/// reagent holder this belongs to
	var/datum/reagents/holder = null
	/// LIQUID, SOLID, GAS
	var/reagent_state = LIQUID
	/// special data associated with this like viruses etc
	var/list/data
	/// increments everytime on_mob_life is called
	var/current_cycle = 0
	///pretend this is moles
	var/volume = 0
	///The molar mass of the reagent - if you're adding a reagent that doesn't have a recipe, just add a random number between 10 - 800. Higher numbers are "harder" but it's mostly arbitary.
	var/mass
	/// color it looks in containers etc
	var/color = "#000000" // rgb: 0, 0, 0
	///how fast the reagent is metabolized by the mob
	var/metabolization_rate = REAGENTS_METABOLISM
	/// appears unused
	var/overrides_metab = 0
	/// above this overdoses happen
	var/overdose_threshold = 0
	/// You fucked up and this is now triggering its overdose effects, purge that shit quick.
	var/overdosed = FALSE
	///if false stops metab in liverless mobs
	var/self_consuming = FALSE
	///affects how far it travels when sprayed
	var/reagent_weight = 1
	///is it currently metabolizing
	var/metabolizing = FALSE
	/// is it bad for you? Currently only used for borghypo. C2s and Toxins have it TRUE by default.
	var/harmful = FALSE
	///A list of causes why this chem should skip being removed, if the length is 0 it will be removed from holder naturally, if this is >0 it will not be removed from the holder.
	var/list/reagent_removal_skip_list = list()
	///The set of exposure methods this penetrates skin with.
	var/penetrates_skin = VAPOR
	/// See fermi_readme.dm REAGENT_DEAD_PROCESS, REAGENT_DONOTSPLIT, REAGENT_INVISIBLE, REAGENT_SNEAKYNAME, REAGENT_SPLITRETAINVOL, REAGENT_CANSYNTH, REAGENT_IMPURE
	var/chemical_flags = NONE
	///Thermodynamic vars
	///How hot this reagent burns when it's on fire - null means it can't burn
	var/burning_temperature = null
	///How much is consumed when it is burnt per second
	var/burning_volume = 0.5
	///Assoc list with key type of addiction this reagent feeds, and value amount of addiction points added per unit of reagent metabolzied (which means * REAGENTS_METABOLISM every life())
	var/list/addiction_types = null
	///A sound. Yes.
	var/sound/special_sound = null
	///hydration factor to restore thirst
	var/hydration_factor = 0


/datum/reagent/New()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()

	if(!mass)
		mass = rand(10, 800)

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	. = ..()
	holder = null

/// Applies this reagent to an [/atom]
/datum/reagent/proc/expose_atom(atom/exposed_atom, reac_volume)
	SHOULD_CALL_PARENT(TRUE)

	. = 0
	. |= SEND_SIGNAL(src, COMSIG_REAGENT_EXPOSE_ATOM, exposed_atom, reac_volume)
	. |= SEND_SIGNAL(exposed_atom, COMSIG_ATOM_EXPOSE_REAGENT, src, reac_volume)

/// Applies this reagent to a [/mob/living]
/datum/reagent/proc/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	SHOULD_CALL_PARENT(TRUE)

	. = SEND_SIGNAL(src, COMSIG_REAGENT_EXPOSE_MOB, exposed_mob, methods, reac_volume, show_message, touch_protection)
	if((methods & penetrates_skin) && exposed_mob.reagents) //smoke, foam, spray
		var/amount = round(reac_volume*clamp((1 - touch_protection), 0, 1), 0.1)
		if(amount >= 0.5)
			exposed_mob.reagents.add_reagent(type, amount)
	if(methods & INGEST)
		exposed_mob.adjust_hydration(reac_volume * hydration_factor * 10, type)

/datum/reagent/proc/FINISHONMOBLIFE(mob/living/M)
	current_cycle++
	M.reagents.remove_reagent(src.type, metabolization_rate * M.metabolism_efficiency) //By default it slowly disappears.
	return TRUE

/// Applies this reagent to an [/obj]
/datum/reagent/proc/expose_obj(obj/exposed_obj, reac_volume)
	SHOULD_CALL_PARENT(TRUE)

	return SEND_SIGNAL(src, COMSIG_REAGENT_EXPOSE_OBJ, exposed_obj, reac_volume)

/// Applies this reagent to a [/turf]
/datum/reagent/proc/expose_turf(turf/exposed_turf, reac_volume)
	SHOULD_CALL_PARENT(TRUE)

	return SEND_SIGNAL(src, COMSIG_REAGENT_EXPOSE_TURF, exposed_turf, reac_volume)

///Called whenever a reagent is on fire, or is in a holder that is on fire. (WIP)
/datum/reagent/proc/burn(datum/reagents/holder)
	return

/// Called from [/datum/reagents/proc/metabolize]
/datum/reagent/proc/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	current_cycle++
	if(length(reagent_removal_skip_list))
		return
	holder.remove_reagent(type, metabolization_rate * M.metabolism_efficiency * delta_time) //By default it slowly disappears.

/*
Used to run functions before a reagent is transfered. Returning TRUE will block the transfer attempt.
Primarily used in reagents/reaction_agents
*/
/datum/reagent/proc/intercept_reagents_transfer(datum/reagents/target)
	return FALSE

///Called after a reagent is transfered
/datum/reagent/proc/on_transfer(atom/A, methods=TOUCH, trans_volume)
	return


/// Called when this reagent is first added to a mob
/datum/reagent/proc/on_mob_add(mob/living/L, amount)
	overdose_threshold /= max(1) //Maybe??? Seems like it would help pure chems be even better but, if I normalised this to 1, then everything would take a 25% reduction
	return

/// Called when this reagent is removed while inside a mob
/datum/reagent/proc/on_mob_delete(mob/living/L)
	SEND_SIGNAL(L, COMSIG_CLEAR_MOOD_EVENT, "[type]_overdose")
	return

/// Called when this reagent first starts being metabolized by a liver
/datum/reagent/proc/on_mob_metabolize(mob/living/L)
	return

/// Called when a reagent is inside of a mob when they are dead
/datum/reagent/proc/on_mob_dead(mob/living/carbon/C)
	if(!(chemical_flags & REAGENT_DEAD_PROCESS))
		return
	current_cycle++
	if(length(reagent_removal_skip_list))
		return
	holder.remove_reagent(type, metabolization_rate * C.metabolism_efficiency)

/// Called when this reagent stops being metabolized by a liver
/datum/reagent/proc/on_mob_end_metabolize(mob/living/L)
	return

/// Called by [/datum/reagents/proc/conditional_update_move]
/datum/reagent/proc/on_move(mob/M)
	return

/// Called after add_reagents creates a new reagent.
/datum/reagent/proc/on_new(data)
	return

/// Called when two reagents of the same are mixing.
/datum/reagent/proc/on_merge(data, amount)
	return

/// Called by [/datum/reagents/proc/conditional_update]
/datum/reagent/proc/on_update(atom/A)
	return

/// Called when the reagent container is hit by an explosion
/datum/reagent/proc/on_ex_act(severity)
	return

/// Called if the reagent has passed the overdose threshold and is set to be triggering overdose effects
/datum/reagent/proc/overdose_process(mob/living/M, delta_time, times_fired)
	return

/// Called when an overdose starts
/datum/reagent/proc/overdose_start(mob/living/M)
	to_chat(M, span_userdanger("You feel like you took too much of [name]!"))
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overdose,0,0, name)
	return

/// Should return a associative list where keys are taste descriptions and values are strength ratios
/datum/reagent/proc/get_taste_description(mob/living/taster)
	return list("[taste_description]" = 1)

/proc/pretty_string_from_reagent_list(list/reagent_list)
	//Convert reagent list to a printable string for logging etc
	var/list/rs = list()
	for (var/datum/reagent/R in reagent_list)
		rs += "[R.name], [R.volume]"

	return rs.Join(" | ")


