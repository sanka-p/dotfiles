#/bin/bash
font="JetBrainsMono" # change to required font
echo "Downloading ${font}"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/${font}.zip"

if [ $? -eq 0 ]; then
  unzip "${font}.zip" -d ~/.fonts
  fc-cache -fv
  rm "${font}.zip"
  echo "Done"
else
  echo "Download failed"
fi
