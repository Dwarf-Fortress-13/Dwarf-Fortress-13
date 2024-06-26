/obj/item/kitchen
	icon = 'dwarfs/icons/items/kitchen.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'

/obj/item/kitchen/knife
	name = "kitchen knife"
	icon_state = "kitchen_knife"
	inhand_icon_state = "knife"
	worn_icon_state = "knife"
	desc = "A general purpose Chef's Knife. Guaranteed to stay sharp for years to come."
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	throw_speed = 3
	throw_range = 6
	attack_verb_continuous = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	atck_type = SHARP
	var/bayonet = FALSE //Can this be attached to a gun?
	wound_bonus = -5
	bare_wound_bonus = 10
	tool_behaviour = TOOL_KNIFE
	materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)

/obj/item/kitchen/knife/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/kitchen/knife/Initialize()
	. = ..()
	AddElement(/datum/element/eyestab)
	set_butchering()

///Adds the butchering component, used to override stats for special cases
/obj/item/kitchen/knife/proc/set_butchering()
	AddComponent(/datum/component/butchering, 80 - force)

/obj/item/kitchen/knife/suicide_act(mob/user)
	user.visible_message(pick(span_suicide("[user] is slitting [user.p_their()] wrists with the [src.name]! It looks like [user.p_theyre()] trying to commit suicide.") , \
						span_suicide("[user] is slitting [user.p_their()] throat with the [src.name]! It looks like [user.p_theyre()] trying to commit suicide.") , \
						span_suicide("[user] is slitting [user.p_their()] stomach open with the [src.name]! It looks like [user.p_theyre()] trying to commit seppuku.")))
	return (BRUTELOSS)

/obj/item/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	inhand_icon_state = "rolling_pin"
	worn_icon_state = "rolling_pin"
	force = 5
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("bashes", "batters", "bludgeons", "thrashes", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "thrash", "whack")
	custom_price = PAYCHECK_EASY * 1.5
	tool_behaviour = TOOL_ROLLINGPIN
	materials = /datum/material/wood/pine/treated

/obj/item/kitchen/rollingpin/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/kitchen/rollingpin/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins flattening [user.p_their()] head with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS
