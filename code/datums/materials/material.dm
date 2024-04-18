#define TOOLSPEED_MIN_VALUE 0.1
#define MELEE_CD_MIN_VALUE 0.1
#define SLOWDOWN_MIN_RELATIVE_VALUE -0.1

/datum/material
	/// Material name. Displayed in examine etc.
	var/name = "material"
	/// Palettes used. Used as icon_states for it's palette at 'dwarfs/icons/palettes.dmi'. Depending on amount of materials will use template palettes in increasing order.
	var/list/palettes = list("template1")
	/// What material type this is
	var/mat
	/// What default raw resource type does this material have
	var/resource
	/// What default refined resource type does this material have
	var/resource_refined
	/// What floor is made out of this material
	var/floor_type
	/// What wall is made out of this material
	var/wall_type
	/// What door is made out of this material
	var/door_type
	/// Force multipliers. Refular force mod represents material "hardness" and how well it does as a blade etc. force_mod_blunt is multiplied on top if the weapon is blunt type to simulate material mass
	/// Force multiplier
	var/force_mod = 1
	/// Force multiplier if weapon is blunt type
	var/force_mod_blunt = 1
	/// Tool speed multiplier
	var/toolspeed_mod = 1
	var/toolspeed_mod_handle = 1
	/// Health multiplier for structures
	var/integrity_mod = 1
	var/integrity_mod_handle = 1
	/// Click cd cooldown multiplier
	var/melee_cd_mod = 1
	var/melee_cd_mod_handle = 1
	/// Slowdown modifier (additive). Remember that negative values speed up
	var/slowdown_mod = 0
	var/slowdown_mod_handle = 0
	/// Mining speed and efficiecy
	var/hardness = 1

	// Armor multipliers
	var/armor_sharp_mod = 1
	var/armor_pierce_mod = 1
	var/armor_blunt_mod = 1
	var/armor_fire_mod = 1
	var/armor_acid_mod = 1
	var/armor_magic_mod = 1
	var/armor_wound_mod = 1
	// Armor penetration multipliers
	var/armorpen_sharp_mod = 1
	var/armorpen_pierce_mod = 1
	var/armorpen_blunt_mod = 1
	var/armorpen_fire_mod = 1
	var/armorpen_acid_mod = 1
	var/armorpen_magic_mod = 1

/**
 * Applies stat modifiers a given material has to an obj
 *
 * Argumens:
 * - O: The obj we are applying this material to.
 */
/datum/material/proc/apply_stats(atom/A, part_name=null)
	var/obj/O = isobj(A) ? A : null
	var/obj/item/I = isitem(A) ? A : null
	switch(part_name)
		if(PART_HANDLE)
			if(O)
				O.obj_integrity *= integrity_mod_handle
				O.max_integrity *= integrity_mod_handle
			if(I)
				I.toolspeed = max(I.toolspeed * toolspeed_mod_handle, TOOLSPEED_MIN_VALUE)
				I.melee_cd = max(I.melee_cd * melee_cd_mod_handle, MELEE_CD_MIN_VALUE)
				I.slowdown = max(I.slowdown+slowdown_mod_handle, initial(I.slowdown)+SLOWDOWN_MIN_RELATIVE_VALUE)
		if(PART_HEAD)
			if(O)
				O.force *= force_mod
				if(O.atck_type == BLUNT)
					O.force *= force_mod_blunt
				O.obj_integrity *= integrity_mod
				O.max_integrity *= integrity_mod
				O.hardness = hardness
			if(I)
				if(I.armor_penetration)
					I.armor_penetration.modify_rating(SHARP, armorpen_sharp_mod)
					I.armor_penetration.modify_rating(PIERCE, armorpen_pierce_mod)
					I.armor_penetration.modify_rating(BLUNT, armorpen_blunt_mod)
					I.armor_penetration.modify_rating(FIRE, armorpen_fire_mod)
					I.armor_penetration.modify_rating(ACID, armorpen_acid_mod)
					I.armor_penetration.modify_rating(MAGIC, armorpen_magic_mod)
				I.toolspeed = max(I.toolspeed * toolspeed_mod, TOOLSPEED_MIN_VALUE)
				I.melee_cd = max(I.melee_cd * melee_cd_mod, MELEE_CD_MIN_VALUE)
				I.slowdown = max(I.slowdown+slowdown_mod, initial(I.slowdown)+SLOWDOWN_MIN_RELATIVE_VALUE)
		else
			if(O)
				O.force *= force_mod
				if(O.atck_type == BLUNT)
					O.force *= force_mod_blunt
				O.obj_integrity *= integrity_mod
				O.max_integrity *= integrity_mod
				O.hardness = max(O.hardness, hardness)
				if(O.armor)
					O.armor = O.armor.modify_rating(armor_sharp_mod, armor_pierce_mod, armor_blunt_mod, armor_fire_mod, armor_acid_mod, armor_magic_mod, armor_wound_mod)
			if(I)
				I.toolspeed = max(I.toolspeed * toolspeed_mod, TOOLSPEED_MIN_VALUE)
				I.melee_cd = max(I.melee_cd * melee_cd_mod, MELEE_CD_MIN_VALUE)
				I.slowdown = max(I.slowdown+slowdown_mod, initial(I.slowdown)+SLOWDOWN_MIN_RELATIVE_VALUE)
				if(I.armor_penetration)
					I.armor_penetration.modify_rating(SHARP, armorpen_sharp_mod)
					I.armor_penetration.modify_rating(PIERCE, armorpen_pierce_mod)
					I.armor_penetration.modify_rating(BLUNT, armorpen_blunt_mod)
					I.armor_penetration.modify_rating(FIRE, armorpen_fire_mod)
					I.armor_penetration.modify_rating(ACID, armorpen_acid_mod)
					I.armor_penetration.modify_rating(MAGIC, armorpen_magic_mod)

