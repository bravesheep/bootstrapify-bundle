#!/usr/bin/env bash

# jQuery version
JQUERY_VERSION='1.10.2'

# jQuery Migrate version
JQUERY_MIGRATE_VERSION='1.2.1'

# Twitter Bootstrap version
TWBS_VERSION='3.0.0'

# Font-awesome version
FA_VERSION='3.2.1'

# Select2 version
SELECT2_VERSION='3.4.2'

# Select2-bootstrap layout version
SELECT2_BS_VERSION='master'

# Bootstrap datepicker version
BSDP_VERSION='master'

## Functions and helpers
# Color codes, NC is reset
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;37;41m'

# Display a log message with time
logmsg() {
    echo -e "[`date '+%F %T'`] ${1}"
}

# Display a success message
ok() {
    echo -e "${GREEN}${1}${NC}"
}

# Display a warning
warn() {
    echo -e "${YELLOW}${1}${NC}"
}

# Display an error
error() {
    echo -e "${RED}${1}${NC}"
}

# Move file
dmv() {
    mv "${1}" "${2}"
    if [ $? == 0 ]; then
        ok "Moved ${NC}${1}${GREEN} to ${NC}${2}${GREEN}..."
    else
        warn "!!! Could not move ${NC}${1}${YELLOW} to ${NC}${2}${YELLOW}..."
    fi
}

# Remove file or directory
drm() {
    rm -rf "${1}"
    if [ $? == 0 ]; then
        ok "Deleted ${NC}${1}${GREEN}..."
    else
        warn "!!! Could not delete ${NC}${1}${YELLOW}..."
    fi
}

# Download file
ddl() {
    if [ ! -f "${2}" ] || [ ${3} ]; then
        wget -q -O "${2}" "${1}"
        if [ $? == 0 ]; then
            ok "Downloaded ${NC}${1}${GREEN} to ${NC}${2}${GREEN}..."
        else
            warn "!!! Could not download ${NC}${1}${YELLOW}..."
        fi
    fi
}

# Extract tar.gz file
dtarx() {
    tar xfz "${1}"
    if [ $? == 0 ]; then
        ok "Extracted ${NC}${1}${GREEN}..."
    else
        warn "!!! Could not extract ${NC}${1}${YELLOW}..."
    fi
}

# Create a directory recursively
dmkdir() {
    mkdir -p "${1}"
    if [ $? == 0 ]; then
        ok "Created ${NC}${1}${GREEN}..."
    else
        warn "!!! Could not create folder ${NC}${1}${YELLOW}..."
    fi
}

dsed() {
    tmp=`mktemp "sedXXXXXX"`
    if [ $? == 0 ]; then
        sed -e "${2}" "${1}" > "${tmp}"
        if [ $? == 0 ]; then
            mv "${tmp}" "${1}"
            if [ $? == 0 ]; then
                ok "Updated ${NC}${1}${GREEN}..."
            else
                warn "!!! Could not move file ${NC}${1}${YELLOW} back..."
                rm $tmp
            fi
        else
            warn "!!! Could not fullfill replacement ${NC}${2}${YELLOW} in ${NC}${1}${YELLOW}..."
            rm $tmp
        fi
    else
        warn "!!! Could not create temporary file..."
    fi
}
logmsg "Starting..."

## Twitter bootstrap
TWBS_URL="https://github.com/jlong/sass-bootstrap/archive/v${TWBS_VERSION}.tar.gz"
TWBS_OUT="twbs-${TWBS_VERSION}.tgz"
TWBS_DIR="sass-bootstrap-${TWBS_VERSION}/"

ddl "${TWBS_URL}" "${TWBS_OUT}"
dtarx "${TWBS_OUT}"

