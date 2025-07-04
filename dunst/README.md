# Testing
sudo apt-get install libnotify-bin

notify-send "Test" "This is a test notification"
notify-send -u critical "Critical Notification" "Something urgent happened"
notify-send -i dialog-information "Info" "Notification with icon"
notify-send -t 5000 "Timeout" "This will last 5 seconds"

killall dunst

https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
