#!/bin/bash
function wavNAmp3
{
for i in *.wav; do
 if [ -e "$i" ]; then
   plik=`basename "$i" .wav`
   lame -h -b 192 "$i" "$plik.mp3"
   rm "$i"
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
	youtube-dl $zrodlo
	ffmpeg -i "$id" "$tytul.wav"
	
	echo "$tytul.wav" | grep -q " "         
     if [ $? -eq 0 ]                   
     then
       fname="$tytul.wav"                     
       n=$(echo $fname | sed -e "s/ /_/g")  
       mv "$fname" "$n"                     
     fi
     rm "$id"
     
	done < pliki.txt
}
function sciagnijyt
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
select x in "Ściągnięcie pliku YT" "Usunięcie plików .wav" "Usunięcie plików .mp3" "Wyświetlanie wszystkich plików w obecnym katalogu" "Wiele plików" "Konwersja wszystkich .wav na .mp3" "Wyjście"
do
  case $x in
    "Ściągnięcie pliku YT") sciagnijyt ;;
    "Usunięcie plików .wav") usunwav ;;
    "Usunięcie plików .mp3") usunmp3 ;;
    "Wyświetlanie wszystkich plików w obecnym katalogu") ls ;;
    "Wiele plików") wieleplikow ;;
    "Konwersja wszystkich .wav na .mp3") echo "Konwertuję..." 
									     wavNAmp3 
										 echo "Zrobione" ;;
										 
    "Wyjście") echo "Wybrales wyjscie. Miłego dnia. Dziekujemy za skorzystanie z usług J. Tkacz;)"; break ;;
    *) echo "Nic nie wybrales."
  esac
done
