:' 	// LEGENDA:
	   Functii:
	pull() = tras carte
	extract() = `extractie` a cifrei din cartea trasa
	suita() = `extractie` a suitei   -------,,-------
	print_hand() = afisare intr-un format lizibil a cartilor
	sum() = calculare suma, convertind J,Q,K in 10 si A avand valoarea 1 sau 11, dupa caz
	----------------------------
	   Variabile: (mai importante)
	deck = contine toate cartile posibile, nu se modifica pe parcurs
	pulled = total carti trase (player+dealer) intr-o anumita runda, se modifica pe parcurs
	player_hand = carti crt. ale playerului
	dealer_hand = self-explanatory
	suma = suma crt. a playerului
	sumadealer = self-explanatory
	blackjack = flag pt. blackjack
	ok = flag pt. oprirea randului playerului
	o = selector de optiuni
'
clear
#### FUNCTII ####
pull() {
while true; do
	aux=$((RANDOM % 52)) # 0-51
        ok=1
	for i in "${pulled[@]}"; do # verificam sa nu fie cartea deja trasa
		if [[ "$i" -eq "$aux" ]]; then
			ok=0
			break # iesire din `while true`, ciclarea continua
		fi
        done
        if [ "$ok" -eq 1 ]; then # inseamna ca nu a mai fost trasa
		echo "$aux"
		return # iesire din pull()
	fi
done
}

extract() {
str="$1"
len="${#str}"
echo "${str:0:len-1}" # printam pana la penultima pozitie
# ex. 12T => 12; 4R => 4;
}

suita() {
str="$1"
len="${#str}"
aux="${str:len-1}" # luam ultima pozitie
if [ "$aux" == i ]; then
	echo "♥"
elif [ "$aux" == r ]; then
	echo "♦"
elif [ "$aux" == t ]; then
	echo "♣"
else
	echo "♠"
fi
}

print_hand() {
local hand=("$@") # preluam mana (ex. contine 0 12 34)
local output="" # `mana` frumoasa
for card in "${hand[@]}"; do # in `hand` se afla valorile brute
	cif=$(extract "${deck[$card]}")
	suit=$(suita "${deck[$card]}")
	if [ "$cif" == 1 ]; then
		cif="A"
        elif [ "$cif" == 11 ]; then # indexarea fiind de la 0, `11` este de fapt `12`, deci J
		cif="J"
	elif [ "$cif" == 12 ]; then
		cif="Q"
	elif [ "$cif" == 13 ]; then
		cif="K"
	fi
	output+="[$cif$suit] | "
done
	echo "$output"
}

sum() {
local hand=("$@")
local total=0
local aces=0
for card in "${hand[@]}"; do
	cif=$(extract "${deck[$card]}")
        if [ "$cif" -gt 10 ]; then # in blackjack, J,Q,K au valoarea 10
		cif=10
	elif [ "$cif" == 1 ]; then # contorizam nr. de asi
		aces=$((aces + 1))
		cif=11
	fi
	s=$((s + cif))
done
while [ "$s" -gt 21 ] && [ "$aces" -gt 0 ]; do # daca asul provoaca un bust, acesta va avea valoarea 1 (ca sa ajungem de la 11 la 1, scadem 10)
	s=$((s - 10))
	aces=$((aces - 1))
done
echo "$s"
}

#### MAIN ####
clear
scor=100
echo -e "Bun venit la Blackjack! Vei juca 3 runde.\nApasa enter pentru a continua..."
read

for ((runda=1; runda<=3; runda++)); do
clear
echo "========== RUNDA $runda =========="
echo "Sold curent: $scor$"
read -p "Introdu suma pariului: " pariu
while ! [[ "$pariu" =~ ^[0-9]+$ ]] || [ "$pariu" -gt "$scor" ] || [ "$pariu" -eq 0 ]; do
	# tb. sa contina doar cifre, sa fie mai mic decat scorul si sa fie diferit de zero
	read -p "Eroare. Introdu un numar între 1 și $scor: " pariu
done

#initializari#
deck=()
for value in {1..13}; do # generare pachet, intern A=1, J=11, Q=12, K=13
	for suit in i r t n; do
		deck+=("${value}${suit}")
	done
