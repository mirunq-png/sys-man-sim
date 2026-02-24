:'
	// LEGENDA:
	ok = ajutator loop
	aux = selector optiuni
'

cd desktop/home_$nume
clear
if [ ! -e *.txt ]; then
	echo "Nu exista fisiere pe desktop."
	read
	return
fi
ok=0
while [ $ok == 0 ]; do
	clear
	echo "Fisiere pe desktop:"; ls
	echo -e "\n[1] Stergere fisier\n[2] Redenumire fisier\n[3] Iesire\n"
	read aux
	clear
	echo "Fisiere pe desktop:"; ls;
	if [ $aux == 1 ]; then # delete
		echo -e -n "\n"
		read -p "Introdu numele fisierului: " fis
		if [[ ! "$fis" == *.txt ]]; then # atasam extensia daca ea nu exista
			fis="$fis.txt"
		fi
		if [ -e "$fis" ]; then
			echo -e "\nVrei sa stergi $fis?\n[0] Da\n[1] Nu\n"
			read aux2
			if [ $aux2 == 0 ]; then
				rm "$fis"
			fi
		else
			echo -e "\nFisier inexistent."
			read
		fi
	elif [ $aux == 2 ]; then # rename
		echo -e -n "\n"
                read -p "Introdu numele fisierului: " fis
		if [[ ! "$fis" == *.txt ]]; then # atasam extensia daca ea nu e>
                        fis="$fis.txt"
                fi
                if [ -e "$fis" ]; then
			ok2=0
                        read -p "Introdu noul nume: " fis2
			if [[ ! "$fis2" == *.txt ]]; then
				fis2="$fis2.txt"
			fi
			if [ -e "$fis2" ]; then
				echo -n "\nExista deja un fisier cu acest nume."
				read
			else
				mv "$fis" "$fis2"
			fi
                else
                        echo -e "\nFisier inexistent."
                        read
                fi
	elif [ $aux == 3 ]; then # exit
		return 0
	else
		sleep 0s
	fi
done