dmkdir "Resources/js"
dmv "${TWBS_DIR}dist/js/bootstrap.js" "Resources/js/"
for f in ${TWBS_DIR}js/*.js; do
    dmv "${f}" "Resources/js/"
done

dmkdir "Resources/public/fonts"
for f in ${TWBS_DIR}dist/fonts/*; do
    dmv "${f}" "Resources/public/fonts/"
done

dmkdir "Resources/scss/bootstrap"
for f in ${TWBS_DIR}lib/*.scss; do
    dmv "${f}" "Resources/scss/bootstrap/"
done

### Font awesome
FA_URL="https://github.com/FortAwesome/Font-Awesome/archive/v${FA_VERSION}.tar.gz"
FA_OUT="fa-${FA_VERSION}.tgz"
FA_DIR="Font-Awesome-${FA_VERSION}/"

ddl "${FA_URL}" "${FA_OUT}"
dtarx "${FA_OUT}"

dmkdir "Resources/public/font"
for f in ${FA_DIR}font/*; do
    dmv "${f}" "Resources/public/font/"
done

dmkdir "Resources/scss/font-awesome"
for f in ${FA_DIR}scss/*.scss; do
    dmv "${f}" "Resources/scss/font-awesome/"
done

### jQuery and jQuery migrate
JQUERY_URL="http://code.jquery.com/jquery-${JQUERY_VERSION}.js"
JQUERY_MIGRATE_URL="http://code.jquery.com/jquery-migrate-${JQUERY_MIGRATE_VERSION}.js"

dmkdir "Resources/js"
ddl "${JQUERY_URL}" "Resources/js/jquery.js" true
ddl "${JQUERY_MIGRATE_URL}" "Resources/js/jquery-migrate.js" true

### Select2
SELECT2_URL="https://github.com/ivaynberg/select2/archive/${SELECT2_VERSION}.tar.gz"
SELECT2_OUT="select2-${SELECT2_VERSION}.tgz"
SELECT2_DIR="select2-${SELECT2_VERSION}/"

ddl "${SELECT2_URL}" "${SELECT2_OUT}"
dtarx "${SELECT2_OUT}"

dmkdir "Resources/js"
dmv "${SELECT2_DIR}select2.js" "Resources/js/"

dmkdir "Resources/scss/select2"
dmv "${SELECT2_DIR}select2.css" "Resources/scss/select2/select2.scss"

dmkdir "Resources/public/img"
dmv "${SELECT2_DIR}select2.png" "Resources/public/img/"
dmv "${SELECT2_DIR}select2x2.png" "Resources/public/img/"
dmv "${SELECT2_DIR}select2-spinner.gif" "Resources/public/img/"

dmkdir "Resources/public/js/locale/select2"
for f in ${SELECT2_DIR}select2_locale_*.js; do
    dmv "${f}" "Resources/public/js/locale/select2/"
done

### Select2-bootstrap
SELECT2_BS_URL="https://github.com/fk/select2-bootstrap-css/archive/${SELECT2_BS_VERSION}.tar.gz"
SELECT2_BS_OUT="select2-bootstrap-css-${SELECT2_BS_VERSION}.tgz"
SELECT2_BS_DIR="select2-bootstrap-css-${SELECT2_BS_VERSION}/"

ddl "${SELECT2_BS_URL}" "${SELECT2_BS_OUT}"
dtarx "${SELECT2_BS_OUT}"

dmkdir "Resources/scss/select2"
dmv "${SELECT2_BS_DIR}lib/select2-bootstrap.scss" "Resources/scss/select2/"

## Bootstrap datepicker plugin
BSDP_URL="https://github.com/eternicode/bootstrap-datepicker/archive/${BSDP_VERSION}.tar.gz"
BSDP_OUT="bootstrap-datepicker-${BSDP_VERSION}.tgz"
BSDP_DIR="bootstrap-datepicker-${BSDP_VERSION}/"

ddl "${BSDP_URL}" "${BSDP_OUT}"
dtarx "${BSDP_OUT}"

dmkdir "Resources/scss/bootstrap-datepicker"
dmv "${BSDP_DIR}less/datepicker.less" "Resources/scss/bootstrap-datepicker/datepicker.scss"

dmkdir "Resources/js"
dmv "${BSDP_DIR}js/bootstrap-datepicker.js" "Resources/js/"

dmkdir "Resources/public/js/locale/bootstrap-datepicker"
for f in ${BSDP_DIR}js/locales/bootstrap-datepicker.*.js; do
    dmv "${f}" "Resources/public/js/locale/bootstrap-datepicker/"
done

dsed "Resources/scss/select2/select2.scss" "s/url('/url('#{\$select2-resource-path}/"

bsdp_scss="Resources/scss/bootstrap-datepicker/datepicker.scss"

dsed "${bsdp_scss}" "s/@white/\$body-bg/g"
dsed "${bsdp_scss}" "s/@grayLighter/\$gray-lighter/g"
dsed "${bsdp_scss}" "s/@grayLight/\$gray-light/g"
dsed "${bsdp_scss}" "s/@todayBackground/\$today-background/g"
dsed "${bsdp_scss}" "s/@orange/\$brand-warning/g"
dsed "${bsdp_scss}" "s/@btnPrimaryBackground/\$btn-primary-bg/g"
dsed "${bsdp_scss}" "s/@baseLineHeight/\$line-height-base/g"
dsed "${bsdp_scss}" "s/\.buttonBackground/@include gradient-vertical/"
dsed "${bsdp_scss}" "s/\.border-radius(\([^)]*\))/border-radius: \1/"
dsed "${bsdp_scss}" "s/spin(/adjust-hue(/"
dsed "${bsdp_scss}" "s/&&-/.datepicker.datepicker-/"
dsed "${bsdp_scss}" "s/&-/.datepicker-/"

## Cleanup
drm "${TWBS_DIR}"
drm "${FA_DIR}"
drm "${SELECT2_DIR}"
drm "${SELECT2_BS_DIR}"
drm "${BSDP_DIR}"

drm "${TWBS_OUT}"
drm "${FA_OUT}"
drm "${SELECT2_OUT}"
drm "${SELECT2_BS_OUT}"
drm "${BSDP_OUT}"

logmsg "Done"
