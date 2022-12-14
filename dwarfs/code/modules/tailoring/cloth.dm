/obj/item/stack/sheet/cloth
	name = "cloth"
	desc = "A piece of fabric. Can be made into clothing."
	singular_name = "piece of fabric"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "cloth"
	w_class = WEIGHT_CLASS_NORMAL

GLOBAL_LIST_INIT(cloth_recipes, list(
	new/datum/stack_recipe("Dwarf Tunic", /obj/item/clothing/under/tunic/random, 6, time=15 SECONDS),
	new/datum/stack_recipe("Boots", /obj/item/clothing/shoes/boots, 3, time=10 SECONDS),
	new/datum/stack_recipe("Stitched Casing", /obj/item/food/intestines/stitched_casing, 2, time=5 SECONDS)
))

/obj/item/stack/sheet/cloth/get_main_recipes()
	. = ..()
	. += GLOB.cloth_recipes

/obj/item/stack/sheet/cloth/get_fuel()
	return amount*2

/obj/item/stack/sheet/string
	name = "yarn string"
	desc = "Long strings of fibers rolled into a ball. Processen in loom into fabric."
	singular_name = "string"
	icon = 'dwarfs/icons/items/components.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "string"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/stack/sheet/string/get_fuel()
	return amount
