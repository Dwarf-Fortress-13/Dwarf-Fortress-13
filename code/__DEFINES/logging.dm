//Investigate logging defines
#define INVESTIGATE_BOTANY			"botany"
#define INVESTIGATE_CRAFTING		"crafting"
#define INVESTIGATE_HALLUCINATIONS	"hallucinations"

// Logging types for log_message()
#define LOG_ATTACK			(1 << 0)
#define LOG_SAY				(1 << 1)
#define LOG_WHISPER			(1 << 2)
#define LOG_EMOTE			(1 << 3)
#define LOG_DSAY			(1 << 4)
#define LOG_OOC				(1 << 5)
#define LOG_ADMIN			(1 << 6)
#define LOG_OWNERSHIP		(1 << 7)
#define LOG_GAME			(1 << 8)
#define LOG_ADMIN_PRIVATE	(1 << 9)
#define LOG_ASAY			(1 << 10)
#define LOG_LOBBY			(1 << 13)

//Individual logging panel pages
#define INDIVIDUAL_ATTACK_LOG		(LOG_ATTACK)
#define INDIVIDUAL_SAY_LOG			(LOG_SAY | LOG_WHISPER | LOG_DSAY)
#define INDIVIDUAL_EMOTE_LOG		(LOG_EMOTE)
#define INDIVIDUAL_OOC_LOG			(LOG_OOC | LOG_ADMIN)
#define INDIVIDUAL_OWNERSHIP_LOG	(LOG_OWNERSHIP)
#define INDIVIDUAL_SHOW_ALL_LOG		(LOG_ATTACK | LOG_SAY | LOG_WHISPER | LOG_EMOTE | LOG_DSAY | LOG_OOC | LOG_ADMIN | LOG_OWNERSHIP | LOG_GAME | LOG_ADMIN_PRIVATE | LOG_ASAY)

#define LOGSRC_CLIENT "Client"
#define LOGSRC_MOB "Mob"
