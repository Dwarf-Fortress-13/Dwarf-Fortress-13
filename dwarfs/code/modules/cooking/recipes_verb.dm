/mob/living/carbon/human/verb/recipes()
	set name = "📘 Cooking Recipes"
	set category = "IC"
	set desc = "View your character's known recipes."
	if(mind)
		mind.show_recipes(src)
	else
		to_chat(src, "You don't have a mind datum for some reason, so you can't look at your recipes, if you had any.")

/datum/mind/proc/show_recipes(mob/user)
	if(!user)
		user = current

	var/datum/skill/S = user.get_skill(/datum/skill/cooking)
	var/skill_level = S ? S.level : 1
	var/text = ""
	text += "<center><b>Cooking Recipes</b></center>"
	for(var/t in GLOB.cooking_recipes)
		var/datum/cooking_recipe/recipe = GLOB.cooking_recipes[t]
		var/recipe_name = initial(recipe.result.name)
		if(recipe.req_lvl <= skill_level)
			var/image_path = icon2path(initial(recipe.result.icon), user, initial(recipe.result.icon_state))
			text += "<br><font color=green><img src=[image_path]>[recipe_name]:</font>"
			for(var/item in recipe.req_items)
				var/obj/item/I = item
				text += "<br>[FOURSPACES][recipe.req_items[item]] [initial(I.name)]"
			for(var/reag in recipe.req_reagents)
				var/datum/reagent/R = reag
				text += "<br>[FOURSPACES][recipe.req_reagents[reag]] [initial(R.name)]"
			text += "<br>[FOURSPACES][recipe.cooking_text]"
			text += "<br>"
	var/datum/browser/recipe_window = new(user, "recipe_window")
	recipe_window.set_content(text)
	recipe_window.add_stylesheet("font-awesome", 'html/font-awesome/css/all.min.css') //TODO: add custom stylesheet
	recipe_window.width = 500
	recipe_window.height = 300
	recipe_window.title = "Known Recipes"
	recipe_window.open(FALSE)
