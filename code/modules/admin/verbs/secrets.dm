

/client/proc/secrets() //Creates a verb for admins to open up the ui
	set name = "Secrets"
	set desc = "Abuse harder than you ever have before with this handy dandy semi-misc stuff menu"
	set category = "Admin.Game"
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Secrets Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	var/datum/secrets_menu/tgui  = new(usr)//create the datum
	tgui.ui_interact(usr)//datum has a tgui component, here we open the window

/datum/secrets_menu
	var/client/holder //client of whoever is using this datum
	var/is_debugger = FALSE
	var/is_funmin = FALSE

/datum/secrets_menu/New(user)//user can either be a client or a mob due to byondcode(tm)
	if (istype(user, /client))
		var/client/user_client = user
		holder = user_client //if its a client, assign it to holder
	else
		var/mob/user_mob = user
		holder = user_mob.client //if its a mob, assign the mob's client to holder

	is_debugger = check_rights(R_DEBUG)
	is_funmin = check_rights(R_FUN)

/datum/secrets_menu/ui_state(mob/user)
	return GLOB.admin_state

/datum/secrets_menu/ui_close()
	qdel(src)

/datum/secrets_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Secrets")
		ui.open()

/datum/secrets_menu/ui_data(mob/user)
	var/list/data = list()
	data["is_debugger"] = is_debugger
	data["is_funmin"] = is_funmin
	return data