done
pulled=()
player_hand=()
dealer_hand=()
for x in {1..2}; do # impartire carti in ordinea P, D, P, D
	card=$(pull); pulled+=("$card"); player_hand+=("$card")
	card=$(pull); pulled+=("$card"); dealer_hand+=("$card")
done
suma=$(sum "${player_hand[@]}")
sumadealer=$(sum "${dealer_hand[@]}")
blackjack=0 # flag pt. blackjack
gata=0 # flag pt. oprirea randului playerului

#### RANDUL PLAYERULUI ####
while [ "$gata" == 0 ]; do
	clear
	echo "============RUNDA $runda============"
	echo -e "[1] Hit\n[2] Stand\n[3] Double down\n[0] Quit"
	echo "-----------------------------------"
	echo "Se trag cartile..."
	echo -n "Mana dealer: "
	echo "$(print_hand "${dealer_hand[0]}") [?]"
	echo -n "Mana ta: "
	echo "$(print_hand "${player_hand[@]}")"
	echo "Total: $suma"
	echo "-----------------------------------"
	if [ "$suma" == 21 ]; then
		blackjack=1
		gata=1
		break # iesire din `while`
	elif [ "$suma" -gt 21 ]; then
		gata=1
		break
	fi
	read -s -n1 o # optiunea -n1 ajuta la citirea unui caracter, fara sa fie nevoie de enter
	if [ "$o" == "1" ]; then # hit
		card=$(pull); pulled+=("$card"); player_hand+=("$card")
		suma=$(sum "${player_hand[@]}")
		if [ "$suma" == 21 ]; then
			echo "BLACKJACK!"
			blackjack=1
			gata=1
			break
		elif [ "$suma" -gt 21 ]; then
			echo "Bust!"
			gata=1
			break
        	fi
	elif [ "$o" == "2" ]; then # stand
                    	 gata=1
	elif [ "$o" == "3" ]; then # double
		if [ "$pariu" -le "$((scor - pariu))" ]; then
			pariu=$((pariu * 2))
			card=$(pull); pulled+=("$card"); player_hand+=("$card")
			suma=$(sum "${player_hand[@]}")
			gata=1
		else
			echo "Fonduri insuficiente pentru double down!"
			sleep .5s
		fi
	elif [ "$o" == "0" ]; then # quit
		return
	fi
done

#### RANDUL DEALERULUI ####
sansa=$(( RANDOM % 100 )) # 50% sansa sa traga o carte
while [ "$sumadealer" -lt 17 ] && [ "$suma" -lt 21 ] && [ $sansa -le 50 ]; do
	card=$(pull); pulled+=("$card"); dealer_hand+=("$card")
	sumadealer=$(sum "${dealer_hand[@]}")
done

#### FINAL RUNDA ####
clear
echo "============RUNDA $runda - FINALIZARE============"
echo "Mana dealer: $(print_hand "${dealer_hand[@]}") (Total: $sumadealer)"
echo "Mana ta: $(print_hand "${player_hand[@]}") (Total: $suma)"
echo "-----------------------------------"
if [ "$suma" -gt 21 ]; then
	echo "Bust!"
	scor=$((scor - pariu))
elif [ "$sumadealer" -gt 21 ] || [ "$suma" -gt "$sumadealer" ]; then
	if [ "$blackjack" == 1 ]; then
		echo "BLACKJACK! Scor 1.5x!"
		x=$((pariu + pariu / 2))
		scor=$((scor + x))
         else
		echo "Ai castigat!"
		scor=$((scor + pariu))
	fi
elif [ "$suma" == "$sumadealer" ]; then
	echo "Egalitate!"
else
	echo "Ai pierdut..."
	scor=$((scor - pariu))
fi

if [ "$scor" -le 0 ]; then
	echo "Ai ramas fara bani! Joc terminat."
	echo "Apasa enter pentru a iesi..."
	runda=100 # iesire fortata
	read
else
	echo "Sold ramas: $scor$"
	echo "Apasa enter pentru a continua..."
	read
fi
done
clear
if [ ! "$scor" == 0 ]; then
	echo "=============================="
	echo "Joc terminat. Sold final: $scor$"
	echo "Apasa enter pentru a iesi."
read
fi
