GLOBAL_DATUM_INIT(fire_overlay, /mutable_appearance, mutable_appearance('icons/effects/fire.dmi', "fire"))

GLOBAL_VAR_INIT(stickpocalypse, FALSE) // if true, all non-embeddable items will be able to harmlessly stick to people when thrown
GLOBAL_VAR_INIT(embedpocalypse, FALSE) // if true, all items will be able to embed in people, takes precedence over stickpocalypse

/// Anything you can pick up and hold.
/obj/item
	name = "item"
	icon = 'icons/obj/items_and_weapons.dmi'
	blocks_emissive = EMISSIVE_BLOCK_GENERIC

	/*	!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!

		IF YOU ADD MORE ICON CRAP TO THIS
		ENSURE YOU ALSO ADD THE NEW VARS TO CHAMELEON ITEM_ACTION'S update_item() PROC (/datum/action/item_action/chameleon/change/proc/update_item())
		WASHING MASHINE'S dye_item() PROC (/obj/item/proc/dye_item())
		AND ALSO TO THE CHANGELING PROFILE DISGUISE SYSTEMS (/datum/changelingprofile / /datum/antagonist/changeling/proc/create_profile() / /proc/changeling_transform())

		!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!	*/

	///icon state for inhand overlays, if null the normal icon_state will be used.
	var/inhand_icon_state = null
	///Icon file for left hand inhand overlays
	var/lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	///Icon file for right inhand overlays
	var/righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	///Icon file for mob worn overlays.
	var/icon/worn_icon
	///icon state for mob worn overlays, if null the normal icon_state will be used.
	var/worn_icon_state
	///Icon state for the belt overlay, if null the normal icon_state will be used.
	var/belt_icon_state
	///Forced mob worn layer instead of the standard preferred ssize.
	var/alternate_worn_layer
	///The config type to use for greyscaled worn sprites. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_worn
	///The config type to use for greyscaled left inhand sprites. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_inhand_left
	///The config type to use for greyscaled right inhand sprites. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_inhand_right
	///The config type to use for greyscaled belt overlays. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_belt

	/*	!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!

		IF YOU ADD MORE ICON CRAP TO THIS
		ENSURE YOU ALSO ADD THE NEW VARS TO CHAMELEON ITEM_ACTION'S update_item() PROC (/datum/action/item_action/chameleon/change/proc/update_item())
		WASHING MASHINE'S dye_item() PROC (/obj/item/proc/dye_item())
		AND ALSO TO THE CHANGELING PROFILE DISGUISE SYSTEMS (/datum/changelingprofile / /datum/antagonist/changeling/proc/create_profile() / /proc/changeling_transform())

		!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!	*/

	///Dimensions of the icon file used when this item is worn, eg: hats.dmi (32x32 sprite, 64x64 sprite, etc.). Allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_x_dimension = 32
	///Dimensions of the icon file used when this item is worn, eg: hats.dmi (32x32 sprite, 64x64 sprite, etc.). Allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_y_dimension = 32
	///Same as for [worn_x_dimension][/obj/item/var/worn_x_dimension] but for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_x_dimension = 32
	///Same as for [worn_y_dimension][/obj/item/var/worn_y_dimension] but for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_y_dimension = 32


	max_integrity = 200



	obj_flags = NONE
	///Item flags for the item
	var/item_flags = NONE

	///Sound played when you hit something with the item
	var/hitsound
	///Played when the item is used, for example tools
	var/usesound
	///Sound when the item attack is missed
	var/misssound = 'dwarfs/sounds/weapons/sword/sword_miss.ogg'
	///Used when yate into a mob
	var/mob_throw_hit_sound
	///Sound used when equipping the item into a valid slot
	var/equip_sound
	///Sound uses when picking the item up (into your hands)
	var/pickup_sound
	///Sound uses when dropping the item, or when its thrown.
	var/drop_sound
	///Whether or not we use stealthy audio levels for this item's attack sounds
	var/stealthy_audio = FALSE

	var/parrysound = 'dwarfs/sounds/weapons/sword/sword_parry.ogg'
	///How large is the object, used for stuff like whether it can fit in backpacks or not
	var/w_class = WEIGHT_CLASS_NORMAL
	///This is used to determine on which slots an item can fit.
	var/slot_flags = 0
	pass_flags = PASSTABLE
	var/obj/item/master = null

	///flags which determine which body parts are protected from heat. [See here][HEAD]
	var/heat_protection = 0
	///flags which determine which body parts are protected from cold. [See here][HEAD]
	var/cold_protection = 0
	///Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/max_heat_protection_temperature
	///Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags
	var/min_cold_protection_temperature

	///list of /datum/action's that this item has.
	var/list/actions
	///list of paths of action datums to give to the item on New().
	var/list/actions_types

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	///This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/flags_inv
	///you can see someone's mask through their transparent visor, but you can't reach it
	var/transparent_protection = NONE

	///flags for what should be done when you click on the item, default is picking it up
	var/interaction_flags_item = INTERACT_ITEM_ATTACK_HAND_PICKUP

	///What body parts are covered by the clothing when you wear it
	var/body_parts_covered = 0

	/// How likely a chemical is to get through a piece of clothing
	var/permeability_coefficient = 1
	/// for electrical admittance/conductance (electrocution checks and shit)
	var/siemens_coefficient = 1
	/// How much clothing is slowing you down. Negative values speeds you up
	var/slowdown = 0
	///percentage of armor effectiveness to remove
	var/datum/armor_penetration/armor_penetration
	///What objects the suit storage can store
	var/list/allowed = null
	///In deciseconds, how long an item takes to equip; counts only for normal clothing slots, not pockets etc.
	var/equip_delay_self = 0
	///In deciseconds, how long an item takes to put on another person
	var/equip_delay_other = 20
	///In deciseconds, how long an item takes to remove from another person
	var/strip_delay = 40
	///How long it takes to resist out of the item (cuffs and such)
	var/breakoutchance = 0
	var/breakoutchanceincrement = 0
	var/breakouttime = 0

	///Used in [atom/proc/attackby] to say how something was attacked `"[x] has been [z.attack_verb] by [y] with [z]"`
	var/list/attack_verb_continuous
	var/list/attack_verb_simple
	///list() of species types, if a species cannot put items in a certain slot, but species type is in list, it will be able to wear that item
	var/list/species_exception = null

	///A weakref to the mob who threw the item
	var/datum/weakref/thrownby = null //I cannot verbally describe how much I hate this var
	///Items can by default thrown up to 10 tiles by TK users
	tk_throw_range = 10

	///the icon to indicate this object is being dragged
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	///Does it embed and if yes, what kind of embed
	var/list/embedding

	///for flags such as [GLASSESCOVERSEYES]
	var/flags_cover = 0
	var/heat = 0

	///How a tool acts when you use it on something, such as wirecutters cutting wires while multitools measure power
	var/tool_behaviour = NONE
	///How fast does the tool work
	var/toolspeed = 1

	var/block_chance = 0
	var/hit_reaction_chance = 0 //If you want to have something unrelated to blocking/armour piercing etc. Maybe not needed, but trying to think ahead/allow more freedom
	///In tiles, how far this weapon can reach; 1 for adjacent, which is default
	var/reach = 1

	/// How fast does the user recover after attacking with this item
	var/melee_cd = CLICK_CD_MELEE

	///The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot. For default list, see [/mob/proc/equip_to_appropriate_slot]
	var/list/slot_equipment_priority = null

	var/canMouseDown = FALSE

	/// Used in obj/item/examine to give additional notes on what the weapon does, separate from the predetermined output variables
	var/offensive_notes
	/// Used in obj/item/examine to determines whether or not to detail an item's statistics even if it does not meet the force requirements
	var/override_notes = FALSE
	/// Used skill in combat; affects dodges and misses
	var/datum/skill/combat/skill