/datum/secrets_menu/ui_act(action, params)
	. = ..()
	if(.)
		return
	if((action != "admin_log" || action != "show_admins" || action != "mentor_log") && !check_rights(R_ADMIN))
		return
	var/datum/round_event/E
	var/ok = FALSE
	switch(action)
		//Generic Buttons anyone can use.
		if("admin_log")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><B>Admin Log<HR></B>"
			for(var/l in GLOB.admin_log)
				dat += "<li>[l]</li>"
			if(!GLOB.admin_log.len)
				dat += "No-one has done anything this round!"
			holder << browse(dat, "window=admin_log")
		if("show_admins")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><B>Current admins:</B><HR>"
			if(GLOB.admin_datums)
				for(var/ckey in GLOB.admin_datums)
					var/datum/admins/D = GLOB.admin_datums[ckey]
					dat += "[ckey] - [D.rank.name]<br>"
				holder << browse(dat, "window=showadmins;size=600x500")
		if("list_bombers")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><B>Bombing List</B><HR>"
			for(var/l in GLOB.bombers)
				dat += text("[l]<BR>")
			holder << browse(dat, "window=bombers")

		if("list_signalers")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><B>Showing last [length(GLOB.lastsignalers)] signalers.</B><HR>"
			for(var/sig in GLOB.lastsignalers)
				dat += "[sig]<BR>"
			holder << browse(dat, "window=lastsignalers;size=800x500")
		if("list_lawchanges")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><B>Showing last [length(GLOB.lawchanges)] law changes.</B><HR>"
			for(var/sig in GLOB.lawchanges)
				dat += "[sig]<BR>"
			holder << browse(dat, "window=lawchanges;size=800x500")
		if("showgm")
			if(!SSticker.HasRoundStarted())
				tgui_alert(usr,"The game hasn't started yet!")
			else if (SSticker.mode)
				tgui_alert(usr,"The game mode is [SSticker.mode.name]")
			else
				tgui_alert(usr,"For some reason there's a SSticker, but not a game mode")
		if("dna")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><B>Showing DNA from blood.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
			for(var/i in GLOB.human_list)
				var/mob/living/carbon/human/H = i
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.dna.blood_type]</td></tr>"
			dat += "</table>"
			holder << browse(dat, "window=DNA;size=440x410")
		if("fingerprints")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><B>Showing Fingerprints.</B><HR>"
			dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
			for(var/i in GLOB.human_list)
				var/mob/living/carbon/human/H = i
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[md5(H.dna.uni_identity)]</td></tr>"
			dat += "</table>"
			holder << browse(dat, "window=fingerprints;size=440x410")
		if("set_name")
			var/new_name = input(holder, "Please input a new name for the station.", "What?", "") as text|null
			if(!new_name)
				return
			set_station_name(new_name)
			log_admin("[key_name(holder)] renamed the station to \"[new_name]\".")
			message_admins(span_adminnotice("[key_name_admin(holder)] renamed the station to: [new_name]."))
			priority_announce("[command_name()] has renamed the station to \"[new_name]\".")
		if("reset_name")
			var/new_name = new_station_name()
			set_station_name(new_name)
			log_admin("[key_name(holder)] reset the station name.")
			message_admins(span_adminnotice("[key_name_admin(holder)] reset the station name."))
			priority_announce("[command_name()] has renamed the station to \"[new_name]\".")
		if("allspecies")
			if(!is_funmin)
				return
			var/result = input(holder, "Please choose a new species","Species") as null|anything in GLOB.species_list
			if(result)
				SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Mass Species Change", "[result]"))
				log_admin("[key_name(holder)] turned all humans into [result]", 1)
				message_admins("\blue [key_name_admin(holder)] turned all humans into [result]")
				var/newtype = GLOB.species_list[result]
				for(var/i in GLOB.human_list)
					var/mob/living/carbon/human/H = i
					H.set_species(newtype)
		if("anon_name")
			if(!is_funmin)
				return
			holder.anon_names()
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Anonymous Names"))
		if("changebombcap")
			if(!is_funmin)
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Bomb Cap"))

			var/newBombCap = input(holder,"What would you like the new bomb cap to be. (entered as the light damage range (the 3rd number in common (1,2,3) notation)) Must be above 4)", "New Bomb Cap", GLOB.MAX_EX_LIGHT_RANGE) as num|null
			if (!CONFIG_SET(number/bombcap, newBombCap))
				return

			message_admins(span_boldannounce("[key_name_admin(holder)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]"))
			log_admin("[key_name(holder)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]")
		if("massbraindamage")
			if(!is_funmin)
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Mass Braindamage"))
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				to_chat(H, span_boldannounce("You suddenly feel stupid.") , confidential = TRUE)
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60, 80)
			message_admins("[key_name_admin(holder)] made everybody brain damaged")
		if("massimmerse")
			if(!is_funmin)
				return
			mass_immerse()
			message_admins("[key_name_admin(holder)] has Fully Immersed \
				everyone!")
			log_admin("[key_name(holder)] has Fully Immersed everyone.")
		if("unmassimmerse")
			if(!is_funmin)
				return
			mass_immerse(remove=TRUE)
			message_admins("[key_name_admin(holder)] has Un-Fully Immersed \
				everyone!")
			log_admin("[key_name(holder)] has Un-Fully Immersed everyone.")
	if(E)
		E.processing = FALSE
		if(E.announceWhen>0)
			switch(tgui_alert(holder, "Would you like to alert the crew?", "Alert", list("Yes", "No", "Cancel")))
				if("Yes")
					E.announceChance = 100
				if("Cancel")
					E.kill()
					return
				if("No")
					E.announceChance = 0
		E.processing = TRUE
	if(holder)
		log_admin("[key_name(holder)] used secret [action]")
		if(ok)
			to_chat(world, text("<B>A secret has been activated by []!</B>", holder.key), confidential = TRUE)

/proc/portalAnnounce(announcement, playlightning)
	set waitfor = FALSE
	if (playlightning)
		sound_to_playing_players('sound/magic/lightning_chargeup.ogg')
		sleep(80)
	priority_announce(replacetext(announcement, "%STATION%", station_name()))
	if (playlightning)
		sleep(20)
		sound_to_playing_players('sound/magic/lightningbolt.ogg')

/proc/doPortalSpawn(turf/loc, mobtype, numtospawn, portal_appearance, players, humanoutfit)
	for (var/i in 1 to numtospawn)
		var/mob/spawnedMob = new mobtype(loc)
		if (length(players))
			var/mob/chosen = players[1]
			if (chosen.client)
				chosen.client.prefs.copy_to(spawnedMob)
				spawnedMob.key = chosen.key
			players -= chosen
		if (ishuman(spawnedMob) && ispath(humanoutfit, /datum/outfit))
			var/mob/living/carbon/human/H = spawnedMob
			H.equipOutfit(humanoutfit)
	var/turf/T = get_step(loc, SOUTHWEST)
	flick_overlay_static(portal_appearance, T, 15)
	playsound(T, 'sound/magic/lightningbolt.ogg', rand(80, 100), TRUE)
