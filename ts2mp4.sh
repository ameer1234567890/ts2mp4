#!/bin/sh

check_tools() {
  tools="ffmpeg"
  for tool in $tools; do
    if [ ! "$(command -v "$tool")" ]; then
      printf "\e[1m%s\e[0m not found! Exiting....\n" "$tool"
      exit 1
    fi
  done
}

check_tools

{
  find files ! -name "$(printf "*\n*")" -name '*.TS' 2>/dev/null
  find files ! -name "$(printf "*\n*")" -name '*.ts' 2>/dev/null
} >tmp

if [ "$(cat tmp)" = "" ]; then
  echo "Error: No files found! Exiting...."
  rm tmp
  exit 1
fi

mkdir -p "output"

while IFS= read -r file; do
  count=$((count + 1))
  printf "Converting %s.... " "$file"
  output_file="$(echo "$file" | cut -d '/' -f 2)"
  output_file="${output_file%.*}"
  output_ext=".mp4"
  output_file="$output_file$output_ext"
  ffmpeg -hide_banner -loglevel panic -i "$file" -acodec copy -vcodec copy output/"$output_file" </dev/null
  ffmpeg_status="$?"
  if [ "$ffmpeg_status" != 0 ]; then
    echo ""
    count=$((count - 1))
    echo "Something went wrong. Error: $ffmpeg_status. Skipping file!"
  else
    echo "Done!"
  fi
done <tmp
rm tmp
echo "Converted $count files!"
