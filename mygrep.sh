show_line_numbers=false
invert_match=false
search_string=""
filename=""
usage="Usage: $0 [-n] [-v] <search_string> <filename>"


while [[ $# -gt 0 ]]; do
    case "$1" in
        -n)
            show_line_numbers=true
            shift
            ;;
        -v)
            invert_match=true
            shift
            ;;
        -vn|-nv)
            show_line_numbers=true
            invert_match=true
            shift
            ;;
        --help)
            echo "mygrep.sh - A simplified grep implementation"
            echo "$usage"
            echo "Options:"
            echo "  -n        Show line numbers"
            echo "  -v        Invert match (show non-matching lines)"
            echo "  --help    Show this help message"
            exit 0
            ;;
        -*)
            echo "Error: Unknown option $1" >&2
            echo "$usage" >&2
            exit 1
            ;;
        *)
            if [[ -z "$search_string" ]]; then
                search_string="$1"
            elif [[ -z "$filename" ]]; then
                filename="$1"
            else
                echo "Error: Too many arguments" >&2
                echo "$usage" >&2
                exit 1
            fi
            shift
            ;;
    esac
done


if [[ -z "$search_string" ]]; then
    echo "Error: Missing search string" >&2
    echo "$usage" >&2
    exit 1
fi

if [[ -z "$filename" ]]; then
    echo "Error: Missing filename" >&2
    echo "$usage" >&2
    exit 1
fi

if [[ ! -f "$filename" ]]; then
    echo "Error: File '$filename' not found" >&2
    exit 1
fi


grep_command="grep -i"
if [[ $invert_match == true ]]; then
    grep_command="$grep_command -v"
fi

line_number=0
while IFS= read -r line; do
    ((line_number++))
    
    if echo "$line" | $grep_command -q "$search_string"; then
        match=true
    else
        match=false
    fi
    
    
    if [[ $match == true ]]; then
        if [[ $show_line_numbers == true ]]; then
            printf "%d:" "$line_number"
        fi
        echo "$line"
    fi
done < "$filename"

exit 0