/datum/material/proc/apply2icon_default(icon/I, _i=0)
	for(var/i in 1 to palettes.len)
		I = apply_palette(I, "template[i+_i]", palettes[i])
	return I

/**
 * Applies palette to given template for an icon
 *
 * Argumens:
 * - I: The icon we are working with.
 * - template_name: icon_state of the template we are replacing.
 * - palette_name: icon_state of the material we want to apply. This defaults to the first element of this material.
 */
/datum/material/proc/apply_palette(icon/I, template_name, palette_name=null)
	palette_name = palette_name ? palette_name : palettes[1]
	. = I
	var/icon/template_palette = SSmaterials.palettes[template_name]
	var/icon/material_palette = SSmaterials.palettes[palette_name]

	for(var/x in 1 to 9)
		var/color_old = template_palette.GetPixel(x, 1)
		var/color_new = material_palette.GetPixel(x, 1)
		I.SwapColor(color_old, color_new)

/**
 * Applies materials with given palettes to an icon
 *
 * Argumens:
 * - I: The icon we are working with.
 * - materials: list of material types. Place the types in the correct oder according to what templates will be used.
 */
/proc/apply_palettes(icon/I, list/materials)
	if(!I)
		CRASH("Called apply_palettes with a null icon.")
	if(!materials)
		return I
	if(!islist(materials))
		materials = list(materials)
	for(var/i in 1 to materials.len)
		var/mat_type = materials[i]
		if(istext(mat_type))
			mat_type = materials[mat_type]
		var/datum/material/M = SSmaterials.materials[mat_type]
		if(!M)
			continue
		I = M.apply2icon_default(I, i-1)
	return I

// iron is a baseline material, good in every way
/datum/material/iron
	name = "iron"
	palettes = list("iron")
	mat = MATERIAL_METAL
	resource = /obj/item/stack/ore/smeltable/iron
	resource_refined = /obj/item/ingot

	hardness = 4

/datum/material/pig_iron
	name = "pig iron"
	palettes = list("black_iron")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot

	force_mod = 0.7
	force_mod_blunt = 0.9
	toolspeed_mod = 1.15
	toolspeed_mod_handle = 1.1
	integrity_mod = 1.1
	integrity_mod_handle = 0.9
	melee_cd_mod = 1.2
	melee_cd_mod_handle = 1.1
	hardness = 3

	armor_sharp_mod = 0.6
	armor_pierce_mod = 0.4
	armor_blunt_mod = 0.5
	armorpen_sharp_mod = 0.75
	armorpen_pierce_mod = 0.75
	armorpen_blunt_mod = 0.75

