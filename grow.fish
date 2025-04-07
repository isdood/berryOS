#!/usr/bin/env fish

# Function to execute scripts in ascending numerical order
function execute_scripts
    set -l script_number 0

    while true
        set -l script_file (printf "%03d-" $script_number)*.fish

        # Ensure the script file is not empty
        if test -n "$script_file" -a -e "$script_file"
            # Make the script executable
            chmod +x $script_file

            # Execute the script if it's not empty
            if test -s "$script_file"
                ./$script_file
            else
                echo "Skipping empty script: $script_file"
            end

            # Remove execution permission for safety
            chmod -x $script_file

            # Increment the script number
            set script_number (math $script_number + 1)
        else
            # Exit the loop if the script file does not exist
            break
        end
    end
end

# Call the function to execute the scripts
execute_scripts
