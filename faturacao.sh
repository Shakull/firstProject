#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2021/2022
##
## Aluno: Nº: 103955  Nome: Diogo Ribeiro
## Nome do Módulo: faturacao.sh
## Descrição/Explicação do Módulo: BILLING report creator
##							Structure:
##							Cliente: <Client Name>
##							<TOLLS RECORD>
##								
#							#Total: <sum of his/her TOLLS> créditos
##							(...)
##
###############################################################################

#File Paths Management. Permits changing file paths without changing script.
#WARNING! Changed files must have the same structure.
TOLLS_RECORD_FILE=./relatorio_utilizacao.txt #File Structure: <ID Portagem>:<Lanço>:<ID Condutor>:<Matrícula>:<Taxa_Portagem>:<Data>
DRIVERS_FILE=./condutores.txt #File Structure: <ID>-<Nome>;<ID carta condução>;<Contacto>;<Nr Contribuinte>;<Saldo (em créditos)>
PEOPLE_FILE=./pessoas.txt #File Structure: <ID carta condução>:<Nome>:<Nr Contribuinte>:<Contacto>

#OUTPUT File Paths.
BILLING_FILE=./faturas.txt


#Checks if TOLLS_RECORD_FILE exists in the current directory. If not, returns @ERROR.
#@ERROR Non-existant file.
if [ ! -f $TOLLS_RECORD_FILE ];
	then
		./error 1 $TOLLS_RECORD_FILE
		exit
fi

#Checks if BILLING_FILE exists in the current directory and removes it.
if [ -f $BILLING_FILE ];
	then
		rm $BILLING_FILE
fi

#Checks if BILLING_FILE is empty and exits.
if [ -s $BILLING_FILE ];
	then
		exit
fi

############### vv RETURN HERE vv ###############

#Gets CLIENTS that used at least one TOLL.
#CLIENTS=$(cat $TOLLS_RECORD_FILE | awk -F[:] '{print $3}' | sort | uniq)
#echo $CLIENTS
CLIENTS_ID=$(cat $PEOPLE_FILE | awk -F[:] '{print "ID" $3}')

############### ^^ RETURN HERE ^^ ###############

#Writes the OUTPUT report per CLIENT on BILLING_FILE.
for i in $CLIENTS_ID
	do
		#Writes Client Name from DRIVERS_FILE ClientID
		echo "Cliente:"	$(cat $DRIVERS_FILE | awk -F["-;"] -v ID=$i '$1==ID {print $2}') >> $BILLING_FILE
		#Writes all Tolls registered on this Client from TOLLS_RECORD_FILE
		cat $TOLLS_RECORD_FILE | awk -v ID=$i '$3==ID {print $0}' FS=":" OFS=":" >> $BILLING_FILE
		#Writes the total ammount spent on tolls by this Client.
		echo "Total:" $(cat $TOLLS_RECORD_FILE | awk -F":" -v ID=$i '$3==ID {sum += $5} END {print sum}') "créditos" >> $BILLING_FILE
		#Writes an empty line to devide each Client's BILL
		echo >> $BILLING_FILE
	done

#Returns confirmation of success and an updated BILLING_FILE view.	
./success 5 $BILLING_FILE