/datum/material/steel
	name = "steel"
	palettes = list("steel")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot

	force_mod = 1.35
	force_mod_blunt = 1.5
	toolspeed_mod = 0.8
	toolspeed_mod_handle = 0.9
	integrity_mod = 1.4
	integrity_mod_handle = 1.15
	melee_cd_mod = 1.2
	melee_cd_mod_handle = 1.1
	hardness = 5

	armor_sharp_mod = 1.2
	armor_pierce_mod = 1.2
	armor_blunt_mod = 1.2
	armorpen_sharp_mod = 1.3
	armorpen_pierce_mod = 1.5
	armorpen_blunt_mod = 1.3

/datum/material/silver
	name = "silver"
	palettes = list("silver")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot
	resource = /obj/item/stack/ore/smeltable/silver

	force_mod = 0.65
	force_mod_blunt = 1.2
	toolspeed_mod = 1.15
	melee_cd_mod = 0.8
	melee_cd_mod_handle = 1
	slowdown_mod = 0.1
	hardness = 2

	armor_sharp_mod = 0.9
	armor_pierce_mod = 0.9
	armor_blunt_mod = 0.9

/datum/material/lead
	name = "lead"
	palettes = list("lead")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot
	resource = /obj/item/stack/ore/smeltable/galena

	force_mod = 0.7
	force_mod_blunt = 1.1
	toolspeed_mod = 1.2
	toolspeed_mod_handle = 1
	integrity_mod = 1.6
	integrity_mod_handle = 1.3
	melee_cd_mod = 1.4
	melee_cd_mod_handle = 1.25
	slowdown_mod = 0.2
	hardness = 2

	armorpen_sharp_mod = 0.75
	armorpen_pierce_mod = 0.75
	armorpen_blunt_mod = 1.1

/datum/material/platinum
	name = "platinum"
	palettes = list("platinum")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot
	resource = /obj/item/stack/ore/smeltable/platinum

	force_mod = 0.9
	force_mod_blunt = 1.75
	toolspeed_mod = 1.35
	toolspeed_mod_handle = 1.2
	integrity_mod = 1.75
	integrity_mod_handle = 1.45
	melee_cd_mod = 1.65
	melee_cd_mod_handle = 1.25
	slowdown_mod = 0.4
	slowdown_mod_handle = 0.2
	hardness = 3

	armor_sharp_mod = 1.55
	armor_pierce_mod = 1.1
	armor_blunt_mod = 1.55
	armorpen_blunt_mod = 1.5

/datum/material/tin
	name = "tin"
	palettes = list("tin")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot
	resource = /obj/item/stack/ore/smeltable/cassiterite

	force_mod = 0.75
	force_mod_blunt = 0.9
	integrity_mod = 0.8
	integrity_mod_handle = 0.8
	melee_cd_mod = 0.9
	melee_cd_mod_handle = 0.9
	hardness = 1

	armor_sharp_mod = 0.6
	armor_pierce_mod = 0.5
	armor_blunt_mod = 0.4
	armorpen_sharp_mod = 0.75
	armorpen_pierce_mod = 0.75
	armorpen_blunt_mod = 0.75

/datum/material/aluminum
	name = "aluminum"
	palettes = list("aluminum")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot
	resource = /obj/item/stack/ore/smeltable/aluminum

	force_mod = 0.65
	force_mod_blunt = 0.45
	toolspeed_mod = 0.65
	toolspeed_mod_handle = 0.85
	integrity_mod = 0.65
	integrity_mod_handle = 0.65
	melee_cd_mod = 0.5
	melee_cd_mod_handle = 0.9
	slowdown_mod = -0.2
	hardness = 2

	armor_sharp_mod = 0.5
	armor_pierce_mod = 0.5
	armor_blunt_mod = 0.5
	armor_fire_mod = 0.75
	armor_acid_mod = 0.5
	armor_magic_mod = 0.5
	armor_wound_mod = 0
	armorpen_sharp_mod = 0.5
	armorpen_pierce_mod = 0.5
	armorpen_blunt_mod = 0.5