/obj/item/Initialize()
	if(isnum(armor_penetration))
		armor_penetration = getArmorPen(armor_penetration, armor_penetration, armor_penetration, armor_penetration, armor_penetration, armor_penetration) //everything has the same value
	else if(islist(armor_penetration))
		armor_penetration = getArmorPen(arglist(armor_penetration))
	else if(!armor_penetration)
		armor_penetration = getArmorPen()

	if(attack_verb_continuous)
		attack_verb_continuous = string_list(attack_verb_continuous)
	if(attack_verb_simple)
		attack_verb_simple = string_list(attack_verb_simple)
	if(species_exception)
		species_exception = string_list(species_exception)

	. = ..()
	for(var/path in actions_types)
		new path(src)
	actions_types = null

	if(!hitsound)
		if(damtype == BURN)
			hitsound = 'sound/items/welder.ogg'
		if(damtype == BRUTE)
			hitsound = "swing_hit"

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NEW_ITEM, src)
	if(LAZYLEN(embedding))
		updateEmbedding()

///Fetches its corresponding armor penetration depending on atck_type
/obj/item/proc/get_armorpen(rating = null)
	if(rating)
		return armor_penetration.GetRating(rating)
	return armor_penetration.GetRating(atck_type)

/obj/item/Destroy()
	item_flags &= ~DROPDEL	//prevent reqdels
	if(ismob(loc))
		var/mob/m = loc
		m.temporarilyRemoveItemFromInventory(src, TRUE)
	for(var/X in actions)
		qdel(X)
	return ..()

/obj/item/proc/check_allowed_items(atom/target, not_inside, target_self)
	if(((src in target) && !target_self) || (!isturf(target.loc) && !isturf(target) && not_inside))
		return 0
	else
		return 1

/obj/item/ComponentInitialize()
	. = ..()
	// this proc says it's for initializing components, but we're initializing elements too because it's you and me against the world >:)
	if(!LAZYLEN(embedding))
		if(GLOB.embedpocalypse)
			embedding = EMBED_POINTY
			name = "sharp [name]"
		else if(GLOB.stickpocalypse)
			embedding = EMBED_HARMLESS
			name = "sticky [name]"

	updateEmbedding()

	if(atck_type == SHARP) //give sharp objects butchering functionality, for consistency
		AddComponent(/datum/component/butchering, 80 * toolspeed)

