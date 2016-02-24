##########################################
# Tell people they need to use the "new" way.

define errorMessage
  $(warning * Attention, the configuration for GitHub has changed)
  $(warning *   DISTILLERY_GITHUB_USER is depricated. You shoud now)
  $(warning *   use DISTILLERY_GITHUB_URL_USER)
  $(warning *   DISTILLERY_GITHUB_SERVER is depricated. You shoud now)
  $(warning *   use DISTILLERY_GITHUB_URL)
  $(warning *   Set this in your config file .ccnx/distillery/config.mk)
  $(warning *   See config/config.mk for default values)
  $(error   ERROR: Make found depricated variable $1) 
endef

ifdef DISTILLERY_GITHUB_USER
  $(call errorMessage,DISTILLERY_GITHUB_USER)
endif

ifdef DISTILLERY_GITHUB_SERVER
  $(call errorMessage,DISTILLERY_GITHUB_SERVER)
endif
