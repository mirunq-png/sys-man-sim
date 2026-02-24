check=$(command -v sendmail)
if [ "$check" ]; then
	echo -e "\nSe va incerca trimiterea unui mail de confirmare..."
	#mailul efectiv:
	titlu="Confirmare inregistrare"
	mesaj="Multumit pentru ca ni te-ai alaturat, $nume!"
	echo -e "Subject: $titlu\n\n$mesaj" | sendmail "$adresa"
	if [ $? == 0 ]; then
		echo "Mail trimis cu succes!"
	else
		echo "Eroare la trimiterea mailului. Ne pare rau!"
	fi
else
	echo  "Serviciul sendmail nu este disponibil."
fi
sleep .5s
read