/**Makes cool stuff happen when you suicide with an item
 *
 *Outputs a creative message and then return the damagetype done
 * Arguments:
 * * user: The mob that is suiciding
 */
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/set_greyscale(list/colors, new_config, new_worn_config, new_inhand_left, new_inhand_right)
	if(new_worn_config)
		greyscale_config_worn = new_worn_config
	if(new_inhand_left)
		greyscale_config_inhand_left = new_inhand_left
	if(new_inhand_right)
		greyscale_config_inhand_right = new_inhand_right
	return ..()

/// Checks if this atom uses the GAGS system and if so updates the worn and inhand icons
/obj/item/update_greyscale()
	. = ..()
	if(!greyscale_colors)
		return
	if(greyscale_config_worn)
		worn_icon = SSgreyscale.GetColoredIconByType(greyscale_config_worn, greyscale_colors)
	if(greyscale_config_inhand_left)
		lefthand_file = SSgreyscale.GetColoredIconByType(greyscale_config_inhand_left, greyscale_colors)
	if(greyscale_config_inhand_right)
		righthand_file = SSgreyscale.GetColoredIconByType(greyscale_config_inhand_right, greyscale_colors)

/obj/item/verb/move_to_top()
	set name = "Move to top"
	set category = "Obj"
	set src in oview(1)

	if(!isturf(loc) || usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return

	var/turf/T = loc
	abstract_move(null)
	forceMove(T)

/obj/item/examine(mob/user) //This might be spammy. Remove?
	. = ..()

	. += "<hr>"

	if(resistance_flags & INDESTRUCTIBLE)
		. += span_smallnotice("<b>Protective properties:</b> [icon2html(EMOJI_SET, user, "indestructible")] Indestructible.\n")
	else
		var/list/rfm = list()
		if(resistance_flags & LAVA_PROOF)
			rfm += icon2html(EMOJI_SET, user, "lava")
		if(resistance_flags & (ACID_PROOF | UNACIDABLE))
			rfm += icon2html(EMOJI_SET, user, "acid")
		if(resistance_flags & FREEZE_PROOF)
			rfm += icon2html(EMOJI_SET, user, "cold")
		if(resistance_flags & FIRE_PROOF)
			rfm += icon2html(EMOJI_SET, user, "fire")
		if(rfm.len)
			. += span_smallnotice("<b>Protective properties:</b> [rfm.Join(" ")]\n")

	. += span_smallnotice("<b>Size:</b> [weightclass2icon(w_class, user, TRUE)]")

/obj/item/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/item/ui_act(action, list/params)
	add_fingerprint(usr)
	return ..()

/obj/item/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!user)
		return
	if(anchored)
		return

	. = TRUE

	if(resistance_flags & ON_FIRE)
		var/mob/living/carbon/C = user
		var/can_handle_hot = FALSE
		if(!istype(C))
			can_handle_hot = TRUE
		else if(C.gloves && (C.gloves.max_heat_protection_temperature > 360))
			can_handle_hot = TRUE
		else if(HAS_TRAIT(C, TRAIT_RESISTHEAT) || HAS_TRAIT(C, TRAIT_RESISTHEATHANDS))
			can_handle_hot = TRUE

		if(can_handle_hot)
			extinguish()
			to_chat(user, span_notice("You extinguish [src]."))
		else
			to_chat(user, span_warning("You burn your hand touching [src]!"))
			var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
			if(affecting?.receive_damage( 0, 5 ))		// 5 burn damage
				C.update_damage_overlays()
			return

	if(!(interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP))		//See if we're supposed to auto pickup.
		return

	//If the item is in a storage item, take it out
	SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE)
	if(QDELETED(src)) //moving it out of the storage to the floor destroyed it.
		return

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!allow_attack_hand_drop(user) || !user.temporarilyRemoveItemFromInventory(src))
			return

	. = FALSE
	return pickup(user)

/obj/item/proc/allow_attack_hand_drop(mob/user)
	return TRUE

/obj/item/attack_paw(mob/user)
	if(!user)
		return
	if(anchored)
		return

	SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE)

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!user.temporarilyRemoveItemFromInventory(src))
			return

	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)

/obj/item/proc/GetDeconstructableContents()
	return GetAllContents() - src

// afterattack() and attack() prototypes moved to _onclick/item_attack.dm for consistency

/obj/item/proc/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, owner, hitby, attack_text, final_block_chance, damage, attack_type) & COMPONENT_HIT_REACTION_BLOCK)
		return TRUE

	if(prob(final_block_chance))
		owner.visible_message(span_danger("<b>[owner]</b> blocks [attack_text] using <b>[src.name]</b>!"))
		return TRUE

/obj/item/proc/talk_into(mob/M, input, channel, spans, datum/language/language, list/message_mods)
	return ITALICS | REDUCE_RANGE

/// Called when a mob drops an item.
/obj/item/proc/dropped(mob/user, silent = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(user)
	if(item_flags & DROPDEL)
		qdel(src)
	item_flags &= ~IN_INVENTORY
	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user)
	if(!silent)
		playsound(src, drop_sound, DROP_SOUND_VOLUME, ignore_walls = FALSE)
	user?.update_equipment_speed_mods()

/// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user)
	item_flags |= IN_INVENTORY
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)
		return TRUE

/// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder)
	return

