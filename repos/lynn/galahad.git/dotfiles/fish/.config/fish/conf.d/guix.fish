# Source this file to define all the relevant environment variables in Bash
# for this profile.  You may want to define the 'GUIX_PROFILE' environment
# variable to point to the "visible" name of the profile, like this:
#
#  GUIX_PROFILE=/path/to/profile ; \
#  source /path/to/profile/etc/profile
#
# When GUIX_PROFILE is undefined, the various environment variables refer
# to this specific profile generation.
set -gx GUIX_PROFILE ~/.guix-profile
fish_add_path "$GUIX_PROFILE/bin"
set -gax XDG_DATA_DIRS "$GUIX_PROFILE/share"
set -gx GUILE_LOAD_COMPILED_PATH "$GUIX_PROFILE/lib/guile/3.0/site-ccache $GUIX_PROFILE/share/guile/site/3.0"
set -gx GUILE_LOAD_PATH "$GUIX_PROFILE/share/guile/site/3.0"
