#!/bin/bash
function dodajbibl #w przypadku posiadania blibliotek aktualizuje, w przypadku nie posiadania - ściąga
{				   #funcje są konieczne do poprawnego działania programu (:
	sudo apt-get install lame
	sudo apt-get install ffmpeg
	sudo apt-get install youtube-dl
}
function wavNAmp3 #funkcja konwertująca pliki .wav na .mp3
{
for i in *.wav; do
 if [ -e "$i" ]; then
   plik=`basename "$i" .wav` #pobieranie nazwy (z pliku plik.wav pobiera nazwe plik)
   lame -h -b 192 "$i" "$plik.mp3" #konwersja. Zapisuje jako plik.mp3
   rm "$i" #usuwa gorszą wersję (.wav)
 fi
done
}

function usunwav
{
for i in *.wav; do
 if [ -e "$i" ]; then
   rm "$i"
 fi
done
}

function usunmp3
{
for i in *.mp3; do
 if [ -e "$i" ]; then
   rm "$i"
 fi
done
}

function wieleplikow
{
	while read zrodlo; do
	tytul="$(youtube-dl --get-title $zrodlo)"
	id="$(youtube-dl --get-filename $zrodlo)"
	echo "Ściągam $tytul"
	youtube-dl $zrodlo #sciaga wybrany tytul z pliki.txt
	ffmpeg -i "$id" "$tytul.wav" #wyciąga ścieżkę dźwiękową z video i zapisuje jako tytuł.wav
	
	echo "$tytul.wav" | grep -q " " #funkcja zamieniająca spacje na "_" z Pana strony (bo to jest bad thing)     
     if [ $? -eq 0 ]                   
     then
       fname="$tytul.wav"                     
       n=$(echo $fname | sed -e "s/ /_/g")  
       mv "$fname" "$n"                     
     fi
     rm "$id" #usuwa oryginalną wersję wideo (jak ktoś chce można wykomentować i będzie się miało zarówno video jak i .wav, ale ja nie lubię 
     
	done < pliki.txt #stąd pobiera linki
}
function sciagnijyt #to samo co wieleplikow, tylko dla pojedynczego pliku z YT
{
	echo "Podaj link"
	read link
	tytul="$(youtube-dl --get-title $link)"
	id="$(youtube-dl --get-filename $link)"
	echo "Ściągam $tytul"
	youtube-dl $link
	ffmpeg -i "$id" "$tytul.wav"
	
	echo "$tytul.wav" | grep -q " "         
     if [ $? -eq 0 ]                   
     then
       fname="$tytul.wav"                     
       n=$(echo $fname | sed -e "s/ /_/g")  
       mv "$fname" "$n"                     
     fi
     rm "$id"
	
}
echo "Wybierz jedną z dostępnych opcji"
select x in "Dodaj potrzebne biblioteki" "Ściągnięcie pliku YT" "Usunięcie plików .wav" "Usunięcie plików .mp3" "Wyświetlanie wszystkich plików w obecnym katalogu" "Wiele plików" "Konwersja wszystkich .wav na .mp3" "Wyjście"
do
  case $x in
	"Dodaj potrzebne biblioteki") dodajbibl ;;
    "Ściągnięcie pliku YT") sciagnijyt ;;
    "Usunięcie plików .wav") usunwav ;;
    "Usunięcie plików .mp3") usunmp3 ;;
    "Wyświetlanie wszystkich plików w obecnym katalogu") ls ;;
    "Wiele plików") wieleplikow ;;
    "Konwersja wszystkich .wav na .mp3") echo "Konwertuję..." 
									     wavNAmp3 
										 echo "Zrobione" ;;
										 
    "Wyjście") echo "Wybrałaś wyjście. Miłego dnia. Dziekujemy za skorzystanie z usługi J. Tkacz(:"; break ;;
    *) echo "Nic nie wybralaś."
  esac
done


exit 0