/**
 * Called after an item is placed in an equipment slot.
 *
 * Note that hands count as slots.
 *
 * Arguments:
 * * user is mob that equipped it
 * * slot uses the slot_X defines found in setup.dm for items that can be placed in multiple slots
 * * Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 */
/obj/item/proc/equipped(mob/user, slot, initial = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)
	for(var/X in actions)
		var/datum/action/A = X
		if(item_action_slot_check(slot, user)) //some items only give their actions buttons when in a specific slot.
			A.Grant(user)
	item_flags |= IN_INVENTORY
	if(!initial)
		if(equip_sound && (slot_flags & slot))
			playsound(src, equip_sound, EQUIP_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
		else if(slot == ITEM_SLOT_HANDS)
			playsound(src, pickup_sound, PICKUP_SOUND_VOLUME, ignore_walls = FALSE)
	user.update_equipment_speed_mods()

///sometimes we only want to grant the item's action if it's equipped in a specific slot.
/obj/item/proc/item_action_slot_check(slot, mob/user)
	if(slot == ITEM_SLOT_BACKPACK || slot == ITEM_SLOT_LEGCUFFED) //these aren't true slots, so avoid granting actions there
		return FALSE
	return TRUE

/**
 *the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
 *if this is being done by a mob other than M, it will include the mob equipper, who tries to equip the item to mob M. equipper will be null otherwise.
 *If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
 * Arguments:
 * * disable_warning to TRUE if you wish it to not give you text outputs.
 * * slot is the slot we are trying to equip to
 * * equipper is the mob trying to equip the item
 * * bypass_equip_delay_self for whether we want to bypass the equip delay
 */
/obj/item/proc/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!M)
		return FALSE

	return M.can_equip(src, slot, disable_warning, bypass_equip_delay_self)

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Obj"
	set name = "Pick up"

	if(usr.incapacitated() || !Adjacent(usr))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return

	if(usr.get_active_held_item() == null) // Let me know if this has any problems -Yota
		usr.UnarmedAttack(src)

/**
 *This proc is executed when someone clicks the on-screen UI button.
 *The default action is attack_self().
 *Checks before we get to here are: mob is alive, mob is not restrained, stunned, asleep, resting, laying, item is on the mob.
 */
/obj/item/proc/ui_action_click(mob/user, actiontype)
	attack_self(user)

///This proc determines if and at what an object will reflect energy projectiles if it's in l_hand,r_hand or wear_suit
/obj/item/proc/IsReflect(def_zone)
	return FALSE

/obj/item/on_exit_storage(datum/component/storage/concrete/master_storage)
	. = ..()
	var/atom/location = master_storage.real_location()
	do_drop_animation(location)

/obj/item/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(hit_atom && !QDELETED(hit_atom))
		SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
		if(get_temperature() && isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.IgniteMob()
		var/itempush = 1
		if(w_class < 4)
			itempush = 0 //too light to push anything
		if(istype(hit_atom, /mob/living)) //Living mobs handle hit sounds differently.
			var/volume = get_volume_by_throwforce_and_or_w_class()
			if (throwforce > 0)
				if (mob_throw_hit_sound)
					playsound(hit_atom, mob_throw_hit_sound, volume, TRUE, -1)
				else if(hitsound)
					playsound(hit_atom, hitsound, volume, TRUE, -1)
				else
					playsound(hit_atom, 'sound/weapons/genhit.ogg',volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/weapons/throwtap.ogg', 1, volume, -1)

		else
			playsound(src, drop_sound, YEET_SOUND_VOLUME, ignore_walls = FALSE)
		return hit_atom.hitby(src, 0, itempush, throwingdatum=throwingdatum)

/obj/item/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, gentle = FALSE, quickstart = TRUE, params)
	if(HAS_TRAIT(src, TRAIT_NODROP))
		return
	thrownby = WEAKREF(thrower)
	callback = CALLBACK(src, PROC_REF(after_throw), callback) //replace their callback with our own
	. = ..(target, range, speed, thrower, spin, diagonals_first, callback, force, gentle, quickstart = quickstart)

/obj/item/proc/after_throw(datum/callback/callback)
	if (callback) //call the original callback
		. = callback.Invoke()
	item_flags &= ~IN_INVENTORY
	if(!pixel_y && !pixel_x && !(item_flags & NO_PIXEL_RANDOM_DROP))
		pixel_x = rand(-8,8)
		pixel_y = rand(-8,8)


/obj/item/proc/remove_item_from_storage(atom/newLoc) //please use this if you're going to snowflake an item out of a obj/item/storage
	if(!newLoc)
		return FALSE
	if(SEND_SIGNAL(loc, COMSIG_CONTAINS_STORAGE))
		return SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, newLoc, TRUE)
	return FALSE

/// Returns the icon used for overlaying the object on a belt
/obj/item/proc/get_belt_overlay()
	var/icon_state_to_use = belt_icon_state || icon_state
	if(greyscale_config_belt && greyscale_colors)
		return mutable_appearance(SSgreyscale.GetColoredIconByType(greyscale_config_belt, greyscale_colors), icon_state_to_use)
	return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', icon_state_to_use)

