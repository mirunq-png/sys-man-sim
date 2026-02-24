#!/bin/bash
: '
	// LEGENDA:
	   Variabile:
	running = ajuta la intoarcerea la inceputul scriptului
	succes = daca s-a facut autentificarea cu succes (devine 1 in autentificare.sh)
	online = cand cineva este `activ` pe pagina de desktop
	aux = selector de optiuni
	----------------------------
	   Arrays:
	user = self-explanatory
	userID = -----,,-------
	password = ----,,------
	mail = --------,,------
	logged_in_users = --,--
	----------------------------
	  Fisiere, directoare
	desktop = aici se afla home-ul pentru fiecare user
	amintiri = aici se retin datele pentru a permite re-rularea scriptului fara probleme din cauza redeclararii array-urilor
		\__ gasim .csv-ul corespunzator pentru fiecare array
	date.csv = baza de date fancy pentru ID, user, parola, mail si last login
'
if [ ! -d desktop ]; then
	mkdir desktop
fi
if [ ! -e date.csv ]; then
	touch date.csv
	echo "[ID] || [Username] || [Password] || [E-mail] || [Last login]" > date.csv
fi
declare -A user
declare -A userID
declare -A password
declare -A mail
declare -A logged_in_users
if [ ! -d amintiri ]; then
	mkdir amintiri
	cd amintiri
	touch user.csv
	touch ID.csv
	touch pass.csv
	touch mail.csv
	touch logged.csv
	cd ..
else
	cd amintiri
	#preluam datele din sesiunile trecute
	while IFS=$'\t' read -r u i p m l; do
		user["$u"]="$u"
		userID["$u"]="$i"
		password["$u"]="$p"
		mail["$u"]="$m"
		if [ -n "$l" ]; then # pentru evitarea problemelor in cazul in care userul nu este conectat si .csv e gol
			logged_in_users["$l"]="$l"
		fi
	done < <(paste user.csv ID.csv pass.csv mail.csv logged.csv)
	cd ..
fi
succes=0
running=1
while [ $running == 1 ]; do
clear
. greeting.sh

#### log-in ####
while [ $succes == 0 ]; do
# { debug
#echo "Debug ce se afla in memorie:"
#echo "users: ${user[@]}"
#echo "ids: ${userID[@]}"
#echo "pass: ${password[@]}"
#echo "mails: ${mail[@]}"
#echo "logged: ${logged_in_users[@]}"
#echo -e "Sfarsit debug\n"
# }
	sleep .2s
	echo -e "Ce doresti sa faci?\n"
	sleep .2s
	echo -e "[1] Inregistrare\n"
#	sleep .2s
	echo -e "[2] Autentificare\n"
#	sleep .2s
	echo -e "[3] Resetare program*\n"
#	sleep .2s
	read aux
	if [ $aux == 1 ]; then
		. inregistrare.sh
	elif [ $aux == 2 ]; then
		. autentificare.sh
	elif [ $aux == 3 ]; then
		clear
		echo -e "ATENTIE!!!\n\nAsta va reseta baza de date, desktopul, folderele etc.\n"
#		sleep .5s
		echo -e "Esti sigur ca vrei sa faci asta?\n"
		sleep .2s
		echo -e "\n[0] DA"
#		sleep .2s
		echo -e "\n[1] NU\n"
#		sleep .2s
		read aux2
		if [ $aux2 == 0 ]; then
			rm date.csv
			rm -r desktop
			rm -r amintiri
			clear
			exit
		fi
		clear
	else
		clear
	fi
done

#### contul este acum autentificat ####
online=1
logged_in_users["$nume"]="$nume"
if [ $cnt -ne 69 ]; then # cnt este si flagul de la autentificare pt. user deja conectat si sa evitam scrierea de mai multe ori a numelui in logged.csv
	cd amintiri
	echo "$nume" >> logged.csv
	cd ..
fi
dataCrt=$(date +"%d/%m/%y %H:%M:%S")
id=${userID["$nume"]} # pt. usurinta in sed-ul de mai jos
sed -i "/^$id||$nume||/ s#\(.*||.*||.*||.*||\).*#\1$dataCrt#" date.csv # schimbam al 5-lea camp (=last login) cu data curenta
cd desktop
cd home_$nume
while [ $online == 1 ]; do
	echo -e "Buna, $nume!\nTe afli in directorul $PWD\n"
	echo -e "Ce doresti sa faci?\n"
	sleep .2s
	echo -e "[1] Generare raport\n"
	echo -e "[2] Gestiune fisiere\n"
	echo -e "[3] Vizualizare utilizatori online\n"
	echo -e "[4] Blackjack ♠\n"
	echo -e "[5] Alta autentificare\n"
	echo -e "[6] Deconectare\n"
	read aux
	if [ $aux == 1 ]; then
		clear
		cd ../.. # ne mutam in directorul unde se afla scriptul
		. raport.sh
        elif [ $aux == 2 ]; then
                cd ../..
                . gestiune.sh
                clear
	elif [ $aux == 3 ]; then
                clear
                echo "Utilizatori online: ${logged_in_users[@]}"
#               echo -e "\nApasa orice pentru a continua."
                read # simulam `apasatul`
                clear
	elif [ $aux == 4 ]; then
                cd ../..
                . blackjack.sh
                cd desktop/home_$nume
                clear
        elif [ $aux == 5 ]; then
                cd ../..
                succes=0
                online=0
                clear
	elif [ $aux == 6 ]; then
		cd ../..
		unset logged_in_users["$nume"] # s-a deconectat, il scoatem din logged_in_users
		cd amintiri
		sed -i "/^$nume$/d" logged.csv # il scoatem si din .csv
		cd ..
		succes=0
		online=0
		clear
	else
		clear
	fi
done
done
