//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)

/datum/asset/simple/radar_assets
	assets = list(
		"ntosradarbackground.png" = 'icons/UI_Icons/tgui/ntosradar_background.png',
		"ntosradarpointer.png" = 'icons/UI_Icons/tgui/ntosradar_pointer.png',
		"ntosradarpointerS.png" = 'icons/UI_Icons/tgui/ntosradar_pointer_S.png'
	)

/datum/asset/simple/circuit_assets
	assets = list(
		"grid_background.png" = 'icons/UI_Icons/tgui/grid_background.png'
	)

/datum/asset/simple/irv
	assets = list(
		"jquery-ui.custom-core-widgit-mouse-sortable-min.js" = 'html/IRV/jquery-ui.custom-core-widgit-mouse-sortable-min.js',
	)

/datum/asset/group/irv
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/irv
	)

/datum/asset/simple/namespaced/changelog
	assets = list(
		"88x31.png" = 'html/88x31.png',
		"bug-minus.png" = 'html/bug-minus.png',
		"cross-circle.png" = 'html/cross-circle.png',
		"hard-hat-exclamation.png" = 'html/hard-hat-exclamation.png',
		"image-minus.png" = 'html/image-minus.png',
		"image-plus.png" = 'html/image-plus.png',
		"music-minus.png" = 'html/music-minus.png',
		"music-plus.png" = 'html/music-plus.png',
		"tick-circle.png" = 'html/tick-circle.png',
		"wrench-screwdriver.png" = 'html/wrench-screwdriver.png',
		"spell-check.png" = 'html/spell-check.png',
		"burn-exclamation.png" = 'html/burn-exclamation.png',
		"chevron.png" = 'html/chevron.png',
		"chevron-expand.png" = 'html/chevron-expand.png',
		"scales.png" = 'html/scales.png',
		"coding.png" = 'html/coding.png',
		"ban.png" = 'html/ban.png',
		"chrome-wrench.png" = 'html/chrome-wrench.png',
		"changelog.css" = 'html/changelog.css'
	)
	parents = list("changelog.html" = 'html/changelog.html')


/datum/asset/simple/statbrowser
	legacy = TRUE
	assets = list(
		"statbrowser-status.png" = 'html/statbrowser/status.png',
		"statbrowser-ic.png" = 'html/statbrowser/ic.png',
		"statbrowser-ooc.png" = 'html/statbrowser/ooc.png',
		"statbrowser-cog.png" = 'html/statbrowser/cog.png',
		"statbrowser-obj.png" = 'html/statbrowser/obj.png',
		"statbrowser-other.png" = 'html/statbrowser/other.png',
		"statbrowser-ghost.png" = 'html/statbrowser/ghost.png',
		"statbrowser-admin.png" = 'html/statbrowser/admin.png',
		"statbrowser-debug.png" = 'html/statbrowser/debug.png',
		"statbrowser-mc.png" = 'html/statbrowser/mc.png',
		"statbrowser-tickets.png" = 'html/statbrowser/tickets.png',
		"statbrowser-mc.png" = 'html/statbrowser/mc.png',
		"statbrowser-magic.png" = 'html/statbrowser/magic.png',
		"statbrowser-other.png" = 'html/statbrowser/other.png',
	)

/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'html/jquery.min.js',
	)

/datum/asset/simple/namespaced/fontawesome
	assets = list(
		"fa-regular-400.eot"  = 'html/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'html/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'html/font-awesome/webfonts/fa-solid-900.woff',
		"v4shim.css"          = 'html/font-awesome/css/v4-shims.min.css'
	)
	parents = list("font-awesome.css" = 'html/font-awesome/css/all.min.css')

/datum/asset/simple/namespaced/tgfont
	assets = list(
		"tgfont.eot" = file("tgui/packages/tgfont/static/tgfont.eot"),
		"tgfont.woff2" = file("tgui/packages/tgfont/static/tgfont.woff2"),
	)
	parents = list(
		"tgfont.css" = file("tgui/packages/tgfont/static/tgfont.css"),
	)

/datum/asset/spritesheet/chat
	name = "chat"

/datum/asset/spritesheet/chat/register()
	InsertAll("emoji", EMOJI_SET)
	// pre-loading all lanugage icons also helps to avoid meta
	InsertAll("language", 'icons/misc/language.dmi')
	// catch languages which are pulling icons from another file
	for(var/path in typesof(/datum/language))
		var/datum/language/L = path
		var/icon = initial(L.icon)
		if (icon != 'icons/misc/language.dmi')
			var/icon_state = initial(L.icon_state)
			Insert("language-[icon_state]", icon, icon_state=icon_state)
	..()