/obj/item/proc/update_slot_icon()
	if(!ismob(loc))
		return
	var/mob/owner = loc
	var/flags = slot_flags
	if(flags & ITEM_SLOT_OCLOTHING)
		owner.update_inv_wear_suit()
	if(flags & ITEM_SLOT_ICLOTHING)
		owner.update_inv_w_uniform()
	if(flags & ITEM_SLOT_GLOVES)
		owner.update_inv_gloves()
	if(flags & ITEM_SLOT_EYES)
		owner.update_inv_glasses()
	if(flags & ITEM_SLOT_EARS)
		owner.update_inv_ears()
	if(flags & ITEM_SLOT_MASK)
		owner.update_inv_wear_mask()
	if(flags & ITEM_SLOT_HEAD)
		owner.update_inv_head()
	if(flags & ITEM_SLOT_FEET)
		owner.update_inv_shoes()
	if(flags & ITEM_SLOT_BELT)
		owner.update_inv_belt()
	if(flags & ITEM_SLOT_BACK)
		owner.update_inv_back()
	if(flags & ITEM_SLOT_NECK)
		owner.update_inv_neck()

///Returns the temperature of src. If you want to know if an item is hot use this proc.
/obj/item/proc/get_temperature()
	return heat

///Returns the fuel value of src to make refuelling easier
/obj/item/proc/get_fuel()
	return 0

///Returns the sharpness of src. If you want to get the sharpness of an item use this.
/obj/item/proc/get_sharpness()
	return atck_type == SHARP

/obj/item/proc/get_dismember_sound()
	if(damtype == BURN)
		. = 'sound/weapons/sear.ogg'
	else
		. = "desecration"

/obj/item/proc/open_flame(flame_heat=700)
	var/turf/location = loc
	if(ismob(location))
		var/mob/M = location
		var/success = FALSE
		if(src == M.get_item_by_slot(ITEM_SLOT_MASK))
			success = TRUE
		if(success)
			location = get_turf(M)

/obj/item/proc/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = span_notice("[user] ignites [A] using [src].")
	else
		. = ""

/obj/item/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	return SEND_SIGNAL(src, COMSIG_ATOM_HITBY, AM, skipcatch, hitpush, blocked, throwingdatum)

/obj/item/attack_animal(mob/living/simple_animal/M)
	if (obj_flags & CAN_BE_HIT)
		return ..()
	return 0

/obj/item/burn()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/ash_type = /obj/effect/decal/cleanable/ash
		if(w_class == WEIGHT_CLASS_HUGE || w_class == WEIGHT_CLASS_GIGANTIC)
			ash_type = /obj/effect/decal/cleanable/ash/large
		var/obj/effect/decal/cleanable/ash/A = new ash_type(T)
		A.desc += "\nLooks like this used to be \an [name] some time ago."
		..()

/obj/item/acid_melt()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/obj/effect/decal/cleanable/molten_object/MO = new(T)
		MO.pixel_x = rand(-16,16)
		MO.pixel_y = rand(-16,16)
		MO.desc = "Looks like this was <b>[src.name]</b> some time ago."
		..()

/// Called when a mob tries to use the item as a tool. Handles most checks.
/obj/item/proc/use_tool(atom/target, mob/living/user, delay, amount=0, volume=0, datum/callback/extra_checks)
	// No delay means there is no start message, and no reason to call tool_start_check before use_tool.
	// Run the start check here so we wouldn't have to call it manually.
	if(!delay && !tool_start_check(user, amount))
		return

	var/skill_modifier = 1

	delay *= toolspeed * skill_modifier


	// Play tool sound at the beginning of tool usage.
	play_tool_sound(target, volume)

	if(delay)
		// Create a callback with checks that would be called every tick by do_after.
		var/datum/callback/tool_check = CALLBACK(src, PROC_REF(tool_check_callback), user, amount, extra_checks)

		if(ismob(target))
			if(!do_mob(user, target, delay, extra_checks=tool_check))
				return

		else
			if(!do_after(user, delay, target=target, extra_checks=tool_check))
				return
	else
		// Invoke the extra checks once, just in case.
		if(extra_checks && !extra_checks.Invoke())
			return

	// Use tool's fuel, stack sheets or charges if amount is set.
	if(amount && !use(amount))
		return

	// Play tool sound at the end of tool usage,
	// but only if the delay between the beginning and the end is not too small
	if(delay >= MIN_TOOL_SOUND_DELAY)
		play_tool_sound(target, volume)

	return TRUE

/// Called before [obj/item/proc/use_tool] if there is a delay, or by [obj/item/proc/use_tool] if there isn't. Only ever used by welding tools and stacks, so it's not added on any other [obj/item/proc/use_tool] checks.
/obj/item/proc/tool_start_check(mob/living/user, amount=0)
	. = tool_use_check(user, amount)
	if(.)
		SEND_SIGNAL(src, COMSIG_TOOL_START_USE, user)

/// A check called by [/obj/item/proc/tool_start_check] once, and by use_tool on every tick of delay.
/obj/item/proc/tool_use_check(mob/living/user, amount)
	return !amount

/// Generic use proc. Depending on the item, it uses up fuel, charges, sheets, etc. Returns TRUE on success, FALSE on failure.
/obj/item/proc/use(used)
	return !used

