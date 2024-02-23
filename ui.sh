#!/bin/bash

# Define functions

declare -A countries
declare -A map

initialize_map() {
    map=(
        [0,0]="USA"
        [0,1]="USA"
        [0,2]="USA"
        [0,3]="USA"
        [0,4]="USA"
        [0,5]="UK"
        [0,6]="UK"
        [0,7]="UK"
        [0,8]="UK"
        [0,9]="UK"
        [0,10]="UK"
        [0,11]="UK"
        [0,12]="UK"
        [0,13]="UK"
        [0,14]="UK"
        [1,0]="USA"
        [1,1]="USA"
        [1,2]="USA"
        [1,3]="USA"
        [1,4]="USA"
        [1,5]="UK"
        [1,6]="UK"
        [1,7]="UK"
        [1,8]="UK"
        [1,9]="UK"
        [1,10]="UK"
        [1,11]="UK"
        [1,12]="UK"
        [1,13]="UK"
        [1,14]="UK"
        [2,0]="USA"
        [2,1]="USA"
        [2,2]="USA"
        [2,3]="USA"
        [2,4]="USA"
        [2,5]="UK"
        [2,6]="UK"
        [2,7]="UK"
        [2,8]="UK"
        [2,9]="UK"
        [2,10]="UK"
        [2,11]="UK"
        [2,12]="UK"
        [2,13]="UK"
        [2,14]="UK"
    )
}

initialize_countries() {
    countries=(
        ["USA"]="USA,331000000,1000000,90"
        ["UK"]="UK,68200000,100000,85"
    )
}

display_map() {
    echo "=== World Map ==="
    for ((i=0; i<3; i++)); do
        for ((j=0; j<15; j++)); do
            echo -n "${map[$i,$j]} "
        done
        echo ""
    done
    echo "================="
}

add_country() {
    echo "Adding a new country..."
    read -p "Enter country name: " name
    read -p "Enter population: " population
    read -p "Enter x-coordinate: " x
    read -p "Enter y-coordinate: " y
    read -p "Enter gold reserves: " gold
    read -p "Enter military strength: " military
    countries["$name"]="$name,$population,$gold,$military"
    map[$x,$y]="$name"
    echo "Country added: $name"
}

create_leader() {
    echo "Creating a new leader..."
    read -p "Enter leader name: " leader_name
    read -p "Enter charisma score: " charisma
    read -p "Enter military skill: " military_skill
    select country in "${!countries[@]}"; do
        if [[ -n $country ]]; then
            country_info=${countries[$country]}
            IFS=',' read -r -a country_info_arr <<< "$country_info"
            country_info_arr[3]="$leader_name,$charisma,$military_skill"
            countries[$country]=$(IFS=','; echo "${country_info_arr[*]}")
            echo "Leader created: $leader_name for $country"
            break
        else
            echo "Invalid country selection. Please try again."
        fi
    done
}

view_leader() {
    echo "Select a country to view its leader:"
    select country in "${!countries[@]}"; do
        if [[ -n $country ]]; then
            country_info=${countries[$country]}
            IFS=',' read -r -a country_info_arr <<< "$country_info"
            echo "=== Leader Info ==="
            echo "Leader: ${country_info_arr[3]}"
            echo "Charisma: ${country_info_arr[4]}"
            echo "Military Skill: ${country_info_arr[5]}"
            echo "==================="
            break
        else
            echo "Invalid country selection. Please try again."
        fi
    done
}

fight_nations() {
    echo "Select two nations to fight:"
    select nation1 in "${!countries[@]}"; do
        break
    done
    select nation2 in "${!countries[@]}"; do
        break
    done
    echo "Fighting between $nation1 and $nation2..."
    # Simulate the fight
    if (( RANDOM % 2 == 0 )); then
        echo "$nation1 wins!"
        # Change territory ownership
        for coord in "${!map[@]}"; do
            if [[ ${map[$coord]} == "$nation2" ]]; then
                map[$coord]="$nation1"
            fi
        done
    else
        echo "$nation2 wins!"
        # Change territory ownership
        for coord in "${!map[@]}"; do
            if [[ ${map[$coord]} == "$nation1" ]]; then
                map[$coord]="$nation2"
            fi
        done
    fi
}

