# define variables
PKGNAME="nodejsexp"
VERSION="0.1.103"

TMP_DIR=tmp/
SRC_DIR=$(TMP_DIR)/node
SRC_GIT=http://github.com/ry/node.git
SRC_TAG=v$(VERSION)

#################################################################################
#		node src handling						#
#################################################################################

src_import:
	mkdir $(SRC_DIR)
	(cd $(TMP_DIR) && git clone $(SRC_GIT))
	(cd $(SRC_DIR) && git checkout $(SRC_TAG))

src_delete:
	rm -rf $(SRC_DIR)

#################################################################################
#		classic targets (use by dpkg)					#
#################################################################################

clean:
	(cd $(SRC_DIR) && make clean; true)

build:
	(cd $(SRC_DIR) && ./configure && make)

install:
	(cd $(SRC_DIR) && make install)

#################################################################################
#		deb package handling						#
#################################################################################

deb_src_build:
	debuild -S -k'jerome etienne' -I.git

deb_bin_build:
	debuild -i -us -uc -b

deb_upd_changelog:
	dch --newversion $(VERSION)~lucid1~ppa`date +%Y%m%d%H%M` --maintmaint --force-bad-version --distribution `lsb_release -c -s` Another build

deb_clean:
	rm -f ../$(PKGNAME)_$(VERSION)~lucid1~ppa*

ppa_upload: clean build deb_clean deb_upd_changelog deb_src_build
	dput -U ppa:jerome-etienne/neoip ../$(PKGNAME)_$(VERSION)~lucid1~ppa*_source.changes 