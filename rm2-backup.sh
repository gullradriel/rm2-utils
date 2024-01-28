#!/bin/sh

# Current rm2-backup.sh
version="1.0.0"

current_directory=`dirname $0`

# default values for arguments
user="root"
remarkable_ip="10.11.99.1" # remarkable IP address
backup_dir="$current_directory/backup"
sync=false
backup=false
restore_update_existing=false
restore_ignore_existing=false
restore_source=

usage()
{
    echo "Usage: $0 options
    echo "Options:
    echo "   -v or --version :"
    echo "   -u, --user 'username': change default username (${user})"
    echo "   -H, --host 'host or ip: change remarkable ip/hostname (${remarkable_ip})"
    echo "   -s, --sync: sync remarkable to $backup_dir/xochitl"
    echo "   -b, --backup : backup to automatically created $backup_dir/YYYY/MM/DD/HHMMSS directory"
    echo "   -l, --list : list backup directories"
    echo "   -r 'backup_dir' # restore from 'backup_dir' directory"
    echo "   -R 'backup_dir' # clean destination and restore from 'backup_dir' directory"
    echo "Examples:"
    echo "   $0    # show help"
    echo "   $0 -h # show help"
    echo "   $0 -s # sync remarkable to $backup_dir/xochitl"
    echo "   $0 -b # backup to automatically created $backup_dir/YYYY/MM/DD/HHMMSS directory"
    echo "   $0 -r $backup_dir/2024/01/28/091723 # restore from given backup directory"
    echo "   $0 -r $backup_dir/xochitl           # restore from given backup directory"
    exit 1
}

if [ $# -eq 0 ]
then
    usage
fi

# loop through arguments and process them
while [ $# -gt 0 ]; do
    case "$1" in
        -v | --version)
            echo "$0 version: v$version"
            exit
            ;;
        -l | --list)
            echo "Available backups:"
            echo $backup_dir/xochitl
            find $backup_dir -mindepth 4 -maxdepth 4 -type d 
            exit
            ;;
        -u | --user)
            user="$2"
            shift
            shift
            ;;
        -H | --host)
            remarkable_ip="$2"
            shift
            shift
            ;;
        -s | --sync)
            sync=true
            shift
            ;;
        -b | --backup)
            backup=true
            shift
            ;;
        -r | --restore-update-existing)
            restore_update_existing=true
            restore_source="$2"
            shift
            shift
            ;;
        -R | --restore-ignore-existing)
            restore_ignore_existing=true
            restore_source="$2"
            shift
            shift
            ;;
        -h | --help | *)
            usage
            ;;
    esac
done

echo "reMarkable: ${user}@${remarkable_ip}"

output=""
ret=""
ssh_cmd()
{
    output=`ssh -o ConnectTimeout=2 -o ServerAliveInterval=2 -ServerAliveCountMax=2 ${user}@${remarkable_ip} $@ 2>&1`
    retval=$?
    return $retval
}   

if ! ssh_cmd "hostname"
then
    echo "$remarkable_ip is down/unreachable: $output"
    exit 1
fi

if $sync ;
then
    echo "syncing from $remarkable_ip to $backup_dir/xochitl"
    mkdir -p $backup_dir
    rsync -e "ssh -o ConnectTimeout=2 -o ServerAliveInterval=2 -ServerAliveCountMax=2" --timeout 30 -azuv ${user}@${remarkable_ip}:~/.local/share/remarkable/xochitl $backup_dir
    exit $?
fi

if $backup ;
then
    year="`date +"%Y"`"
    month="`date +"%m"`"
    day="`date +"%d"`"
    current_time="`date +"%H"`_`date +"%M"`_`date +"%S"`"
    current_backup_dir="${backup_dir}/${year}/${month}/${day}/${current_time}"
    mkdir -p $current_backup_dir
    echo "backuping from $remarkable_ip to $current_backup_dir"
    rsync -e "ssh -o ConnectTimeout=2 -o ServerAliveInterval=2 -ServerAliveCountMax=2" --timeout 30 -azuv ${user}@${remarkable_ip}:~/.local/share/remarkable/xochitl/ $current_backup_dir/
    exit $?
fi

if $restore ;
then
    echo "restore from $restore_source/ to ${user}@${remarkable_ip}:~/.local/share/remarkable/xochitl/"
    rsync -azuvn $restore_source/ ${user}@${remarkable_ip}:~/.local/share/remarkable/xochitl/
    exit $?
fi

if $restore_ignore_existing ;
then
    echo "restore from $restore_source/ to ${user}@${remarkable_ip}:~/.local/share/remarkable/xochitl/"
    rsync -azuvn --delete --ignore-existing $restore_source/ ${user}@${remarkable_ip}:~/.local/share/remarkable/xochitl/
    exit $?
fi

exit 0