/datum/asset/simple/lobby
	assets = list(
		"playeroptions.css" = 'html/browser/playeroptions.css'
	)

/datum/asset/simple/namespaced/common
	assets = list("padlock.png"	= 'html/padlock.png')
	parents = list("common.css" = 'html/browser/common.css')

/datum/asset/simple/permissions
	assets = list(
		"search.js" = 'html/admin/search.js',
		"panels.css" = 'html/admin/panels.css'
	)

/datum/asset/group/permissions
	children = list(
		/datum/asset/simple/permissions,
		/datum/asset/simple/namespaced/common
	)

/datum/asset/simple/notes
	assets = list(
		"high_button.png" = 'html/high_button.png',
		"medium_button.png" = 'html/medium_button.png',
		"minor_button.png" = 'html/minor_button.png',
		"none_button.png" = 'html/none_button.png',
	)

/datum/asset/simple/arcade
	assets = list(
		"boss1.gif" = 'icons/UI_Icons/Arcade/boss1.gif',
		"boss2.gif" = 'icons/UI_Icons/Arcade/boss2.gif',
		"boss3.gif" = 'icons/UI_Icons/Arcade/boss3.gif',
		"boss4.gif" = 'icons/UI_Icons/Arcade/boss4.gif',
		"boss5.gif" = 'icons/UI_Icons/Arcade/boss5.gif',
		"boss6.gif" = 'icons/UI_Icons/Arcade/boss6.gif',
	)

/datum/asset/spritesheet/simple/achievements
	name ="achievements"
	assets = list(
		"default" = 'icons/UI_Icons/Achievements/default.png',
		"basemisc" = 'icons/UI_Icons/Achievements/basemisc.png',
		"baseboss" = 'icons/UI_Icons/Achievements/baseboss.png',
		"baseskill" = 'icons/UI_Icons/Achievements/baseskill.png',
		"bbgum" = 'icons/UI_Icons/Achievements/Boss/bbgum.png',
		"colossus" = 'icons/UI_Icons/Achievements/Boss/colossus.png',
		"hierophant" = 'icons/UI_Icons/Achievements/Boss/hierophant.png',
		"legion" = 'icons/UI_Icons/Achievements/Boss/legion.png',
		"miner" = 'icons/UI_Icons/Achievements/Boss/miner.png',
		"swarmer" = 'icons/UI_Icons/Achievements/Boss/swarmer.png',
		"tendril" = 'icons/UI_Icons/Achievements/Boss/tendril.png',
		"featofstrength" = 'icons/UI_Icons/Achievements/Misc/featofstrength.png',
		"helbital" = 'icons/UI_Icons/Achievements/Misc/helbital.png',
		"jackpot" = 'icons/UI_Icons/Achievements/Misc/jackpot.png',
		"meteors" = 'icons/UI_Icons/Achievements/Misc/meteors.png',
		"timewaste" = 'icons/UI_Icons/Achievements/Misc/timewaste.png',
		"upgrade" = 'icons/UI_Icons/Achievements/Misc/upgrade.png',
		"clownking" = 'icons/UI_Icons/Achievements/Misc/clownking.png',
		"clownthanks" = 'icons/UI_Icons/Achievements/Misc/clownthanks.png',
		"rule8" = 'icons/UI_Icons/Achievements/Misc/rule8.png',
		"snail" = 'icons/UI_Icons/Achievements/Misc/snail.png',
		"ascension" = 'icons/UI_Icons/Achievements/Misc/ascension.png',
		"ashascend" = 'icons/UI_Icons/Achievements/Misc/ashascend.png',
		"fleshascend" = 'icons/UI_Icons/Achievements/Misc/fleshascend.png',
		"rustascend" = 'icons/UI_Icons/Achievements/Misc/rustascend.png',
		"voidascend" = 'icons/UI_Icons/Achievements/Misc/voidascend.png',
		"mining" = 'icons/UI_Icons/Achievements/Skills/mining.png',
		"assistant" = 'icons/UI_Icons/Achievements/Mafia/assistant.png',
		"changeling" = 'icons/UI_Icons/Achievements/Mafia/changeling.png',
		"chaplain" = 'icons/UI_Icons/Achievements/Mafia/chaplain.png',
		"clown" = 'icons/UI_Icons/Achievements/Mafia/clown.png',
		"detective" = 'icons/UI_Icons/Achievements/Mafia/detective.png',
		"fugitive" = 'icons/UI_Icons/Achievements/Mafia/fugitive.png',
		"hated" = 'icons/UI_Icons/Achievements/Mafia/hated.png',
		"hop" = 'icons/UI_Icons/Achievements/Mafia/hop.png',
		"lawyer" = 'icons/UI_Icons/Achievements/Mafia/lawyer.png',
		"md" = 'icons/UI_Icons/Achievements/Mafia/md.png',
		"nightmare" = 'icons/UI_Icons/Achievements/Mafia/nightmare.png',
		"obsessed" = 'icons/UI_Icons/Achievements/Mafia/obsessed.png',
		"psychologist" = 'icons/UI_Icons/Achievements/Mafia/psychologist.png',
		"thoughtfeeder" = 'icons/UI_Icons/Achievements/Mafia/thoughtfeeder.png',
		"traitor" = 'icons/UI_Icons/Achievements/Mafia/traitor.png',
		"basemafia" ='icons/UI_Icons/Achievements/basemafia.png',
		"frenching" = 'icons/UI_Icons/Achievements/Misc/frenchingthebubble.png'
	)

