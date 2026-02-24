declare -A msj
msj["dimineata"]="Buna dimineata!"
msj["pranz"]="Buna ziua!"
msj["seara"]="Buna seara!"
msj["noapte"]="Noapte buna!"

ora=$(date +"%H")

if [ $ora -ge 7 ] && [ $ora -lt 12 ]; then
	echo "${msj["dimineata"]}"
elif [ $ora -ge 12 ] && [ $ora -le 17 ]; then
	echo "${msj["pranz"]}"
elif [ $ora -ge 18 ] && [ $ora -le 21 ]; then
	echo "${msj["seara"]}"
else
	echo "${msj["noapte"]}"
fi