/// Plays item's usesound, if any.
/obj/item/proc/play_tool_sound(atom/target, volume=50)
	if(target && usesound && volume)
		var/played_sound = usesound

		if(islist(usesound))
			played_sound = pick(usesound)

		playsound(target, played_sound, volume, TRUE)

/// Used in a callback that is passed by use_tool into do_after call. Do not override, do not call manually.
/obj/item/proc/tool_check_callback(mob/living/user, amount, datum/callback/extra_checks)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = tool_use_check(user, amount) && (!extra_checks || extra_checks.Invoke())
	if(.)
		SEND_SIGNAL(src, COMSIG_TOOL_IN_USE, user)

/// Returns a numeric value for sorting items used as parts in machines, so they can be replaced by the rped
/obj/item/proc/get_part_rating()
	return 0

/obj/item/doMove(atom/destination)
	if (ismob(loc))
		var/mob/M = loc
		var/hand_index = M.get_held_index_of_item(src)
		if(hand_index)
			M.held_items[hand_index] = null
			M.update_inv_hands()
			if(M.client)
				M.client.screen -= src
			layer = initial(layer)
			plane = initial(plane)
			appearance_flags &= ~NO_CLIENT_COLOR
			dropped(M, FALSE)
	return ..()

/obj/item/proc/embedded(atom/embedded_target, obj/item/bodypart/part)
	return

/obj/item/proc/unembedded()
	if(item_flags & DROPDEL)
		qdel(src)
		return TRUE

/obj/item/proc/canStrip(mob/stripper, mob/owner)
	SHOULD_BE_PURE(TRUE)
	return !HAS_TRAIT(src, TRAIT_NODROP) && !(item_flags & ABSTRACT)

/obj/item/proc/doStrip(mob/stripper, mob/owner)
	return owner.dropItemToGround(src)

///Does the current embedding var meet the criteria for being harmless? Namely, does it have a pain multiplier and jostle pain mult of 0? If so, return true.
/obj/item/proc/isEmbedHarmless()
	if(embedding)
		return !isnull(embedding["pain_mult"]) && !isnull(embedding["jostle_pain_mult"]) && embedding["pain_mult"] == 0 && embedding["jostle_pain_mult"] == 0

///In case we want to do something special (like self delete) upon failing to embed in something.
/obj/item/proc/failedEmbed()
	if(item_flags & DROPDEL)
		qdel(src)

///Called by the carbon throw_item() proc. Returns null if the item negates the throw, or a reference to the thing to suffer the throw else.
/obj/item/proc/on_thrown(mob/living/carbon/user, atom/target)
	if((item_flags & ABSTRACT) || HAS_TRAIT(src, TRAIT_NODROP))
		return
	user.dropItemToGround(src, silent = TRUE)
	if(throwforce && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_notice("You set [src] down gently on the ground."))
		return

	return src

/**
 * tryEmbed() is for when you want to try embedding something without dealing with the damage + hit messages of calling hitby() on the item while targetting the target.
 *
 * Really, this is used mostly with projectiles with shrapnel payloads, from [/datum/element/embed/proc/checkEmbedProjectile], and called on said shrapnel. Mostly acts as an intermediate between different embed elements.
 *
 * Returns TRUE if it embedded successfully, nothing otherwise
 *
 * Arguments:
 * * target- Either a body part or a carbon. What are we hitting?
 * * forced- Do we want this to go through 100%?
 */
/obj/item/proc/tryEmbed(atom/target, forced=FALSE, silent=FALSE)
	if(!isbodypart(target) && !iscarbon(target))
		return NONE
	if(!forced && !LAZYLEN(embedding))
		return NONE

	if(SEND_SIGNAL(src, COMSIG_EMBED_TRY_FORCE, target, forced, silent))
		return COMPONENT_EMBED_SUCCESS
	failedEmbed()

///For when you want to disable an item's embedding capabilities (like transforming weapons and such), this proc will detach any active embed elements from it.
/obj/item/proc/disableEmbedding()
	SEND_SIGNAL(src, COMSIG_ITEM_DISABLE_EMBED)
	return

