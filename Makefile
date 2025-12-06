all: help
help:
	cat Makefile
e1:
	./extract1.sh
e2:
	perl extract2.pl notified.list > bugzilla-pkg.list
e3:
	perl extract3.pl bugzilla-pkg.list > out/bugzillapkgdata.json
publish:
	xz -c9 out/bugzillapkgdata.json > out/bugzillapkgdata.json.xz ; cp -afl out/bugzillapkgdata.json.xz ~/public_html/linux/opensuse/bugzilla/