/datum/material/adamantine
	name = "adamantine"
	palettes = list("adamantine")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot
	resource = /obj/item/stack/ore/smeltable/adamantine

	force_mod = 1.8
	force_mod_blunt = 0.5
	toolspeed_mod = 0.35
	toolspeed_mod_handle = 0.9
	integrity_mod = 2
	integrity_mod_handle = 2
	melee_cd_mod = 0.6
	melee_cd_mod_handle = 0.85
	slowdown_mod = -0.5
	slowdown_mod_handle = -0.3
	hardness = 6

	armor_sharp_mod = 2
	armor_pierce_mod = 2
	armor_blunt_mod = 1.25
	armor_fire_mod = 2
	armor_acid_mod = 2
	armor_magic_mod = 2
	armor_wound_mod = 2
	armorpen_sharp_mod = 1.5
	armorpen_pierce_mod = 1.5
	armorpen_blunt_mod = 1
	armorpen_magic_mod = 1.5

/datum/material/bronze
	name = "bronze"
	palettes = list("bronze")
	mat = MATERIAL_METAL
	resource_refined = /obj/item/ingot

	force_mod = 0.9
	force_mod_blunt = 0.95
	toolspeed_mod = 0.9
	melee_cd_mod = 0.9
	hardness = 3

	armor_sharp_mod = 0.9
	armor_pierce_mod = 0.9
	armor_blunt_mod = 0.9
	armorpen_sharp_mod = 0.95
	armorpen_pierce_mod = 0.95
	armorpen_blunt_mod = 0.95

/datum/material/copper
	name = "copper"
	palettes = list("copper")
	mat = MATERIAL_METAL
	resource = /obj/item/stack/ore/smeltable/copper
	resource_refined = /obj/item/ingot

	force_mod = 0.85
	force_mod_blunt = 1
	toolspeed_mod = 0.9
	toolspeed_mod_handle = 1.1
	integrity_mod = 0.7
	integrity_mod_handle = 0.9
	hardness = 1

	armor_sharp_mod = 0.6
	armor_pierce_mod = 0.4
	armor_blunt_mod = 0.5
	armorpen_sharp_mod = 0.5
	armorpen_pierce_mod = 0.5
	armorpen_blunt_mod = 1.1
	armorpen_acid_mod = 0.8

/datum/material/gold
	name = "gold"
	palettes = list("gold")
	mat = MATERIAL_METAL
	resource = /obj/item/stack/ore/smeltable/gold
	resource_refined = /obj/item/ingot

	force_mod = 0.55
	force_mod_blunt = 1.6
	toolspeed_mod = 1.1
	toolspeed_mod_handle = 1.1
	integrity_mod = 0.7
	integrity_mod_handle = 0.9
	melee_cd_mod = 1.2
	melee_cd_mod_handle = 1.1
	slowdown_mod = 0.3
	slowdown_mod_handle = 0.1
	hardness = 1

	armor_sharp_mod = 0.6
	armor_pierce_mod = 0.4
	armor_blunt_mod = 0.3
	armorpen_sharp_mod = 0.5
	armorpen_pierce_mod = 0.5
	armorpen_blunt_mod = 1.2
	armorpen_acid_mod = 1.35

/datum/material/wood
	mat = MATERIAL_WOOD
	resource = /obj/item/log
	resource_refined = /obj/item/stack/sheet/planks
	var/treated_type
	floor_type = /turf/open/floor/wooden
	wall_type = /turf/closed/wall/wooden
	door_type = /obj/structure/mineral_door/material

// any wood treated with tannin
/datum/material/wood/treated
	name = "treated wood"
	palettes = list("wood_treated")
	resource = null

	force_mod = 0.55
	force_mod_blunt = 0.8
	toolspeed_mod = 0.5
	toolspeed_mod_handle = 0.9
	integrity_mod = 0.75
	melee_cd_mod = 0.8
	melee_cd_mod_handle = 0.8
	slowdown_mod = -0.3
	slowdown_mod_handle = -0.1

	armor_sharp_mod = 0.15
	armor_pierce_mod = 0.3
	armor_blunt_mod = 0.05
	armor_fire_mod = 0.25
	armor_acid_mod = 0
	armorpen_sharp_mod = 0.55
	armorpen_pierce_mod = 0.4
	armorpen_blunt_mod = 0.3
	armorpen_fire_mod = 0
	armorpen_acid_mod = 0
	armorpen_magic_mod = 0

