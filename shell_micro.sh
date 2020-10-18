#!/bin/bash
RESULT="./Results.csv"
printf "Name,Email,GIT-URL,GIT-Clone-Status,Build-Status,CPPCheck,Valgrind\n">$RESULT

valgr=1
while IFS=, read NAME EMAIL REPO; do
    [ "$NAME" != "Name" ] && printf "$NAME,">>$RESULT
    [ "$EMAIL" != "Email ID" ] && printf "$EMAIL,">>$RESULT
    if [ "$REPO" != "Repo Link" ]; then
        printf "$REPO,">>$RESULT
        git clone "$REPO"
        if [ $? -eq 0 ]; then
            printf "SUCEESFULLY CLONED ,">>$RESULT
            echo "CLONE SUCCESS"
            REP=`echo ="$REPO" | cut -d'/' -f5`
            echo "REPO=$REP"
            DIRCT=`find "$REP" -name "Makefile" -exec dirname {} \;`
            echo "DIRECT=$DIRCT"
            if [ $DIRCT ]
            then 
                make -C "$DIRCT"
                if [ $? -eq 0 ];then
                    printf "Success", >> $RESULT
                else
                    printf "Failed", >> $RESULT
                    valgr=0
                fi        
            else
                printf "Failed", >> $RESULT
                valgr=0
            fi
        elif [ $? -gt 0 ]; then
            printf "CLONE FAILED,">>$RESULT
            echo "CLONE FAILURE"
        fi 
        : '
        elif [[ "$Repo" != "Repo link" ]]
        then
            printf "Failed", >> $RESULT
            printf "Failed", >> $RESULT
            printf "Failed", >> $RESULT
            printf "Failed\n" >> $RESULT        
            #echo "Failed"
        fi'
        cppcheck "$DIRCT"
        if [[ $? -eq 0 && "$Name" != "Name" ]]
        then
            printf "Success", >> $RESULT
        elif [[ "$Name" != "Name" ]]
        then
            printf "Failed", >> $RESULT
        fi    
        if [[ $valgr -ne 0 && "$Name" != "Name" ]]
        then
            chmod +x "$DIRCT"/*.out && valgrind "$DIRCT"/*.out 2>> valgri.txt
            valsuc=`tail -n 1 valgri.txt| cut -d ":" -f2 | cut -b 2-3`
            printf "$valsuc\n" >> $RESULT
        elif [ "$Name" != "Name" ]
        then
            printf "Failed\n" >> $RESULT
        fi
    fi
done <Input.csv

