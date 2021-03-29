#client.sh
#!/bin/bash

if [ "$#" -ge 1 ]; then
   id="$1"
   #sleep 2
   mkfifo "$id".pipe #creat a pipe
   trap client_shut INT 
    #if you use Ctrl+c to exit the program, it will remove the pipoe at the same time.
    function client_shut() {
        echo "Ctrl_c to exit"
        rm "$id".pipe
        exit 0
    }

   case "$2" in
       init) 
        {
         echo $1 $2 $3 $4 $5> server.pipe
         read message < $id.pipe
         echo $message
        }
        ;;
        insert) 
        {
         echo "Please write login: "
         read  login
         echo "Please write password:"
         echo "if you want get a random password, please enter 'R'."
         read  password
         # if users enter "R", it means that the user want get a random password.
         if [ "$password" = "R" ]; then
             password=`date +%s%N | md5sum | head -c 10`
             echo "your password is $password ."
         fi
         # encrypt the content of a service
         code=`./encrypt.sh "aaa" "$login"`
         code1=`./encrypt.sh "aaa" "$password"`
         echo -e $1 $2 $3 $4 "$code" "$code1" > server.pipe
         cat $id.pipe
        }
        ;;
        show) 
        {
         if [ -f "$3"/"$4" ]; then
            echo $1 $2 $3 $4 $5 > server.pipe
            #create a temp file
            temp=`mktemp tmp.XXXXX`
            cat "$id.pipe" > $temp
            echo "$3's login for $4 is:" 
            # get the content behind the 'login:'
            username=`grep '^login:' $temp | sed 's/login://'`
            #decrypt the username
            login=`./decrypt.sh "aaa" $username`
            echo "$login"
            echo "$3's password for $4 is:"  
            # get the content behind the 'password:'
            pass=`grep '^password:' $temp | sed 's/password://'`
            #decrypt the password
            password=`./decrypt.sh "aaa" $pass`
            echo $password
            rm $temp
         else
            echo "Error: service does not exist"
         fi
        }
        ;;
        ls) 
        {
         echo $1 $2 $3 $4> server.pipe
         cat $id.pipe
        }
        ;;
        rm) 
        {
        echo $1 $2 $3 $4 > server.pipe
        read message < $id.pipe
        echo $message
        }
        ;;
        edit) 
        {
         echo $1 "show" $3 $4 > server.pipe
         #to divide the content of a service
         read Alogin login Bpassword password < $id.pipe
         touch file
         echo -e "login:$login\npassword:$password" > file
         nano $file
         newlogin=`grep "login:" file | head -n 1 | sed "s/login://"`
         newpassword=`grep "password:" file | head -n 1 | sed "s/password://"`
         #encrypt the content of a service
         unm=`./encrypt.sh "aaa" "$newlogin"`
         pwd=`./encrypt.sh "aaa" "$newpassword"`
         echo $1 "update" $3 $4 $unm $pwd > server.pipe
         read output < $id.pipe
         echo $output 
         rm file
        }
        ;;
        shutdown)                       
        {
         echo "shutdown"
         echo $1 $2 $3 $4 > server.pipe
        }
        ;;
        *)
        {
         echo "Error: bad request"
         rm $id.pipe
         exit 1
         }
    esac
 rm $id.pipe
 else
    echo "Error: wrong parameters!"
fi