RM := rm -rf
CP := cp -r
MKDIR := mkdir -p
SED := sed

VERSION := 0.0.5.1-web
APP := Drcom4CWNU-$(VERSION)

ipk: drcom-lua
	$(MKDIR) ./usr/lib/lua/luci/controller/
	$(MKDIR) ./usr/lib/lua/luci/model/cbi/
	$(MKDIR) ./etc/config/
	$(MKDIR) ./etc/init.d/
	$(MKDIR) ./etc/rc.d/
	$(MKDIR) ./overlay/Drcom4CWNU/
	$(MKDIR) ./usr/bin/
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
	$(CP) random_mac                          ./usr/bin/random_mac
	chmod +x                                  ./usr/bin/random_mac
	tar -czf data.tar.gz ./usr ./etc ./overlay
	$(CP) ipk/control                         ./control
	$(SED) -i "s/Version.*/Version: $(VERSION)/"                                  ./control
	$(SED) -i "s/Installed-Size.*/Installed-Size: `du -b data.tar.gz | cut -f1`/" ./control
	$(SED) -i "s/Architecture.*/Architecture: all/" ./control;
	tar -czf ./control.tar.gz ./control
	$(CP) ipk/debian-binary                   ./debian-binary
	tar -czf $(APP).ipk ./data.tar.gz ./debian-binary ./control.tar.gz
	$(RM) ./usr ./etc ./overlay ./data.tar.gz ./debian-binary ./control.tar.gz ./control

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
