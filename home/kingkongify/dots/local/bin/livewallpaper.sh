#!/usr/bin/env bash

# Wallpaper Tool - Manages video and static wallpapers with pywal
# Supports mpvpaper for videos and swww for static images

SCRIPT_NAME="$(basename "$0")"
TOOL_DIR="$HOME/.local/bin/wallpapertool"
LAST_WALLPAPER_FILE="$TOOL_DIR/last-wallpaper.txt"
MPVSHOT_PATH="$TOOL_DIR/mpvshot.jpg"
VIDEO_DIR="$HOME/Media/Wallpapers/Live"
STATIC_DIR="$HOME/Media/Wallpapers/Static"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    local deps=("ffmpeg" "wal" "mpvpaper" "mpv" "jq" "notify-send" "killall" "ffprobe" "hyprctl" "swww")
    
    print_info "Checking dependencies..."
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_info "Please install the missing dependencies and try again."
        exit 1
    fi
    
    print_success "All dependencies are installed."
}

# Function to get monitors
get_monitors() {
    local monitors=$(hyprctl monitors -j | jq -r '.[].name')
    if [ -z "$monitors" ]; then
        print_error "No monitors detected!"
        exit 1
    fi
    echo "$monitors"
}

# Function to create necessary directories
setup_directories() {
    mkdir -p "$TOOL_DIR"
    mkdir -p "$VIDEO_DIR"
    mkdir -p "$STATIC_DIR"
}

# Function to determine file type
get_file_type() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "invalid"
        return
    fi
    
    # First check file extension for common formats
    local extension="${file##*.}"
    extension="${extension,,}" # Convert to lowercase
    
    case "$extension" in
        jpg|jpeg|png|webp|gif|bmp|tiff|tif)
            echo "image"
            return
            ;;
        mp4|webm|mkv|avi|mov|flv|wmv)
            # Verify it's actually a video with ffprobe
            local duration=$(ffprobe -v error -show_entries format=duration -of csv=s=x:p=0 "$file" 2>/dev/null)
            if [ -n "$duration" ] && [ "$duration" != "N/A" ] && [ "$duration" != "0.000000" ]; then
                echo "video"
            else
                echo "image"
            fi
            return
            ;;
    esac
    
    # Fallback to ffprobe detection
    local format=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_type -of csv=s=x:p=0 "$file" 2>/dev/null)
    
    if [ "$format" = "video" ]; then
        # Check if it has duration (is actually a video)
        local duration=$(ffprobe -v error -show_entries format=duration -of csv=s=x:p=0 "$file" 2>/dev/null)
        if [ -n "$duration" ] && [ "$duration" != "N/A" ] && [ "$duration" != "0.000000" ]; then
            echo "video"
        else
            echo "image"
        fi
    else
        # Try to identify as image using file command
        if file --mime-type "$file" | grep -q "image/"; then
            echo "image"
        else
            echo "unknown"
        fi
    fi
}