/datum/material/wood/towercap
	name = "towercap wood"
	palettes = list("towercap", "towercap_inside")
	treated_type = /datum/material/wood/towercap/treated

	force_mod = 0.5
	force_mod_blunt = 0.7
	toolspeed_mod = 0.5
	toolspeed_mod_handle = 1
	integrity_mod = 0.6
	integrity_mod_handle = 0.8
	melee_cd_mod = 0.8
	melee_cd_mod_handle = 0.9
	slowdown_mod = -0.3
	slowdown_mod_handle = -0.1

	armor_sharp_mod = 0.3
	armor_pierce_mod = 0.3
	armor_blunt_mod = 0.3
	armor_fire_mod = 0
	armor_acid_mod = 0
	armorpen_sharp_mod = 0.5
	armorpen_pierce_mod = 0.4
	armorpen_blunt_mod = 0.3
	armorpen_fire_mod = 0
	armorpen_acid_mod = 0

/datum/material/wood/towercap/treated
	palettes = list("towercap_inside")

/datum/material/wood/apple
	name = "apple wood"
	palettes = list("apple", "apple_inside")
	treated_type = /datum/material/wood/apple/treated

	force_mod = 0.5
	force_mod_blunt = 0.75
	toolspeed_mod = 0.5
	toolspeed_mod_handle = 1
	integrity_mod = 0.6
	integrity_mod_handle = 0.8
	melee_cd_mod = 0.8
	melee_cd_mod_handle = 0.9
	slowdown_mod = -0.3
	slowdown_mod_handle = -0.1

	armor_sharp_mod = 0.3
	armor_pierce_mod = 0.3
	armor_blunt_mod = 0.3
	armor_fire_mod = 0
	armor_acid_mod = 0
	armorpen_sharp_mod = 0.5
	armorpen_pierce_mod = 0.4
	armorpen_blunt_mod = 0.3
	armorpen_fire_mod = 0
	armorpen_acid_mod = 0

/datum/material/wood/apple/treated
	palettes = list("apple_inside")

/datum/material/wood/pine
	name = "pine wood"
	palettes = list("pine", "pine_inside")
	treated_type = /datum/material/wood/pine/treated

	force_mod = 0.5
	force_mod_blunt = 0.75
	toolspeed_mod = 0.5
	toolspeed_mod_handle = 1
	integrity_mod = 0.6
	integrity_mod_handle = 0.8
	melee_cd_mod = 0.8
	melee_cd_mod_handle = 0.9
	slowdown_mod = -0.3
	slowdown_mod_handle = -0.1

	armor_sharp_mod = 0.3
	armor_pierce_mod = 0.3
	armor_blunt_mod = 0.3
	armor_fire_mod = 0
	armor_acid_mod = 0
	armorpen_sharp_mod = 0.5
	armorpen_pierce_mod = 0.4
	armorpen_blunt_mod = 0.3
	armorpen_fire_mod = 0
	armorpen_acid_mod = 0

/datum/material/wood/pine/treated
	palettes = list("pine_inside")

/datum/material/stone
	name = "stone"
	palettes = list("soapstone")
	mat = MATERIAL_STONE
	resource = /obj/item/stack/ore/stone/stone
	resource_refined = /obj/item/stack/sheet/stone
	wall_type = /turf/closed/wall/stone
	door_type = /obj/structure/mineral_door/material

/datum/material/sandstone
	name = "sandstone"
	palettes = list("sand")
	mat = MATERIAL_STONE
	resource = /obj/item/stack/ore/stone/sand
	resource_refined = /obj/item/stack/glass
	wall_type = /turf/closed/wall/stone
	door_type = /obj/structure/mineral_door/material

/datum/material/cloth
	palettes = list("cloth")
	resource = /obj/item/stack/sheet/cloth
	resource_refined = /obj/item/stack/sheet/cloth

/datum/material/cloth/silk
	name = "spider silk"

/datum/material/cloth/cotton
	name = "cotton"

/datum/material/cloth/pig_tail_cotton
	name = "pig tail cotton"

/datum/material/leather
	name = "leather"
	// nothing else, it's just a cosmetic material

#undef TOOLSPEED_MIN_VALUE
#undef MELEE_CD_MIN_VALUE
#undef SLOWDOWN_MIN_RELATIVE_VALUE
