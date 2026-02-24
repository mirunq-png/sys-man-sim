clear
: '
	// LEGENDA:
	cnt = permite 3 incercari pt. parola
	    = flag pentru logged_in_users mai tarziu in main.sh
'
read -p "Introduceti numele de utilizator: " nume

if [[ -n "${logged_in_users[$nume]+isset}" ]]; then
	echo -e "\nUtilizatorul '$nume' este deja conectat."
	cnt=69
	sleep .2s
	echo -e "\nRedirectionare..."
	sleep .5s
	clear
	succes=1
elif [[ -n "${user[$nume]+unset}" ]]; then
	cnt=3
	while [ $cnt -gt 0 ]; do
		clear
		echo -e "Introduceti parola pentru '$nume'.\n"
    		read -s -p "Incercarea nr. $cnt: " parola
		parolaHash=$(echo -n "$parola" | sha256sum | sed 's/ .*//')
    		if [ ${password[$nume]} == $parolaHash ]; then
        		cnt=-1
    		else
        		((cnt--))
    		fi
	done
	if [ $cnt == 0 ]; then
    		clear
    		echo "Accesare ilegala. Se inchide programul."
    		sleep .2s
    		clear
    		echo "Accesare ilegala. Se inchide programul.."
    		sleep .2s
    		clear
    		echo "Accesare ilegala. Se inchide programul..."
    		sleep .5s
    		exit
	fi
	succes=1
	logged_in_users["$nume"]="$nume"
else
	echo -e "\nUtilizatorul '$nume' nu este inregistrat."
	sleep .2s
	echo -e "\nRedirectionare..."
	sleep .5s
fi
clear
