#!/bin/bash

###############################################
# Installation module for basic iptables rules
###############################################

iptablespersistent="/etc/init.d/iptables-persistent"
rulesv4="/etc/iptables/rules.v4"
rulesv6="/etc/iptables/rules.v6"

if [ ! -d "/etc/iptables" ]
then
	echo "Creating dir '/etc/iptables'"
	mkdir /etc/iptables
fi

if [ ! -f "$iptablespersistent" ]
then
	echo '#!/bin/sh' >> $iptablespersistent
	echo '#		Written by Simon Richter <sjr@debian.org>' >> $iptablespersistent
	echo '#		modified by Jonathan Wiltshire <jmw@debian.org>' >> $iptablespersistent
	echo '#		with help from Christoph Anton Mitterer' >> $iptablespersistent
	echo '#' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '### BEGIN INIT INFO' >> $iptablespersistent
	echo '# Provides:          iptables-persistent' >> $iptablespersistent
	echo '# Required-Start:    mountkernfs $local_fs' >> $iptablespersistent
	echo '# Required-Stop:     $local_fs' >> $iptablespersistent
	echo '# Default-Start:     2 3 4 5' >> $iptablespersistent
	echo '# Default-Stop:      0 1 6' >> $iptablespersistent
	echo '# X-Start-Before:    $network' >> $iptablespersistent
	echo '# X-Stop-After:      $network' >> $iptablespersistent
	echo '# Short-Description: Set up iptables rules' >> $iptablespersistent
	echo '### END INIT INFO' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '. /lib/lsb/init-functions' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo 'rc=0' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo 'load_rules()' >> $iptablespersistent
	echo '{' >> $iptablespersistent
	echo '	log_action_begin_msg "Loading iptables rules"' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '	#load IPv4 rules' >> $iptablespersistent
	echo '	if [ ! -f /etc/iptables/rules.v4 ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " skipping IPv4 (no rules to load)"' >> $iptablespersistent
	echo '	else' >> $iptablespersistent
	echo '		log_action_cont_msg " IPv4"' >> $iptablespersistent
	echo '		iptables-restore < /etc/iptables/rules.v4 2> /dev/null' >> $iptablespersistent
	echo '		if [ $? -ne 0 ]; then' >> $iptablespersistent
	echo '			rc=1' >> $iptablespersistent
	echo '		fi' >> $iptablespersistent
	echo '	fi' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '	#load IPv6 rules	' >> $iptablespersistent
	echo '	if [ ! -f /etc/iptables/rules.v6 ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " skipping IPv6 (no rules to load)"' >> $iptablespersistent
	echo '	else' >> $iptablespersistent
	echo '		log_action_cont_msg " IPv6"' >> $iptablespersistent
	echo '		ip6tables-restore < /etc/iptables/rules.v6 2> /dev/null' >> $iptablespersistent
	echo '		if [ $? -ne 0 ]; then' >> $iptablespersistent
	echo '			rc=1' >> $iptablespersistent
	echo '		fi' >> $iptablespersistent
	echo '	fi' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '	log_action_end_msg $rc' >> $iptablespersistent
	echo '}' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo 'save_rules()' >> $iptablespersistent
	echo '{' >> $iptablespersistent
	echo '	log_action_begin_msg "Saving rules"' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '	#save IPv4 rules' >> $iptablespersistent
	echo '	#need at least iptable_filter loaded:' >> $iptablespersistent
	echo '	/sbin/modprobe -q iptable_filter' >> $iptablespersistent
	echo '	if [ ! -f /proc/net/ip_tables_names ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " skipping IPv4 (no modules loaded)"' >> $iptablespersistent
	echo '	elif [ -x /sbin/iptables-save ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " IPv4"' >> $iptablespersistent
	echo '		iptables-save > /etc/iptables/rules.v4' >> $iptablespersistent
	echo '		if [ $? -ne 0 ]; then' >> $iptablespersistent
	echo '			rc=1' >> $iptablespersistent
	echo '		fi' >> $iptablespersistent
	echo '	fi' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '	#save IPv6 rules' >> $iptablespersistent
	echo '	#need at least ip6table_filter loaded:' >> $iptablespersistent
	echo '	/sbin/modprobe -q ip6table_filter' >> $iptablespersistent
	echo '	if [ ! -f /proc/net/ip6_tables_names ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " skipping IPv6 (no modules loaded)"' >> $iptablespersistent
	echo '	elif [ -x /sbin/ip6tables-save ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " IPv6"' >> $iptablespersistent
	echo '		ip6tables-save > /etc/iptables/rules.v6' >> $iptablespersistent
	echo '		if [ $? -ne 0 ]; then' >> $iptablespersistent
	echo '			rc=1' >> $iptablespersistent
	echo '		fi' >> $iptablespersistent
	echo '	fi' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '	log_action_end_msg $rc' >> $iptablespersistent
	echo '}' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo 'flush_rules()' >> $iptablespersistent
	echo '{' >> $iptablespersistent
	echo '	log_action_begin_msg "Flushing rules"' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '	if [ ! -f /proc/net/ip_tables_names ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " skipping IPv4 (no module loaded)"' >> $iptablespersistent
	echo '	elif [ -x /sbin/iptables ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " IPv4"' >> $iptablespersistent
	echo '		for param in F Z X; do /sbin/iptables -$param; done' >> $iptablespersistent
	echo '		for table in $(</proc/net/ip_tables_names)' >> $iptablespersistent
	echo '		do' >> $iptablespersistent
	echo '			/sbin/iptables -t $table -F' >> $iptablespersistent
	echo '			/sbin/iptables -t $table -Z' >> $iptablespersistent
	echo '			/sbin/iptables -t $table -X' >> $iptablespersistent
	echo '		done' >> $iptablespersistent
	echo '		for chain in INPUT FORWARD OUTPUT' >> $iptablespersistent
	echo '		do' >> $iptablespersistent
	echo '			/sbin/iptables -P $chain ACCEPT' >> $iptablespersistent
	echo '		done' >> $iptablespersistent
	echo '	fi' >> $iptablespersistent
	echo '	' >> $iptablespersistent
	echo '	if [ ! -f /proc/net/ip6_tables_names ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " skipping IPv6 (no module loaded)"' >> $iptablespersistent
	echo '	elif [ -x /sbin/ip6tables ]; then' >> $iptablespersistent
	echo '		log_action_cont_msg " IPv6"' >> $iptablespersistent
	echo '		for param in F Z X; do /sbin/ip6tables -$param; done' >> $iptablespersistent
	echo '		for table in $(</proc/net/ip6_tables_names)' >> $iptablespersistent
	echo '		do' >> $iptablespersistent
	echo '			/sbin/ip6tables -t $table -F' >> $iptablespersistent
	echo '			/sbin/ip6tables -t $table -Z' >> $iptablespersistent
	echo '			/sbin/ip6tables -t $table -X' >> $iptablespersistent
	echo '		done' >> $iptablespersistent
	echo '		for chain in INPUT FORWARD OUTPUT' >> $iptablespersistent
	echo '		do' >> $iptablespersistent
	echo '			/sbin/ip6tables -P $chain ACCEPT' >> $iptablespersistent
	echo '		done' >> $iptablespersistent
	echo '	fi' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo '	log_action_end_msg 0' >> $iptablespersistent
	echo '}' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo 'case "$1" in' >> $iptablespersistent
	echo 'start|restart|reload|force-reload)' >> $iptablespersistent
	echo '	load_rules' >> $iptablespersistent
	echo '	;;' >> $iptablespersistent
	echo 'save)' >> $iptablespersistent
	echo '	save_rules' >> $iptablespersistent
	echo '	;;' >> $iptablespersistent
	echo 'stop)' >> $iptablespersistent
	echo '	# Why? because if stop is used, the firewall gets flushed for a variable' >> $iptablespersistent
	echo '	# amount of time during package upgrades, leaving the machine vulnerable' >> $iptablespersistent
	echo '	# It is also not always desirable to flush during purge' >> $iptablespersistent
	echo '	echo "Automatic flushing disabled, use \"flush\" instead of \"stop\""' >> $iptablespersistent
	echo '	;;' >> $iptablespersistent
	echo 'flush)' >> $iptablespersistent
	echo '	flush_rules' >> $iptablespersistent
	echo '	;;' >> $iptablespersistent
	echo '*)' >> $iptablespersistent
	echo '    echo "Usage: $0 {start|restart|reload|force-reload|save|flush}" >&2' >> $iptablespersistent
	echo '    exit 1' >> $iptablespersistent
	echo '    ;;' >> $iptablespersistent
	echo 'esac' >> $iptablespersistent
	echo '' >> $iptablespersistent
	echo 'exit $rc' >> $iptablespersistent
	chmod +x $iptablespersistent
	update-rc.d -f iptables-persistent defaults >> $logfile 2>&1
