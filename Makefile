RM := rm -rf
CP := cp -r
MKDIR := mkdir -p
SED := sed

VERSION := 0.0.7.6-web
APP := Drcom4CWNU-$(VERSION)

ipk: drcom-lua
	$(MKDIR) ./usr/lib/lua/luci/controller/
	$(MKDIR) ./usr/lib/lua/luci/model/cbi/
	$(MKDIR) ./etc/config/
	$(MKDIR) ./etc/init.d/
	$(MKDIR) ./etc/rc.d/
	$(MKDIR) ./overlay/Drcom4CWNU/
	$(MKDIR) ./usr/bin/
	sed -i '/VERSION/s/[0-9]\.[0-9]\.[0-9]\.[0-9][a-z-]\+/$(VERSION)/' luci/Drcom4CWNU.cbi.lua
	$(CP) luci/Drcom4CWNU.reg.lua             ./usr/lib/lua/luci/controller/Drcom4CWNU.lua
	$(CP) luci/Drcom4CWNU.cbi.lua             ./usr/lib/lua/luci/model/cbi/Drcom4CWNU.lua
	$(CP) luci/drcomrc.etc                    ./etc/config/drcomrc
	$(CP) scripts/drcom.sh                    ./etc/init.d/drcom.sh
	chmod +x                                  ./etc/init.d/drcom.sh
	$(CP) scripts/drcom-daemon.sh             ./etc/init.d/drcom-daemon
	chmod +x                                  ./etc/init.d/drcom-daemon
	ln -sf /etc/init.d/drcom-daemon           ./etc/rc.d/S98drcom-daemon
	$(CP) scripts/wr2drcomrc.sh               ./overlay/Drcom4CWNU/wr2drcomrc.sh
	chmod +x                                  ./overlay/Drcom4CWNU/wr2drcomrc.sh
	$(CP) scripts/wr2wireless.sh              ./overlay/Drcom4CWNU/wr2wireless.sh
	chmod +x                                  ./overlay/Drcom4CWNU/wr2wireless.sh
	$(CP) drcom                               ./overlay/Drcom4CWNU/drcom
	chmod +x                                  ./overlay/Drcom4CWNU/drcom
	$(CP) config.lua                          ./overlay/Drcom4CWNU/config.lua
	$(CP) core.lua                            ./overlay/Drcom4CWNU/core.lua
	$(CP) md5.lua                             ./overlay/Drcom4CWNU/md5.lua
	$(CP) tools/random_mac                    ./usr/bin/random_mac
	chmod +x                                  ./usr/bin/random_mac
	$(CP) tools/webget                        ./usr/bin/webget
	chmod +x                                  ./usr/bin/webget
	$(CP) scripts/pass-local.sh               ./usr/bin/pass-local.sh
	chmod +x                                  ./usr/bin/pass-local.sh
	$(CP) scripts/autoreboot.sh               ./usr/bin/autoreboot.sh
	chmod +x                                  ./usr/bin/autoreboot.sh
	$(CP) scripts/wr2pass-local.sh            ./overlay/Drcom4CWNU/wr2pass-local.sh
	chmod +x                                  ./overlay/Drcom4CWNU/wr2pass-local.sh
	$(CP) scripts/update.sh                   ./overlay/Drcom4CWNU/update.sh
	chmod +x                                  ./overlay/Drcom4CWNU/update.sh
	$(CP) scripts/update-daemon.sh            ./overlay/Drcom4CWNU/update-daemon.sh
	chmod +x                                  ./overlay/Drcom4CWNU/update-daemon.sh
	tar -czf data.tar.gz ./usr ./etc ./overlay
	$(CP) ipk/control                         ./control
	$(CP) ipk/postinst                        ./postinst
	chmod +x                                  ./postinst
	$(SED) -i "s/Version.*/Version: $(VERSION)/"                                  ./control
	$(SED) -i "s/Installed-Size.*/Installed-Size: `du -b data.tar.gz | cut -f1`/" ./control
	$(SED) -i "s/Architecture.*/Architecture: all/" ./control;
	tar -czf ./control.tar.gz ./control ./postinst
	$(CP) ipk/debian-binary                   ./debian-binary
	tar -czf $(APP).ipk ./data.tar.gz ./debian-binary ./control.tar.gz
	$(RM) ./usr ./etc ./overlay ./data.tar.gz ./debian-binary ./control.tar.gz ./control ./postinst

clean:
	$(RM) $(APP)* *.ipk
distclean: clean
	$(RM) drcom config.lua core.lua

drcom-lua: cwnu-drcom.lua/drcom.lua cwnu-drcom.lua/src/core.lua cwnu-drcom.lua/src/config.lua
	$(SED) -f patch.sed cwnu-drcom.lua/drcom.lua > drcom
	chmod +x drcom
	$(SED) -f patch.sed cwnu-drcom.lua/src/core.lua > core.lua
	$(SED) -f patch.sed cwnu-drcom.lua/src/config.lua > config.lua

.PHONY: ipk clean drcom-lua
