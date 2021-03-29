#server.sh
#!/bin/bash

if [ ! -f "server.pipe" ]; then 
    mkfifo server.pipe
fi
trap server_shut INT 

function server_shut()
{
echo "Ctrl_c to exit"
rm server.pipe
exit 0
}

while true; do
    read id request user service payload password < server.pipe
    case "$request" in
         init)
         {
         ./init.sh $user > "$id.pipe" & 
         } 
         ;;
         insert)
         {
         ./insert.sh $user $service '' "login:$payload\npassword:$password" > "$id.pipe" &
         }
         ;;
         show)
         {
         ./show.sh $user $service > "$id.pipe" &
         }
         ;;
         update)
         {
         ./insert.sh $user $service f "login:$payload\npassword:$password" > "$id.pipe" &
         }
         ;;
         rm)
         {
         ./rm.sh $user $service > "$id.pipe" &
         }
         ;;
         ls)
         {
         ./ls.sh $user $service > "$id.pipe" &
         }
         ;;
         shutdown)
         {
          echo "shutdown" > "$id.pipe" &
          rm server.pipe
          exit 0
         }
         ;;
         *)
         {
         echo "Error: bad request" > "$id.pipe" &
          rm server.pipe
         exit 1
         }
     esac
done