/datum/asset/spritesheet/simple/pills
	name = "pills"
	assets = list(
		"pill1" = 'icons/UI_Icons/Pills/pill1.png',
		"pill2" = 'icons/UI_Icons/Pills/pill2.png',
		"pill3" = 'icons/UI_Icons/Pills/pill3.png',
		"pill4" = 'icons/UI_Icons/Pills/pill4.png',
		"pill5" = 'icons/UI_Icons/Pills/pill5.png',
		"pill6" = 'icons/UI_Icons/Pills/pill6.png',
		"pill7" = 'icons/UI_Icons/Pills/pill7.png',
		"pill8" = 'icons/UI_Icons/Pills/pill8.png',
		"pill9" = 'icons/UI_Icons/Pills/pill9.png',
		"pill10" = 'icons/UI_Icons/Pills/pill10.png',
		"pill11" = 'icons/UI_Icons/Pills/pill11.png',
		"pill12" = 'icons/UI_Icons/Pills/pill12.png',
		"pill13" = 'icons/UI_Icons/Pills/pill13.png',
		"pill14" = 'icons/UI_Icons/Pills/pill14.png',
		"pill15" = 'icons/UI_Icons/Pills/pill15.png',
		"pill16" = 'icons/UI_Icons/Pills/pill16.png',
		"pill17" = 'icons/UI_Icons/Pills/pill17.png',
		"pill18" = 'icons/UI_Icons/Pills/pill18.png',
		"pill19" = 'icons/UI_Icons/Pills/pill19.png',
		"pill20" = 'icons/UI_Icons/Pills/pill20.png',
		"pill21" = 'icons/UI_Icons/Pills/pill21.png',
		"pill22" = 'icons/UI_Icons/Pills/pill22.png',
	)

/datum/asset/spritesheet/simple/condiments
	name = "condiments"
	assets = list(
		CONDIMASTER_STYLE_FALLBACK = 'icons/UI_Icons/Condiments/emptycondiment.png',
		"enzyme" = 'icons/UI_Icons/Condiments/enzyme.png',
		"flour" = 'icons/UI_Icons/Condiments/flour.png',
		"mayonnaise" = 'icons/UI_Icons/Condiments/mayonnaise.png',
		"milk" = 'icons/UI_Icons/Condiments/milk.png',
		"blackpepper" = 'icons/UI_Icons/Condiments/peppermillsmall.png',
		"rice" = 'icons/UI_Icons/Condiments/rice.png',
		"sodiumchloride" = 'icons/UI_Icons/Condiments/saltshakersmall.png',
		"soymilk" = 'icons/UI_Icons/Condiments/soymilk.png',
		"soysauce" = 'icons/UI_Icons/Condiments/soysauce.png',
		"sugar" = 'icons/UI_Icons/Condiments/sugar.png',
		"ketchup" = 'icons/UI_Icons/Condiments/ketchup.png',
		"capsaicin" = 'icons/UI_Icons/Condiments/hotsauce.png',
		"frostoil" = 'icons/UI_Icons/Condiments/coldsauce.png',
		"bbqsauce" = 'icons/UI_Icons/Condiments/bbqsauce.png',
		"cornoil" = 'icons/UI_Icons/Condiments/oliveoil.png',
	)

