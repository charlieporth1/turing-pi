################################################################################
#
# good
#
################################################################################

GOOD_VERSION = a238b1dfcd825d47d834af3c5223417c8411d90d
GOOD_SITE = git://localhost:$(GITREMOTE_PORT_NUMBER)/repo.git

$(eval $(generic-package))
