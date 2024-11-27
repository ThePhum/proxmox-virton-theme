include /usr/share/dpkg/pkg-info.mk

PACKAGE=libjs-extjs

BUILDDIR ?= $(PACKAGE)-$(DEB_VERSION_UPSTREAM)
ORIG_SRC_TAR=$(PACKAGE)_$(DEB_VERSION_UPSTREAM).orig.tar.gz

DEB=$(PACKAGE)_$(DEB_VERSION_UPSTREAM_REVISION)_all.deb
DSC=$(PACKAGE)_$(DEB_VERSION_UPSTREAM_REVISION).dsc

all: deb

$(BUILDDIR): debian extjs
	rm -rf $@ $@.tmp && mkdir -p $@.tmp/extjs
	cp -a debian/ $@.tmp/debian
	cp -a extjs/build/ $@.tmp/extjs/build
	echo "git clone git://git.proxmox.com/git/extjs.git\\ngit checkout $$(git rev-parse HEAD)" > $@.tmp/debian/SOURCE
	mv $@.tmp $@

.PHONY: deb
deb: $(DEB)
$(DEB): $(BUILDDIR)
	cd $(BUILDDIR); dpkg-buildpackage -b -us -uc
	lintian $@

$(ORIG_SRC_TAR): $(BUILDDIR)
	tar czf $(ORIG_SRC_TAR) --exclude="$(BUILDDIR)/debian" $(BUILDDIR)

.PHONY: dsc
dsc: clean
	$(MAKE) $(DSC)
	lintian $(DSC)

$(DSC): $(ORIG_SRC_TAR) $(BUILDDIR)
	cd $(BUILDDIR); dpkg-buildpackage -S -us -uc -d

sbuild: $(DSC)
	sbuild $(DSC)

.PHONY: upload
upload: UPLOAD_DIST ?= $(DEB_DISTRIBUTION)
upload: $(DEB)
	tar cf - $(DEB) | ssh repoman@repo.proxmox.com -- upload --product pve,pmg,pbs --dist $(UPLOAD_DIST)

.PHONY: distclean clean
distclean: clean
clean:
	rm -rf $(PACKAGE)-[0-9]*/ *.deb *.changes *.buildinfo *.build *.tar.?z *.dsc

.PHONY: dinstall
dinstall: $(DEB)
	dpkg -i $(DEB)