//this exists purely to avoid meta by pre-loading all language icons.
/datum/asset/language/register()
	for(var/path in typesof(/datum/language))
		set waitfor = FALSE
		var/datum/language/L = new path ()
		L.get_icon()

/datum/asset/simple/inventory
	assets = list(
		"inventory-glasses.png" = 'icons/UI_Icons/inventory/glasses.png',
		"inventory-head.png" = 'icons/UI_Icons/inventory/head.png',
		"inventory-neck.png" = 'icons/UI_Icons/inventory/neck.png',
		"inventory-mask.png" = 'icons/UI_Icons/inventory/mask.png',
		"inventory-ears.png" = 'icons/UI_Icons/inventory/ears.png',
		"inventory-uniform.png" = 'icons/UI_Icons/inventory/uniform.png',
		"inventory-suit.png" = 'icons/UI_Icons/inventory/suit.png',
		"inventory-gloves.png" = 'icons/UI_Icons/inventory/gloves.png',
		"inventory-hand_l.png" = 'icons/UI_Icons/inventory/hand_l.png',
		"inventory-hand_r.png" = 'icons/UI_Icons/inventory/hand_r.png',
		"inventory-shoes.png" = 'icons/UI_Icons/inventory/shoes.png',
		"inventory-suit_storage.png" = 'icons/UI_Icons/inventory/suit_storage.png',
		"inventory-id.png" = 'icons/UI_Icons/inventory/id.png',
		"inventory-belt.png" = 'icons/UI_Icons/inventory/belt.png',
		"inventory-back.png" = 'icons/UI_Icons/inventory/back.png',
		"inventory-pocket.png" = 'icons/UI_Icons/inventory/pocket.png',
		"inventory-collar.png" = 'icons/UI_Icons/inventory/collar.png',
	)

/datum/asset/simple/genetics
	assets = list(
		"dna_discovered.gif" = 'html/dna_discovered.gif',
		"dna_undiscovered.gif" = 'html/dna_undiscovered.gif',
		"dna_extra.gif" = 'html/dna_extra.gif'
	)

/datum/asset/simple/orbit
	assets = list(
		"ghost.png"	= 'html/ghost.png'
	)

/datum/asset/simple/vv
	assets = list(
		"view_variables.css" = 'html/admin/view_variables.css'
	)

/datum/asset/spritesheet/sheetmaterials
	name = "sheetmaterials"

/datum/asset/spritesheet/sheetmaterials/register()
	InsertAll("", 'icons/obj/stack_objects.dmi')
	..()

/datum/asset/simple/safe
	assets = list(
		"safe_dial.png" = 'html/safe_dial.png'
	)

/datum/asset/simple/tutorial_advisors
	assets = list(
		"chem_help_advisor.gif" = 'icons/UI_Icons/Advisors/chem_help_advisor.gif',
	)

/datum/asset/simple/contracts
	assets = list(
		"bluespace.png" = 'icons/UI_Icons/contracts/bluespace.png',
		"destruction.png" = 'icons/UI_Icons/contracts/destruction.png',
		"healing.png" = 'icons/UI_Icons/contracts/healing.png',
		"robeless.png" = 'icons/UI_Icons/contracts/robeless.png',
	)

/// Removes all non-alphanumerics from the text, keep in mind this can lead to id conflicts
/proc/sanitize_css_class_name(name)
	var/static/regex/regex = new(@"[^a-zA-Z0-9]","g")
	return replacetext(name, regex, "")

/datum/asset/spritesheet/moods
	name = "moods"
	var/iconinserted = 1

/datum/asset/spritesheet/moods/register()
	for(var/i in 1 to 9)
		var/target_to_insert = "mood"+"[iconinserted]"
		Insert(target_to_insert, 'icons/hud/screen_gen.dmi', target_to_insert)
		iconinserted++
	..()

/datum/asset/spritesheet/moods/ModifyInserted(icon/pre_asset)
	var/blended_color
	switch(iconinserted)
		if(1)
			blended_color = "#f15d36"
		if(2 to 3)
			blended_color = "#f38943"
		if(4)
			blended_color = "#dfa65b"
		if(5)
			blended_color = "#4b96c4"
		if(6)
			blended_color = "#86d656"
		else
			blended_color = "#2eeb9a"
	pre_asset.Blend(blended_color, ICON_MULTIPLY)
	return pre_asset