else
	echo "iptables-persistent already installed."
fi

if [ ! -f "$rulesv4" ]
then
	echo "Installing ipv4 rules."
	echo "*filter" > $rulesv4
	echo "" >> $rulesv4
        echo ":INPUT DROP [0:0]" >> $rulesv4
        echo ":FORWARD DROP [0:0]" >> $rulesv4
	echo ":OUTPUT DROP [0:0]" >> $rulesv4
	echo "" >> $rulesv4
	echo "# Allows all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0" >> $rulesv4
	echo "-A INPUT -i lo -j ACCEPT" >> $rulesv4
	echo "-A INPUT ! -i lo -d 127.0.0.0/8 -j DROP" >> $rulesv4
	echo "" >> $rulesv4
	echo "# Accepts all established inbound connections" >> $rulesv4
	echo "-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> $rulesv4
	echo "" >> $rulesv4
	echo "# Allows all outbound traffic" >> $rulesv4
	echo "# You could modify this to only allow certain traffic" >> $rulesv4
	echo "-A OUTPUT -j ACCEPT" >> $rulesv4
	echo "" >> $rulesv4
	echo "COMMIT" >> $rulesv4

	echo "Applying ipv4 rules."
	iptables-restore $rulesv4
else
	echo "$rulesv4 already exists, skipping."
fi

if [ ! -f "$rulesv6" ]
then
	echo "Installing ipv6 rules."
	echo "*filter" >> $rulesv6
	echo "" >> $rulesv6
	echo ":INPUT DROP [0:0]" >> $rulesv6
	echo ":FORWARD DROP [0:0]" >> $rulesv6
	echo ":OUTPUT DROP [0:0]" >> $rulesv6
	echo "" >> $rulesv6
	echo "COMMIT" >> $rulesv6

	echo "Applying ipv6 rules."
	ip6tables-restore $rulesv6
else
	echo "$rulesv6 already exists, skipping."
fi

norpfilter=$(grep '#net.ipv4.conf.all.rp_filter=1' /etc/sysctl.conf)
if [ "$norpfilter" ]
then
	echo "Enabling rp_filter in /etc/sysctl.conf."
	sed -i 's/#net.ipv4.conf.default.rp_filter=1/net.ipv4.conf.default.rp_filter=1/g' /etc/sysctl.conf
	sed -i 's/#net.ipv4.conf.all.rp_filter=1/net.ipv4.conf.all.rp_filter=1/g' /etc/sysctl.conf
else
	echo "rp_filter already enabled."
fi
