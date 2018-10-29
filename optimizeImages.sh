#!/bin/bash

# Options default
quality="90"
outDir="./out"
postfix=""
verbose=false

dj=""
cj=""
# Checking the installation of djpeg and cjpeg
command -v djpeg >/dev/null 2>&1 && dj=djpeg
command -v djpeg.exe >/dev/null 2>&1 && dj=djpeg.exe
command -v cjpeg >/dev/null 2>&1 && cj=cjpeg
command -v cjpeg.exe >/dev/null 2>&1 && cj=cjpeg.exe

command -v $dj >/dev/null 2>&1 || { echo >&2 "The djpeg is not installed."; exit 1; }
command -v $cj >/dev/null 2>&1 || { echo >&2 "The cjpeg is not installed."; exit 1;  }


usage() {
    echo -e ""
    echo -e "Usage: optimizeImages.sh [options] files"
    echo -e "Example: optimizeImages.sh -v -o ./out *.jpg"
    echo -e ""
    echo -e "Options:"
    echo -e "	-v verbose"
    echo -e "	-q Quality 0..100 (default=${quality})"
    echo -e "	-o Output dir (default=${outDir})"
    echo -e "	-p Postfix output filename (default='${postfix}')"
    echo -e ""
	exit 1
}

# get options
while getopts "q:o:p:hv" opt; do
 case $opt in
  h)
   usage && exit 1
   ;;
  q)
   quality="$OPTARG"
   ;;
  o)
   outDir="$OPTARG"
   ;;
  p)
   postfix="$OPTARG"
   ;;
  v)
   verbose=true
   ;;
  *)
   usage && exit 1
   ;;
 esac
done

checkFile() {
    [[ ! -f "$1" ]] && echo "File ${1} doesn't exists!" && exit 1
}

log() {
	[[ "$verbose" == true ]] && echo -e "$1"
}

# Getting a list of files and checking their existence
shift $(expr $OPTIND - 1 )
files=()
while test $# -gt 0; do
    files+=("$1")
    checkFile "$1"
    shift
done

printConf() {
    echo -e ""
    echo -e "Current configurations:"
    echo -e "	quality		${quality}"
    echo -e "	outDir		${outDir}"
    echo -e "	postfix		${postfix}"
    echo -e "	verbose		${verbose}"
    echo -e ""
}

optimize() {
    inFile="$1"
    outFile="${inFile/\.jpg/$postfix\.jpg}"
    tempFile="${outDir}/temp.ppm"
	mkdir -p "$outDir"
    
    $dj "$inFile" "$tempFile"
    $cj -progressive -optimize -quality $quality "$tempFile" "${outDir}/$outFile"
	
    rm "$tempFile"
    log "${inFile} -> ${outDir}/${outFile}"
}


# If have no files
[[ ${#files[*]} == 0 ]] && usage

if [[ "$verbose" == true ]]; then
    printConf

    echo "Number of files: ${#files[*]}"
    for ix in ${!files[*]}
    do
		printf "	%s\n" "${files[$ix]}"
    done
    echo -e ""
fi

# Optimize
for ix in ${!files[*]}
do
    optimize "${files[$ix]}"
done

