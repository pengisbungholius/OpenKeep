/datum/job/roguetown/guardsman
	title = "Garrison Guard"
	flag = GUARDSMAN
	department_flag = GARRISON
	faction = "Station"
	total_positions = 8
	spawn_positions = 8

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		"Humen",
		"Elf",
		"Half-Elf",
		"Dwarf",
		"Aasimar",
		"Tiefling",
		"Dark Elf",
		"Aasimar",
		"Changeling",
		"Skylancer",
		"Ogrun",
		"Undine"
	)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	tutorial = "You are a soldier in the ruler's garrison. Your experience, training, and equipment may vary... but you are the first line of defense against the horrors that encroach on Rockhill."
	display_order = JDO_GARRISONGUARD
	whitelist_req = FALSE
	bypass_lastclass = TRUE

	outfit = /datum/outfit/job/roguetown/guardsman	//Default outfit.
	advclass_cat_rolls = list(CTAG_GARRISON = 20)	//Handles class selection.
	give_bank_account = 30
	min_pq = 0

	cmode_music = 'sound/music/combat_guard.ogg'

/datum/job/roguetown/guardsman/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		if(istype(H.cloak, /obj/item/clothing/cloak/stabard/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "guard's tabard ([index])"
		if(istype(H.cloak, /obj/item/clothing/cloak/stabard/haramaki/jinbaori/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "ashigaru's jinbaori ([index])"

//Universal stuff for all guards, regardless of their class selection.
/datum/outfit/job/roguetown/guardsman/pre_equip(mob/living/carbon/human/H)
	if(H.dna?.species && H.dna.species?.id != "abyssariad")
		pants = /obj/item/clothing/under/roguetown/trou/leather
		cloak = /obj/item/clothing/cloak/stabard/guard
		shoes = /obj/item/clothing/shoes/roguetown/boots
		belt = /obj/item/storage/belt/rogue/leather
	if(H.dna?.species && H.dna.species?.id == "abyssariad")
		pants = /obj/item/clothing/under/roguetown/trou/tobi/random
		cloak = /obj/item/clothing/cloak/stabard/haramaki/jinbaori/guard //I can't put these somewhere else.
		shoes = /obj/item/clothing/shoes/roguetown/boots/jikatabi/shinobi
		belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/random
		H.cmode_music = list('sound/music/kaizoku/combat/combat_changeling.ogg','sound/music/kaizoku/combat/combat_stormwarrior.ogg','sound/music/kaizoku/combat/combat_searaider.ogg','sound/music/kaizoku/combat/combat_oldtides.ogg','sound/music/kaizoku/combat/combat_decapitator.ogg','sound/music/kaizoku/combat/combat_emperor.ogg','sound/music/kaizoku/combat/combat_traditional.ogg','sound/music/kaizoku/combat/combat_navalretainers.ogg','sound/music/kaizoku/combat/combat_kyudo.ogg')


/* ! ! ! Class Selection Section Below ! ! !
Design philosphy:
- Footman, specializes in using axes/maces and shields. - Medium armor
- Pikeman, specializes in polearms with some bonus stats. - Medium armor
- Archer, specializes in bow/crossbow and daggers. - Dodge expert, no armor training, some crafting stats (low)
- Fencer, specializes in swords and daggers. - Dodge expert, no armor training
*/

/datum/advclass/garrison/footman
	name = "Garrison Footman"
	tutorial = "You are a footman in the garrison levy. You are well versed in holding the line with a shield while wielding a trusty sword, axe, or mace in the other hand."
	outfit = /datum/outfit/job/roguetown/guardsman/footman

	category_tags = list(CTAG_GARRISON)

/datum/outfit/job/roguetown/guardsman/footman/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.dna?.species && H.dna.species?.id == "abyssariad") // (non-patterned) Islander equipment system
		to_chat(H, "<span class='warning'>My clan was bound to sworn to the king's cause under the Heavenly Emperor's will. As an Ashigaru retainer, their lineage is held in high regard, and I shall serve their bloodline as I would my daimyo.")
		armor = /obj/item/clothing/suit/roguetown/armor/cuirass/nanbando
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/tatami
		mask = /obj/item/clothing/mask/rogue/kaizoku/menpo/half //Abyssariads relies less in gorgets, more in masks.
		head = /obj/item/clothing/head/roguetown/helmet/zijinguan //Hopefully the feather colors will be fixed.
		backr = /obj/item/rogueweapon/shield/wood/rattan
		beltr = /obj/item/rogueweapon/sword/scimitar/messer/dao
		beltl = /obj/item/rogueweapon/mace/ararebo
		backpack_contents = list(/obj/item/keyring/guard)
		if(findtext(H.real_name, " Clanless"))
			to_chat(H, "<span class='userdanger'>If I am bound to the king, I must be one with my bloodline.</span>")
			clanfication(H)
	if(H.dna?.species && H.dna.species?.id != "abyssariad") // Default non-Islander equipment
		//Gets a steel cuirass over chain, a gorget, and a nasal helmet
		armor = /obj/item/clothing/suit/roguetown/armor/cuirass
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
		neck = /obj/item/clothing/neck/roguetown/gorget
		head = /obj/item/clothing/head/roguetown/helmet/nasal
		backr = /obj/item/rogueweapon/shield/wood
		beltr = /obj/item/rogueweapon/sword/scimitar/messer
		beltl = /obj/item/rogueweapon/mace
		backpack_contents = list(/obj/item/keyring/guard)
	//Stats for class
	H.mind.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat("strength", 1)
	H.change_stat("endurance", 2)
	H.change_stat("constitution", 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.verbs |= /mob/proc/haltyell

/datum/advclass/garrison/pikeman
	name = "Garrison Pikeman"
	tutorial = "You are a pikeman in the garrison levy. You are less fleet of foot compared to the rest, but you are burly and well practiced with spears, pikes, billhooks - all the various polearms for striking enemies from a distance."
	outfit = /datum/outfit/job/roguetown/guardsman/pikeman

	category_tags = list(CTAG_GARRISON)

/datum/outfit/job/roguetown/guardsman/pikeman/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.dna.species?.id == "abyssariad") //I gotta try making the abyssariads guards be forced to have surnames.
		to_chat(H, "<span class='warning'>My clan was bound to sworn to the king's cause under the Heavenly Emperor's will. As an Ashigaru retainer, their lineage is held in high regard, and I shall serve their bloodline as I would my daimyo.")
		armor = /obj/item/clothing/suit/roguetown/armor/chainmail/tatami
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/ruankai
		neck = /obj/item/clothing/neck/roguetown/gorget
		head = /obj/item/clothing/head/roguetown/helmet/jingasa
		beltr = /obj/item/rogueweapon/sword/scimitar/messer/dao
		backpack_contents = list(/obj/item/keyring/guard)
		if(findtext(H.real_name, " Clanless"))
			to_chat(H, "<span class='userdanger'>If I am bound to the king, I must be one with my bloodline.</span>")
			clanfication(H)
	else
		//Gets chain over a gambeson, a gorget, and a kettle helmet
		armor = /obj/item/clothing/suit/roguetown/armor/chainmail
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
		neck = /obj/item/clothing/neck/roguetown/gorget
		head = /obj/item/clothing/head/roguetown/helmet/kettle
		beltr = /obj/item/rogueweapon/sword/scimitar/messer
		backpack_contents = list(/obj/item/keyring/guard)

	//Stats for class
	H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat("strength", 2)
	H.change_stat("endurance", 1)
	H.change_stat("constitution", 1)
	H.change_stat("speed", -1) // Stronk and gets training in hard hitting polearms, but slower
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.verbs |= /mob/proc/haltyell

	var/weapontype = pickweight(list("Spear" = 6, "Bardiche" = 4)) // Rolls for either a spear or a bardiche
	switch(weapontype)
		if("Spear")
			backr = /obj/item/rogueweapon/polearm/spear
			if(H.dna.species?.id == "abyssariad")
				backr = /obj/item/rogueweapon/polearm/spear/yari
		if("Bardiche")
			backr = /obj/item/rogueweapon/polearm/halberd/bardiche
			if(H.dna.species?.id == "abyssariad")
				backr = /obj/item/rogueweapon/polearm/halberd/bardiche/naginata

/datum/advclass/garrison/archer
	name = "Garrison Archer"
	tutorial = "You are an archer in the garrison levy. Your training with bows and crossbows makes you a formidable threat when perched atop the walls or rooftops, raining arrows or bolts down upon foes with impunity."
	outfit = /datum/outfit/job/roguetown/guardsman/archer

	category_tags = list(CTAG_GARRISON)

/datum/outfit/job/roguetown/guardsman/archer/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.dna.species?.id == "abyssariad")
		to_chat(H, "<span class='warning'>My clan was bound to sworn to the king's cause under the Heavenly Emperor's will. As an Ashigaru retainer, their lineage is held in high regard, and I shall serve their bloodline as I would my daimyo.")
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/deelcoat
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/hankyu
		head = /obj/item/clothing/head/roguetown/tengai/gasa
		neck = /obj/item/clothing/neck/roguetown/chaincoif/karuta_zukin/military
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/khudagach
		beltr = /obj/item/quiver/arrows
		beltl = /obj/item/rogueweapon/knife/kaizoku/tanto
		backpack_contents = list(/obj/item/keyring/guard)
		if(findtext(H.real_name, " Clanless"))
			to_chat(H, "<span class='userdanger'>If I am bound to the king, I must be one with my bloodline.</span>")
			clanfication(H)
	else
		//Gets a padded gambeson, leather bracers, and a chain coif
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
		head = /obj/item/clothing/head/roguetown/roguehood/red
		neck = /obj/item/clothing/neck/roguetown/chaincoif
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
		beltr = /obj/item/quiver/arrows
		beltl = /obj/item/rogueweapon/knife/dagger/steel/special
		backpack_contents = list(/obj/item/keyring/guard)
	//Stats for class
	H.mind.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat("perception", 2)
	H.change_stat("endurance", 1)
	H.change_stat("speed", 2)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.verbs |= /mob/proc/haltyell

/datum/advclass/garrison/fencer
	name = "Garrison Fencer"
	tutorial = "You are a fencer in the garrison levy. If nothing else you know a simple truth, there are few problems that cannot be resolved with quick feet and the precise application of a deft blade."
	outfit = /datum/outfit/job/roguetown/guardsman/fencer
	category_tags = list(CTAG_GARRISON)

/datum/outfit/job/roguetown/guardsman/fencer/pre_equip(mob/living/carbon/human/H)
	..()
	//Gets studded leather (which hopefully will be renamed splint mail at some point...) and a chain coif
	backpack_contents = list(/obj/item/keyring/guard)
	if(H.dna.species?.id == "abyssariad")
		to_chat(H, "<span class='warning'>My clan was bound to sworn to the king's cause under the Heavenly Emperor's will. As an Ashigaru retainer, their lineage is held in high regard, and I shall serve their bloodline as I would my daimyo.")
		armor = /obj/item/clothing/suit/roguetown/armor/leather/splint/kikko
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
		beltr = /obj/item/rogueweapon/sword/rapier
		head = /obj/item/clothing/head/roguetown/tengai/gasa
		neck = /obj/item/clothing/neck/roguetown/chaincoif/karuta_zukin/military
		beltl = /obj/item/rogueweapon/knife/kaizoku/tanto
		backpack_contents = list(/obj/item/keyring/guard)
		if(findtext(H.real_name, " Clanless"))
			to_chat(H, "<span class='userdanger'>Since my clan became bound to the king, I must be one with my bloodline. I am no Clanless.</span>")
			clanfication(H)
	else
		//Gets studded leather (which hopefully will be renamed splint mail at some point...) and a chain coif
		armor = /obj/item/clothing/suit/roguetown/armor/leather/splint
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
		beltr = /obj/item/rogueweapon/sword/rapier
		beltl = /obj/item/rogueweapon/knife/dagger/steel/special
		head = /obj/item/clothing/head/roguetown/roguehood/red
		neck = /obj/item/clothing/neck/roguetown/chaincoif
		backpack_contents = list(/obj/item/keyring/guard)

	H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.change_stat("endurance", 2)
	H.change_stat("speed", 2)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	H.verbs |= /mob/proc/haltyell

/mob/proc/haltyell()
	set name = "HALT!"
	set category = "Noises"
	emote("haltyell")
