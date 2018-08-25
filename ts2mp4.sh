#!/bin/sh
find files ! -name "$(printf "*\n*")" -name '*.ts' > tmp
while IFS= read -r file; do
  count=$((count + 1))
  printf "Converting %s.... " "$file"
  output_file="$(echo "$file" | cut -d '/' -f 2)"
  output_file="${output_file%.*}"
  output_ext=".mp4"
  output_file="$output_file$output_ext"
  ffmpeg -hide_banner -loglevel panic -i "$file" -acodec copy -vcodec copy output/"$output_file" < /dev/null
  ffmpeg_status="$?"
  if [ "$ffmpeg_status" != 0 ]; then
    echo ""
    count=$((count - 1))
    echo "Something went wrong. Error: $ffmpeg_status. Skipping file!"
  else
    echo "Done!"
  fi
done < tmp
rm tmp
echo "Converted $count files!"
