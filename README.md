# rm-utils
# reMarkable 2 no cloud backup/restore/sync tools

Under development

DO NOT USE YET


## ```rm-backup.sh```

Backup, synchronize or restore reMarkable 2 contents

```
Usage: ./rm2-backup.sh options
    echo Options:
   -v or --version :
   -u, --user 'username': change default username (root)
   -H, --host 'host or ip: change remarkable ip/hostname (10.11.99.1)
   -s, --sync: sync remarkable to ./backup/xochitl
   -b, --backup : backup to automatically created ./backup/YYYY/MM/DD/HHMMSS directory
   -l, --list : list backup directories
   -r 'backup_dir' # restore from 'backup_dir' directory
   -R 'backup_dir' # clean destination and restore from 'backup_dir' directory
Examples:
   ./rm2-backup.sh    # show help
   ./rm2-backup.sh -h # show help
   ./rm2-backup.sh -s # sync remarkable to ./backup/xochitl
   ./rm2-backup.sh -b # backup to automatically created ./backup/YYYY/MM/DD/HHMMSS directory
   ./rm2-backup.sh -r ./backup/2024/01/28/091723 # restore from given backup directory
   ./rm2-backup.sh -r ./backup/xochitl           # restore from given backup directory, ignore non existing
   ./rm2-backup.sh -R ./backup/xochitl           # restore from given backup directory, delete non existing 
```

## ```rm-uuidgen.sh```

Generate UUIDs to use when uploading and generating files ourself

```
Usage: rm-uuidgen.sh
Example:
./rm2-uuidgen.sh 
0319415c-f0ae-4ab0-bb02-3f0781b2231a
```

## ```rm-explorer.py```

Not yet available
