#!/bin/bash

# Set the download directory
DOWNLOAD_DIR="/mnt/usb/temp"

# Set the directory for Phineas and Ferb
TV_SHOW_DIR="/mnt/usb/TV Shows/Phineas and Ferb"

# Magnet link
MAGNET_LINK="magnet:?xt=urn:btih:7FE80EC7CBB8D3A182DDBB745DB51DBD176104F7&dn=Phineas%20and%20Ferb%20(2007)%20Season%201-4%20S01-S04%20Extras%20(1080p%20WEB-DL%20&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.bittor.pw%3A1337%2Fannounce&tr=udp%3A%2F%2Fpublic.popcorn-tracker.org%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fexodus.desync.com%3A6969&tr=udp%3A%2F%2Fopen.demonii.com%3A1337%2Fannounce"

# Download the torrent
sudo transmission-cli -w "$DOWNLOAD_DIR" "$MAGNET_LINK"

# Function to convert and rename files
convert_and_rename() {
  find "$DOWNLOAD_DIR" -type f -name "*.mkv" | while read -r mkv_file; do

    # Extract season and episode numbers from the original filename
    filename=$(basename "$mkv_file")
    # Extract base name without the extension
    base_name="${filename%.*}"
    season=$(echo "$base_name" | grep -oP 'S\d+')
    episode=$(echo "$base_name" | grep -oP 'E\d+')

    # If the episode code can be found in the episode, process
    if [[ ! -z "$season" && ! -z "$episode" ]]; then

      # Remove leading "S" and "E" to use only numbers
      season_num=$(echo "$season" | sed 's/S//')
      episode_num=$(echo "$episode" | sed 's/E//')

      # Format season and episode numbers with leading zeros (e.g., S01E01)
      formatted_season=$(printf "%02d" "$season_num")
      formatted_episode=$(printf "%02d" "$episode_num")

      # Create the output filename based on season and episode number
      output_filename="Phineas and Ferb s${formatted_season}e${formatted_episode}.mp4"
      output_path="$TV_SHOW_DIR/Season ${season_num}/$output_filename"

      # Create season directory if it doesn't exist
      mkdir -p "$TV_SHOW_DIR/Season ${season_num}"

      # Convert the file to MP4 (using ffmpeg)
      ffmpeg -i "$mkv_file" -c copy "$DOWNLOAD_DIR/$output_filename"

      # Move the converted file to the TV show directory and rename
      mv "$DOWNLOAD_DIR/$output_filename" "$output_path"

      # Remove the original MKV file
      rm "$mkv_file"

      echo "Converted and moved: $output_filename"

    else
       # Get Filename without extension
       filename_no_extension=$(basename "$filename" .mkv)

       # Check if the episode is the movie
       if [[ "$filename_no_extension" == *"Across the 2nd Dimension"* ]]; then

          # Convert to mp4
          ffmpeg -i "$mkv_file" -c copy "$DOWNLOAD_DIR/Phineas and Ferb - Across the 2nd Dimension.mp4"

          # Move file
          mv "$DOWNLOAD_DIR/Phineas and Ferb - Across the 2nd Dimension.mp4" "$TV_SHOW_DIR/Phineas and Ferb - Across the 2nd Dimension.mp4"

          # Remove the original MKV file
          rm "$mkv_file"

       elif [[ "$filename_no_extension" == *"The O.W.C.A Files"* ]]; then

          # Convert to mp4
          ffmpeg -i "$mkv_file" -c copy "$DOWNLOAD_DIR/Phineas and Ferb - The O.W.C.A Files.mp4"

          # Move file
          mv "$DOWNLOAD_DIR/Phineas and Ferb - The O.W.C.A Files.mp4" "$TV_SHOW_DIR/Phineas and Ferb - The O.W.C.A Files.mp4"

          # Remove the original MKV file
          rm "$mkv_file"

       fi

    fi
  done
}

# Run the conversion and renaming
convert_and_rename