# Function to display selection menu
show_selection_menu() {
    local videos=()
    local images=()
    local letters=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
    
    # Collect videos
    if [ -d "$VIDEO_DIR" ]; then
        while IFS= read -r -d '' file; do
            videos+=("$(basename "$file")")
        done < <(find "$VIDEO_DIR" -maxdepth 1 -type f \( -name "*.mp4" -o -name "*.webm" -o -name "*.mkv" -o -name "*.avi" \) -print0 | sort -z)
    fi
    
    # Collect images
    if [ -d "$STATIC_DIR" ]; then
        while IFS= read -r -d '' file; do
            images+=("$(basename "$file")")
        done < <(find "$STATIC_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.gif" \) -print0 | sort -z)
    fi
    
    # Display menu
    echo -e "${BLUE}[INFO]${NC} Choose Your Wallpaper:"
    
    if [ ${#videos[@]} -gt 0 ]; then
        echo -e "${YELLOW}[Videos]${NC}"
        for i in "${!videos[@]}"; do
            echo "  [$i] ${videos[$i]}"
        done
    fi
    
    if [ ${#images[@]} -gt 0 ]; then
        echo -e "${YELLOW}[Pictures]${NC}"
        for i in "${!images[@]}"; do
            if [ $i -lt ${#letters[@]} ]; then
                echo "  [${letters[$i]}] ${images[$i]}"
            else
                echo "  [pic$i] ${images[$i]}"
            fi
        done
    fi
    
    if [ ${#videos[@]} -eq 0 ] && [ ${#images[@]} -eq 0 ]; then
        print_error "No wallpapers found in $VIDEO_DIR or $STATIC_DIR"
        exit 1
    fi
    
    echo ""
    read -p "Enter selection (number for video, letter for picture, or 'r' for random): " choice
    
    if [ "$choice" = "r" ] || [ "$choice" = "R" ]; then
        # Random selection
        local all_files=()
        for v in "${videos[@]}"; do
            all_files+=("$VIDEO_DIR/$v")
        done
        for i in "${images[@]}"; do
            all_files+=("$STATIC_DIR/$i")
        done
        local random_index=$((RANDOM % ${#all_files[@]}))
        SELECTED_FILE="${all_files[$random_index]}"
    elif [[ "$choice" =~ ^[0-9]+$ ]]; then
        # Numeric selection - video
        if [ "$choice" -lt "${#videos[@]}" ]; then
            SELECTED_FILE="$VIDEO_DIR/${videos[$choice]}"
        else
            print_error "Invalid video selection"
            exit 1
        fi
    elif [[ "$choice" =~ ^[a-z]$ ]]; then
        # Letter selection - picture
        # Convert letter to index
        local letter_index=-1
        for i in "${!letters[@]}"; do
            if [ "${letters[$i]}" = "$choice" ]; then
                letter_index=$i
                break
            fi
        done
        
        if [ "$letter_index" -ne -1 ] && [ "$letter_index" -lt "${#images[@]}" ]; then
            SELECTED_FILE="$STATIC_DIR/${images[$letter_index]}"
        else
            print_error "Invalid picture selection"
            exit 1
        fi
    elif [[ "$choice" =~ ^pic[0-9]+$ ]]; then
        # Extended picture selection for more than 26 images
        local pic_index="${choice#pic}"
        if [ "$pic_index" -lt "${#images[@]}" ]; then
            SELECTED_FILE="$STATIC_DIR/${images[$pic_index]}"
        else
            print_error "Invalid picture selection"
            exit 1
        fi
    else
        print_error "Invalid selection format"
        exit 1
    fi
}

# Function to cleanup all wallpaper processes and clearing needed directories
cleanup_wallpaper_processes() {
    print_info "Cleaning up existing wallpaper processes..."
    
    # Kill mpvpaper instances
    killall mpvpaper 2>/dev/null
    killall .mpvpaper-wrapper 2>/dev/null
    
    # Kill swww
    swww kill 2>/dev/null

    # Remove pywal cache
    rm -rf ~/.cache/wal
    
}

# Function to set video wallpaper
set_video_wallpaper() {
    local video_path="$1"
    local monitors="$2"
    
    print_info "Setting video wallpaper: $(basename "$video_path")"
    
    # Clean up all wallpaper processes first
    cleanup_wallpaper_processes
    
    # Step 5a: Extract frame for pywal
    print_info "Extracting frame for pywal..."
    ffmpeg -i "$video_path" -vf "select=eq(n\,100)" -frames:v 1 "$MPVSHOT_PATH" -y &>/dev/null
    
    if [ ! -f "$MPVSHOT_PATH" ]; then
        print_error "Failed to extract frame from video"
        exit 1
    fi
    
    # Step 6a: Start mpvpaper for each monitor
    for monitor in $monitors; do
        print_info "Starting mpvpaper on $monitor..."
        mpvpaper -o "no-audio --loop --hwdec=vaapi" "$monitor" "$video_path" &
    done
    
    
    # Step 7a: Run pywal
    print_info "Generating color scheme with pywal..."
    wal -i "$MPVSHOT_PATH" -q
    
    # Step 8a: Run additional color generation scripts
    run_color_scripts
    
    # Step 9a: Save wallpaper info
    echo "type:video" > "$LAST_WALLPAPER_FILE"
    echo "path:$video_path" >> "$LAST_WALLPAPER_FILE"
    echo "monitors:$monitors" >> "$LAST_WALLPAPER_FILE"
    
    print_success "Video wallpaper set successfully!"
    notify-send "Wallpaper Tool" "Video wallpaper set: $(basename "$video_path")" -i "$MPVSHOT_PATH"
}

# Function to set static wallpaper
set_static_wallpaper() {
    local image_path="$1"
    
    print_info "Setting static wallpaper: $(basename "$image_path")"
    
    # Clean up all wallpaper processes first
    cleanup_wallpaper_processes
    
    # Step 5b: Start swww daemon
    print_info "Starting swww daemon..."
    swww-daemon &
    
    # Set wallpaper with swww
    print_info "Setting wallpaper with swww..."
    swww img "$image_path" --transition-type grow --transition-pos center --transition-duration 2
    
    # Step 6b: Run pywal
    print_info "Generating color scheme with pywal..."
    wal -i "$image_path" -q
    
    # Run additional color generation scripts
    run_color_scripts
    
    # Step 7b: Save wallpaper info
    echo "type:image" > "$LAST_WALLPAPER_FILE"
    echo "path:$image_path" >> "$LAST_WALLPAPER_FILE"
    
    print_success "Static wallpaper set successfully!"
    notify-send "Wallpaper Tool" "Static wallpaper set: $(basename "$image_path")" -i "$image_path"
}

# Function to run additional color generation scripts
run_color_scripts() {
    local scripts=("gen-eww-colors.sh" "gen-rofi-colors.sh" "gen-hyprland-colors.sh")
    
    for script in "${scripts[@]}"; do
        if [ -f "$HOME/.local/bin/$script" ]; then
            print_info "Running $script..."
            bash "$HOME/.local/bin/$script"
        else
            print_warning "$script not found in ~/.local/bin/"
        fi
    done
}

# Function to load last wallpaper
load_last_wallpaper() {
    if [ ! -f "$LAST_WALLPAPER_FILE" ]; then
        print_error "No last wallpaper found!"
        exit 1
    fi
    
    local type=$(grep "^type:" "$LAST_WALLPAPER_FILE" | cut -d':' -f2)
    local path=$(grep "^path:" "$LAST_WALLPAPER_FILE" | cut -d':' -f2-)
    
    if [ ! -f "$path" ]; then
        print_error "Last wallpaper file not found: $path"
        exit 1
    fi
    
    print_info "Loading last wallpaper..."
    
    if [ "$type" = "video" ]; then
        local monitors=$(grep "^monitors:" "$LAST_WALLPAPER_FILE" | cut -d':' -f2-)
        if [ -z "$monitors" ]; then
            monitors=$(get_monitors)
        fi
        set_video_wallpaper "$path" "$monitors"
    elif [ "$type" = "image" ]; then
        set_static_wallpaper "$path"
    else
        print_error "Invalid wallpaper type in last-wallpaper.txt"
        exit 1
    fi
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTION] [PATH]

Options:
    -l              Load last chosen wallpaper
    -s              Select mode - choose from available wallpapers
    -p PATH         Preselect mode - set specific image/video
    -h, --help      Show this help message

Examples:
    $SCRIPT_NAME -l                                    # Load last wallpaper
    $SCRIPT_NAME -s                                    # Select from menu
    $SCRIPT_NAME -p ~/Pictures/wallpaper.jpg          # Set specific image
    $SCRIPT_NAME -p ~/Videos/live-wallpaper.mp4       # Set specific video

Wallpaper directories:
    Videos:  $VIDEO_DIR
    Images:  $STATIC_DIR

EOF
}

# Main script
main() {
    # Check dependencies
    check_dependencies
    
    # Setup directories
    setup_directories
    
    # Get monitors
    MONITORS=$(get_monitors)
    print_info "Detected monitors: $(echo $MONITORS | tr '\n' ' ')"
    
    # Parse arguments
    if [ $# -eq 0 ]; then
        show_usage
        exit 0
    fi
    
    case "$1" in
        -l)
            # Load last wallpaper
            load_last_wallpaper
            ;;
        -s)
            # Selection mode
            SELECTED_FILE=""
            show_selection_menu
            
            if [ -z "$SELECTED_FILE" ]; then
                print_error "No file selected"
                exit 1
            fi
            
            file_type=$(get_file_type "$SELECTED_FILE")
            if [ "$file_type" = "video" ]; then
                set_video_wallpaper "$SELECTED_FILE" "$MONITORS"
            elif [ "$file_type" = "image" ]; then
                set_static_wallpaper "$SELECTED_FILE"
            else
                print_error "Invalid file type: $SELECTED_FILE"
                exit 1
            fi
            ;;
        -p)
            # Preselect mode
            if [ $# -lt 2 ]; then
                print_error "Please provide a file path"
                show_usage
                exit 1
            fi
            
            file_path="$2"
            if [ ! -f "$file_path" ]; then
                print_error "File not found: $file_path"
                exit 1
            fi
            
            file_type=$(get_file_type "$file_path")
            if [ "$file_type" = "video" ]; then
                set_video_wallpaper "$file_path" "$MONITORS"
            elif [ "$file_type" = "image" ]; then
                set_static_wallpaper "$file_path"
            else
                print_error "Invalid file type: $file_path"
                exit 1
            fi
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            print_error "Invalid option: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"