check_gold_reserves() {
    read -p "Enter country name to check gold reserves: " country
    if [[ -n ${countries[$country]} ]]; then
        gold=$(echo "${countries[$country]}" | cut -d',' -f3)
        echo "Gold reserves of $country: $gold"
    else
        echo "Country not found."
    fi
}

check_military_strength() {
    read -p "Enter country name to check military strength: " country
    if [[ -n ${countries[$country]} ]]; then
        military=$(echo "${countries[$country]}" | cut -d',' -f4)
        echo "Military strength of $country: $military"
    else
        echo "Country not found."
    fi
}

tutorial() {
    echo "=== Tutorial ==="
    echo "Welcome to the mapping game tutorial!"
    echo "In this game, you can simulate creating countries, leaders, and fighting between nations."
    echo "You can view the map, add countries, create leaders, and more."
    echo "To add a country, you need to specify its name, population, x-coordinate, y-coordinate, gold reserves, and military strength."
    echo "Enjoy the game!"
    echo "================"
}

edit_map() {
    echo "Editing map..."
    # Add code to allow editing the map (not implemented in this example)
}

play_as_nation() {
    echo "Select a country to play as:"
    select country in "${!countries[@]}"; do
        if [[ -n $country ]]; then
            echo "You are now playing as $country."
            # Add interactive actions for playing as a nation
            break
        else
            echo "Invalid country selection. Please try again."
        fi
    done
}

rebellions() {
    echo "Checking for rebellions..."
    for coord in "${!map[@]}"; do
        if (( RANDOM % 100 < 5 )); then  # 5% chance of rebellion
            old_country="${map[$coord]}"
            new_country="${!countries[@]:RANDOM%${#countries[@]}:1}"
            map[$coord]="$new_country"
            echo "Rebellion at coordinates $coord! $old_country has been replaced by $new_country."
        fi
    done
}

spawn_rebellions() {
    read -p "Enter the number of rebellions to spawn: " num_rebellions
    for ((i=0; i<num_rebellions; i++)); do
        rand_x=$((RANDOM % 3))
        rand_y=$((RANDOM % 15))
        old_country="${map[$rand_x,$rand_y]}"
        new_country="${!countries[@]:RANDOM%${#countries[@]}:1}"
        map[$rand_x,$rand_y]="$new_country"
        echo "Rebellion spawned at coordinates ($rand_x, $rand_y)! $old_country has been replaced by $new_country."
    done
}

next_turn() {
    # Add code to progress to the next turn (not implemented in this example)
    echo "Next turn!"
}

# Main script

# Initialize map and countries
initialize_map
initialize_countries

# Main loop
running=true
while $running; do
    echo ""
    echo "=== Menu ==="
    echo "1. Display Map"
    echo "2. Add Country"
    echo "3. Create Leader"
    echo "4. View Leader"
    echo "5. Fight Nations"
    echo "6. Edit Map"
    echo "7. Check Gold Reserves"
    echo "8. Check Military Strength"
    echo "9. Tutorial"
    echo "10. Play as a Nation"
    echo "11. Check for Rebellions"
    echo "12. Spawn Rebellions"
    echo "13. Next Turn"
    echo "14. Exit"
    echo "==========="
    read -p "Enter your choice: " choice

    case $choice in
        1)
            display_map
            ;;
        2)
            add_country
            ;;
        3)
            create_leader
            ;;
        4)
            view_leader
            ;;
        5)
            fight_nations
            ;;
        6)
            edit_map
            ;;
        7)
            check_gold_reserves
            ;;
        8)
            check_military_strength
            ;;
        9)
            tutorial
            ;;
        10)
            play_as_nation
            ;;
        11)
            rebellions
            ;;
        12)
            spawn_rebellions
            ;;
        13)
            next_turn
            ;;
        14)
            echo "Exiting the program."
            running=false
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