///For when you want to add/update the embedding on an item. Uses the vars in [/obj/item/var/embedding], and defaults to config values for values that aren't set. Will automatically detach previous embed elements on this item.
/obj/item/proc/updateEmbedding()
	if(!LAZYLEN(embedding))
		return

	AddElement(/datum/element/embed,\
		embed_chance = (!isnull(embedding["embed_chance"]) ? embedding["embed_chance"] : EMBED_CHANCE),\
		fall_chance = (!isnull(embedding["fall_chance"]) ? embedding["fall_chance"] : EMBEDDED_ITEM_FALLOUT),\
		pain_chance = (!isnull(embedding["pain_chance"]) ? embedding["pain_chance"] : EMBEDDED_PAIN_CHANCE),\
		pain_mult = (!isnull(embedding["pain_mult"]) ? embedding["pain_mult"] : EMBEDDED_PAIN_MULTIPLIER),\
		remove_pain_mult = (!isnull(embedding["remove_pain_mult"]) ? embedding["remove_pain_mult"] : EMBEDDED_UNSAFE_REMOVAL_PAIN_MULTIPLIER),\
		rip_time = (!isnull(embedding["rip_time"]) ? embedding["rip_time"] : EMBEDDED_UNSAFE_REMOVAL_TIME),\
		ignore_throwspeed_threshold = (!isnull(embedding["ignore_throwspeed_threshold"]) ? embedding["ignore_throwspeed_threshold"] : FALSE),\
		impact_pain_mult = (!isnull(embedding["impact_pain_mult"]) ? embedding["impact_pain_mult"] : EMBEDDED_IMPACT_PAIN_MULTIPLIER),\
		jostle_chance = (!isnull(embedding["jostle_chance"]) ? embedding["jostle_chance"] : EMBEDDED_JOSTLE_CHANCE),\
		jostle_pain_mult = (!isnull(embedding["jostle_pain_mult"]) ? embedding["jostle_pain_mult"] : EMBEDDED_JOSTLE_PAIN_MULTIPLIER),\
		pain_stam_pct = (!isnull(embedding["pain_stam_pct"]) ? embedding["pain_stam_pct"] : EMBEDDED_PAIN_STAM_PCT))
	return TRUE

/// How many different types of mats will be counted in a bite?
#define MAX_MATS_PER_BITE 2

/*
 * On accidental consumption: when you somehow end up eating an item accidentally (currently, this is used for when items are hidden in food like bread or cake)
 *
 * The base proc will check if the item is sharp and has a decent force.
 * Then, it checks the item's mat datums for the effects it applies afterwards.
 * Then, it checks tiny items.
 * After all that, it returns TRUE if the item is set to be discovered. Otherwise, it returns FALSE.
 *
 * This works similarily to /suicide_act: if you want an item to have a unique interaction, go to that item
 * and give it an /on_accidental_consumption proc override. For a simple example of this, check out the nuke disk.
 *
 * Arguments
 * * M - the mob accidentally consuming the item
 * * user - the mob feeding M the item - usually, it's the same as M
 * * source_item - the item that held the item being consumed - bread, cake, etc
 * * discover_after - if the item will be discovered after being chomped (FALSE will usually mean it was swallowed, TRUE will usually mean it was bitten into and discovered)
 */
/obj/item/proc/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item, discover_after = TRUE)
	if(get_sharpness() && force >= 5) //if we've got something sharp with a decent force (ie, not plastic)
		INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "agony")
		victim.visible_message(span_warning("[victim] looks like [victim.p_theyve()] just bit something they shouldn't have!") , \
							span_boldwarning("OH GOD! Was that a crunch? That didn't feel good at all!!"))

		victim.apply_damage(max(15, force), BRUTE, BODY_ZONE_HEAD, wound_bonus = 10, attack_type = atck_type)
		victim.losebreath += 2
		if(tryEmbed(victim.get_bodypart(BODY_ZONE_CHEST), TRUE, TRUE)) //and if it embeds successfully in their chest, cause a lot of pain
			victim.apply_damage(max(25, force*1.5), BRUTE, BODY_ZONE_CHEST, wound_bonus = 7, attack_type = atck_type)
			victim.losebreath += 6
			discover_after = FALSE
		if(QDELETED(src)) // in case trying to embed it caused its deletion (say, if it's DROPDEL)
			return
		source_item?.reagents?.add_reagent(/datum/reagent/blood, 2)

	else if(w_class == WEIGHT_CLASS_TINY) //small items like soap or toys that don't have mat datums
		/// victim's chest (for cavity implanting the item)
		var/obj/item/bodypart/chest/victim_cavity = victim.get_bodypart(BODY_ZONE_CHEST)
		if(victim_cavity.cavity_item)
			victim.vomit(5, FALSE, FALSE, distance = 0)
			forceMove(drop_location())
			to_chat(victim, span_warning("You vomit up a [name]! [source_item? "Was that in [source_item]?" : ""]"))
		else
			victim.transferItemToLoc(src, victim, TRUE)
			victim.losebreath += 2
			victim_cavity.cavity_item = src
			to_chat(victim, span_warning("You swallow hard. [source_item? "Something small was in [source_item]..." : ""]"))
		discover_after = FALSE

	else
		to_chat(victim, span_warning("[source_item? "Something strange was in the [source_item]..." : "I just bit something strange..."] "))

	return discover_after

#undef MAX_MATS_PER_BITE

/**
 * Updates all action buttons associated with this item
 *
 * Arguments:
 * * status_only - Update only current availability status of the buttons to show if they are ready or not to use
 * * force - Force buttons update even if the given button icon state has not changed
 */
/obj/item/proc/update_action_buttons(status_only = FALSE, force = FALSE)
	for(var/datum/action/current_action as anything in actions)
		current_action.UpdateButtonIcon(status_only, force)

// Update icons if this is being carried by a mob
/obj/item/wash(clean_types)
	. = ..()

	if(ismob(loc))
		var/mob/mob_loc = loc
		mob_loc.regenerate_icons()

/// Called on [/datum/element/openspace_item_click_handler/proc/on_afterattack]. Check the relative file for information.
/obj/item/proc/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	stack_trace("Undefined handle_openspace_click() behaviour. Ascertain the openspace_item_click_handler element has been attached to the right item and that its proc override doesn't call parent.")

