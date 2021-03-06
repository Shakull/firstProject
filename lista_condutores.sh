#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2021/2022
##
## Aluno: Nº: 103955  Nome: Diogo Ribeiro
## Nome do Módulo: lista_condutores.sh
## Descrição/Explicação do Módulo: Creates DRIVERS from PEOPLE
##
###############################################################################

#File Paths Management. Permits changing file paths without changing script.
DRIVERS_FILE=./condutores.txt #File Structure: <ID>-<Nome>;<ID carta condução>;<Contacto>;<Nr Contribuinte>;<Saldo (em créditos)>
PEOPLE_FILE=./pessoas.txt #File Structure: <ID carta condução>:<Nome>:<Nr Contribuinte>:<Contacto>


#Checks if PEOPLE_FILE exists in the current directory. If not, returns @ERROR and exits.
#@ERROR Non-existant file.
if [ ! -f $PEOPLE_FILE ];
	then
		./error 1 $PEOPLE_FILE
		exit
fi

#Gets new DRIVERS_FILE from PEOPLE_FILE with each PERSON formated as DRIVER.
cat $PEOPLE_FILE | awk -F[:] '{print "ID" $3 "-" $2 ";" $1 ";" $4 ";150"}' > $DRIVERS_FILE

#Returns confirmation of success and new DRIVERS_FILE view
./success 2 $DRIVERS_FILE