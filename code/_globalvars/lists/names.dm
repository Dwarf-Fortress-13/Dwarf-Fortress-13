GLOBAL_LIST_INIT(first_names, world.file2list("strings/names/first.txt"))
GLOBAL_LIST_INIT(first_names_male, world.file2list("strings/names/first_male.txt"))
GLOBAL_LIST_INIT(first_names_female, world.file2list("strings/names/first_female.txt"))
GLOBAL_LIST_INIT(last_names, world.file2list("strings/names/last.txt"))
GLOBAL_LIST_INIT(dwarf_first, world.file2list("strings/dwarfs/first_names.txt"))

GLOBAL_LIST_INIT(verbs, world.file2list("strings/names/verbs.txt"))
GLOBAL_LIST_INIT(ing_verbs, world.file2list("strings/names/ing_verbs.txt"))
GLOBAL_LIST_INIT(adverbs, world.file2list("strings/names/adverbs.txt"))
GLOBAL_LIST_INIT(adjectives, world.file2list("strings/names/adjectives.txt"))
GLOBAL_LIST_INIT(gross_adjectives,  world.file2list("strings/names/gross_adjectives.txt"))
GLOBAL_LIST_INIT(dream_strings, world.file2list("strings/dreamstrings.txt"))
//loaded on startup because of "
//would include in rsc if ' was used

/*
List of configurable names in preferences and their metadata
"id" = list(
	"pref_name" = "name", //pref label
	"qdesc" =  "name", //popup question text
	"allow_numbers" = FALSE, // numbers allowed in the name
	"group" = "whatever", // group (these will be grouped together on pref ui ,order still follows the list so they need to be concurrent to be grouped)
	"allow_null" = FALSE // if empty name is entered it's replaced with default value
	),
*/
GLOBAL_LIST_INIT(preferences_custom_names, list(
	"human" = list("pref_name" = "Backup Name", "qdesc" = "dogshit", "allow_numbers" = FALSE , "group" = "backup_human", "allow_null" = FALSE)
	))
