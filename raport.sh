:'
	// LEGENDA:
	ok = ajutator loop
	aux = variabila temporara pentru `extragerea` numelui dintr-un format `ceva.csv`
	l = auxiliar pentru lungime, apoi pentru optiuni meniu
	fis = nr. fisiere
	dir = nr. directoare
	sz = dimensiunea pe disc a fisierelor
'

clear
#### validare nume raport ####
cd ./desktop/home_$nume
ok=0
while [ "$ok" == 0 ]; do
	read -p "Nume raport: [.txt] " raport
	echo -e "\n"
	if [[ "$raport" == *.txt ]]; then
		echo "Extensie .txt detectata. Se extrage..."
		sleep .2s
		l="${#raport}"
		l=$((l-4)) # `stergem` .txt
		aux="${raport:0:l}"
		echo -e "\nEste '$aux' denumirea corecta?\n"
		echo "[1] Da"
		echo -e "[2] Nu\n"
		read l
		if [ "$l" == 1 ]; then
			raport="$aux"
			ok=1
		else
			clear
		fi
	else
		ok=1
	fi
done
ok=0
while [ "$ok" == 0 ]; do
	if [ -e "$raport.txt" ]; then
		clear
		lastDate=$(ls -la "$raport.txt" | sed -E 's/^[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +([^ ]+ +[^ ]+ +[^ ]+).*/\1/')
		echo -e "Raportul '$raport.txt' este deja existent."
		echo -e "Doriti sa fie suprascris? Ultima modificare a fisierului este $lastDate.\n"
		sleep .2s
		echo "[1] Da"
		echo -e "[2] Nu\n"
		read l
		if [ "$l" == 1 ]; then
			ok=1
		else
			clear
			echo -e "Iesire"
			sleep .2s
			clear
			echo -e "Iesire."
			sleep .2s
			clear
			echo -e "Iesire.."
			sleep .2s
			clear
			echo -e "Iesire..."
			sleep .5s
			clear
			return 0
		fi
	else
		ok=1
	fi
done

#### generare propriu-zisa ####
if [ -e "$raport.csv" ]; then
	rm "$raport.csv"
fi
echo "Se genereaza raportul asincron..."
touch "$raport.txt"
fis=$(find . -type f | wc -l)
dir=$(find . -type d | wc -l)
sz=$(du -sh . | cut -f1)
echo -e "///// Raport | User: $nume /////\nNumar fisiere: $fis\nNumar directoare: $dir\nDimensiune pe disc: $sz\n" >> "$raport.txt" &
if [ $? == 0 ]; then # verificam exit statusul pentru echo
	echo -e "\nRaport generat cu succes."
else
	echo -e "\nEroare la generarea raportului."
fi
sleep .5s
read
clear
