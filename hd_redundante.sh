#!/bin/bash
#----------------Ivonielson Freitas---------------------------------------------------------------------------
#----------------E-mail: ivonielsonfreitas@gmail.com----------------------------------------------------------
#----------------Linkedin: https://br.linkedin.com/in/ivonielson-freitas-19707576-----------------------------
#Deixa o hd redundante, localiza e apaga o arquivo mais antigo quando o hd atingir o limite estabelecido na variavel LIMIT_MAXIMO
#
#
LOG='/var/log/log_redundancia.log' #variavel que armazena o local e arquivo de log
FIND_LOCAL='/usl/local/ftp/dvr' #variavel que armazendo o local onde o find irar pesquisar os arquivos antigos
DISCO='/dev/sda3'
LIMIT_MAXIMO='85' #percentual maximo para gravação no disco
REPETIR_EM='30' #tempo para o laço se execultado em segundos
echo Script inicializado em `date +%d/%m/%Y-%H:%M:%S` >>  $LOG;  
#o script aguarda 30 segundos para entrar no laço
sleep 30;

#laço serar repetido conforme o valor definido na variavel $REPETIR_EM
while :; do
	DATE_TIME=`date +%d/%m/%Y-%H:%M:%S`
	#sed = corta a linha de cabeçalho do resulta df -h + ponto de montagem
	#awk = printa a 5 coluna da linha
	#cut = retira o % e printa o valor do primeiro indice
	PERCENTUAL_USO=`df -h $DISCO | sed -u '2!d' | awk '{print $5}' | cut -d'%' -f1` && 
		if [ $PERCENTUAL_USO -ge $LIMIT_MAXIMO ] ; then
		    ARQUIVO_ANTIGO=`find $FIND_LOCAL -type f -printf '%T+ %p\n' | sort | head -n 1 | awk '{print $2}'`
			echo $DATE_TIME '|' Disco com  $PERCENTUAL_USO% de uso >> $LOG; 
			echo Lista de Arquivos a serem excluidos >> $LOG; 
			echo $ARQUIVO_ANTIGO >> $LOG; 
			 #remove o arquivo mais antigo do ponto de montagem especifico na variavel $FIND_LOCAL
			rm -f $ARQUIVO_ANTIGO;  
			echo '' >> $LOG;  
			  #aguarda tempo para repetir a verifcação
			sleep $REPETIR_EM; 
		fi  ;

done


