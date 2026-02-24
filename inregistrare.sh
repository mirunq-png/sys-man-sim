: '
	// LEGENDA
	ok1 = ajutator loop introducere user
	ok2 = ajutator loop introducere parola
	ok3 = ajutator loop introducere mail
'
clear
echo "Inregistrare noua."
sleep .2s
clear
echo "Inregistrare noua.."
sleep .2s
clear
echo "Inregistrare noua..."
sleep 1s
clear
#### citire user ####
ok1=0
ok2=0
ok3=0
while [ $ok1 == 0 ]; do
	read -p "Nume de utilizator: " nume
	if [ -n "${user[$nume]+unset}" ]; then
		echo -e "\nUtilizator deja inregistrat."
		sleep .2s
		echo -e "\nRedirectionare..."
		sleep .5s
		clear
		return 0
	elif [ ${#nume} -lt 3 ]; then
		echo -e "\nUtilizatorul trebuie sa contina minim 3 caractere."
		sleep .5s
		clear
	elif [ ${#nume} -gt 20 ]; then
		echo -e "\nUtilizatorul nu poate sa contina peste 20 de caractere."
		sleep .5s
		clear
	elif [[ ! "$nume" =~ ^[A-Za-z0-9]+$ ]]; then
		echo -e "\nUtilizatorul contine caractere invalide."
		sleep .5s
		clear
	else
		ok1=1
	fi
done
user["$nume"]="$nume"

#### parola ####
while [ "$ok2" == 0 ]; do
	read -s -p "Parola: " parola
	if [[ ! "$parola" =~ ^[A-Za-z0-9_@-]+$ ]]; then # poate contine litere mari, mici, `_`,`@`,`-`
		echo -e "\nParola contine caractere invalide."
		sleep .5s
		clear
		echo -e "Nume de utilizator: $nume"
	elif [ "${#parola}" -lt 8 ]; then
		echo -e "\nParola nu contine minim 8 caractere."
		sleep .5s
		clear
		echo -e "Nume de utilizator: $nume"
	else
		ok2=1
	fi
done
parolaHash=$(echo -n "$parola" | sha256sum | sed 's/ .*//') # aplicam sed pentru ca sha256sum are ca output `<<gibberish>> -`si sa ramana doar `<<gibberish..`
password["$nume"]="$parolaHash"

#### email #####
echo -e ""
while [ "$ok3" = 0 ]; do
	read -p "Email: " adresa
	if [[ "$adresa" =~  ^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
		ok3=1
	else
		echo "Adresa invalida."
		sleep .5s
		clear
		echo -e "Nume de utilizator: $nume"
		echo -e "Parola: "
	fi
done
mail["$nume"]="$adresa"

#### id ####
id=$((100000 + RANDOM % 900000)) # generam un ID de 6 cifre
userID["$nume"]=$id

#### trimitere mail - varianta locala ####
#check=$(command -v sendmail) # verificam daca exista `sendmail`. comanda returneaza calea unde se afla
#if [ "$check" ]; then
#	echo -e "\nSe va incerca trimiterea unui mail de confirmare. Aveti rabdare!\n"
#	destinatar=$(whoami) # mailul va fi trimis local
#	echo -e "To: $destinatar\nSubject: Cont creat cu succes!\nBody: Multumim ca ni te-ai alaturat, $nume!" | sendmail -t
#	if [ $? == 0 ]; then
#		echo "Mail trimis cu succes! Acesta poate fi accesat la iesirea din sistem prin comanda 'mail'."
#	else
#		echo "Eroare la trimiterea mailului."
#	fi
#else
#	echo "Serviciul sendmail nu este disponibil."
#fi
#sleep .5s
#read

#### trimitere mail - varianta for real ####
. mail.sh

#introducerea datelor in .csv
echo "$id||$nume||$parolaHash||$adresa||lastLogin$id" >> date.csv
cd amintiri
echo "$id" >> ID.csv
echo "$nume" >> user.csv
echo "$parolaHash" >> pass.csv
echo "$adresa" >> mail.csv
cd ..
cd desktop
mkdir home_$nume
cd ..
clear