/**
 * * An interrupt for offering an item to other people, called mainly from [/mob/living/carbon/proc/give], in case you want to run your own offer behavior instead.
 *
 * * Return TRUE if you want to interrupt the offer.
 *
 * * Arguments:
 * * offerer - the person offering the item
 */
/obj/item/proc/on_offered(mob/living/carbon/offerer)
	if(SEND_SIGNAL(src, COMSIG_ITEM_OFFERING, offerer) & COMPONENT_OFFER_INTERRUPT)
		return TRUE

/**
 * * An interrupt for someone trying to accept an offered item, called mainly from [/mob/living/carbon/proc/take], in case you want to run your own take behavior instead.
 *
 * * Return TRUE if you want to interrupt the taking.
 *
 * * Arguments:
 * * offerer - the person offering the item
 * * taker - the person trying to accept the offer
 */
/obj/item/proc/on_offer_taken(mob/living/carbon/offerer, mob/living/carbon/taker)
	if(SEND_SIGNAL(src, COMSIG_ITEM_OFFER_TAKEN, offerer, taker) & COMPONENT_OFFER_INTERRUPT)
		return TRUE

/obj/item/proc/do_pickup_animation(atom/target)
	if(!istype(loc, /turf))
		return
	var/image/pickup_animation = image(icon = src, loc = loc, layer = layer + 0.1)
	pickup_animation.plane = GAME_PLANE
	pickup_animation.transform.Scale(0.75)
	pickup_animation.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/turf/current_turf = get_turf(src)
	var/direction = get_dir(current_turf, target)
	var/to_x = target.base_pixel_x
	var/to_y = target.base_pixel_y

	if(direction & NORTH)
		to_y += 32
	else if(direction & SOUTH)
		to_y -= 32
	if(direction & EAST)
		to_x += 32
	else if(direction & WEST)
		to_x -= 32
	if(!direction)
		to_y += 10
		pickup_animation.pixel_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	flick_overlay(pickup_animation, GLOB.clients, 4)
	var/matrix/animation_matrix = new
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.65)

	animate(pickup_animation, alpha = 175, pixel_x = to_x, pixel_y = to_y, time = 3, transform = animation_matrix, easing = CUBIC_EASING)
	animate(alpha = 0, transform = matrix().Scale(0.7), time = 1)

/obj/item/proc/do_drop_animation(atom/moving_from)
	if(!istype(loc, /turf))
		return

	var/turf/current_turf = get_turf(src)
	var/direction = get_dir(moving_from, current_turf)
	var/from_x = moving_from.base_pixel_x
	var/from_y = moving_from.base_pixel_y

	if(direction & NORTH)
		from_y -= 32
	else if(direction & SOUTH)
		from_y += 32
	if(direction & EAST)
		from_x -= 32
	else if(direction & WEST)
		from_x += 32
	if(!direction)
		from_y += 10
		from_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	//We're moving from these chords to our current ones
	var/old_x = pixel_x
	var/old_y = pixel_y
	var/old_alpha = alpha
	var/matrix/animation_matrix = new
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.7) // Shrink to start, end up normal sized

	pixel_x = from_x
	pixel_y = from_y
	alpha = 0
	transform = animation_matrix

	// This is instant on byond's end, but to our clients this looks like a quick drop
	animate(src, alpha = old_alpha, pixel_x = old_x, pixel_y = old_y, transform = matrix(), time = 3, easing = CUBIC_EASING)

/atom/movable/proc/do_item_attack_animation(atom/attacked_atom, visual_effect_icon, obj/item/used_item)
	var/image/attack_image
	if(visual_effect_icon)
		attack_image = image('icons/effects/effects.dmi', attacked_atom, visual_effect_icon, attacked_atom.layer + 0.1)
	else if(used_item)
		attack_image = image(icon = used_item, loc = attacked_atom, layer = attacked_atom.layer + 0.1)
		attack_image.plane = attacked_atom.plane

		// Scale the icon.
		attack_image.transform *= 0.4
		// The icon should not rotate.
		attack_image.appearance_flags = APPEARANCE_UI

		// Set the direction of the icon animation.
		var/direction = get_dir(src, attacked_atom)
		if(direction & NORTH)
			attack_image.pixel_y = -12
		else if(direction & SOUTH)
			attack_image.pixel_y = 12

		if(direction & EAST)
			attack_image.pixel_x = -14
		else if(direction & WEST)
			attack_image.pixel_x = 14

		if(!direction) // Attacked self?!
			attack_image.pixel_y = 12
			attack_image.pixel_x = 5 * (prob(50) ? 1 : -1)

	if(!attack_image)
		return

	flick_overlay(attack_image, GLOB.clients, 10)
	// And animate the attack!
	animate(attack_image, alpha = 175, transform = matrix() * 0.75, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)
	animate(time = 1)
	animate(alpha = 0, time = 3, easing = CIRCULAR_EASING|EASE_OUT)

/obj/item/proc/attach_action(datum/action/action)
	if(ispath(action))
		action = new action(src)
	else
		action.link_to(src)
	if(actions)
		actions.Add(action)
	else
		actions = list(action)
