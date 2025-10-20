#!/usr/bin/env fish

# Clear the terminal before starting
clear

# Define the package manager command (yay for EndeavourOS)
set -l update_command "yay -Syu"

# Run the update command
echo "--- Starting full system update with yay -Syu ---"
# '|| true' ensures the script doesn't stop if the update requires user input and fails the first time
$update_command || true

# Check if the previous command was successful (yay will return 0 on successful update or when no updates are available)
if test $status -eq 0
    # Notify the user of success using fnott
    fnott-client "System Update Complete" "The system update using 'yay -Syu' finished successfully."
    echo "--- System update finished successfully ---"
else
    # Notify the user of failure
    fnott-client "System Update Failed" "There was an issue running 'yay -Syu'. Check the terminal output."
    echo "--- System update failed, please check the output ---"
end

# Keep the terminal open until a key is pressed to review the output
echo "\nPress any key to close the terminal..."
read -n 1
