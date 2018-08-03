#!/bin/bash
#Script de backup inclemental com rsync
DATAINICIO=`date +%Y-%m-%d` #DATA DO SITEMA
HORAINICIO=`date +%H':'%M':'%S` #HORA DO SISTEMA
#local onde serar salvo o log do processo de backup e sincronização
LOG=/var/log/samba/backup/$DATAINICIO-$HORAINICIO-backup-incremental.log
#pasta origem para backup
ORIGEM=/origem/
#destino para o backup
DESTINO=/destino/
#pega o percetual de uso da particao de arquivos
PERCENTUAL_USO_ORIGEM=`df -h /dev/sdb1 | sed -u '2!d' | awk '{print $5}' `

echo " " >> $LOG
echo " " >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " Sincronização iniciada em $DATAINICIO $HORAINICIO " >> $LOG
echo "A partição de Origem estar com  $PERCENTUAL_USO_ORIGEM de uso" >> $LOG
#rsync e os paramentro de backup
#--exclude = arquivos que nao serao copiados no backup
rsync -Cravzp --exclude '*.JPG' --exclude '*.jpg' --exclude '*.wma' --exclude '*.mp3' \
--exclude '*.mp4' --exclude '*.avi' --exclude '*.AVI' --exclude '*.wmv' --exclude '*.WMV' \
 --exclude '*.exe' --exclude '*.EXE' --exclude '*.db' --exclude '*.log' --exclude '*.LOG' \
 --exclude '*.bin' --exclude '*.BIN' --exclude '*.mpge' --exclude '*.MPGE' --exclude '*.mpg' \
 --exclude '*.MPG' --exclude '*.gif' --exclude '*.GIF' --exclude '*.lnk' --exclude '*.LNK' \
 --exclude '*.jpge' --exclude '*.JPGE' --exclude '*.bmp' --exclude '*.html' --exclude '*.HTML' \
 --exclude '*.tmp' --exclude '*.TMP' --exclude '*.htm' --exclude '*.xhtml' --exclude '*.css' \
 --exclude '*.download' --exclude '*.BMP' --exclude '*.HTM' --exclude '*.XHTML' --exclude '*.CSS'  \
 $ORIGEM $DESTINO >> $LOG


 if [ $? = 0 ]; then  #Verifica se  backup/sincronizaçao foi bem sucedida

DATAFINAL=`date +%Y-%m-%d` #data do sistema
HORAFIM=`date +%H:%M:%S`  #hora do sistema
PERCENTUAL_USO_DESTINO=`df -h /dev/sdb1 | sed -u '2!d' | awk '{print $5}' `
echo "A partição de Backup estar com $PERCENTUAL_USO_DESTINO de uso" >> $LOG
echo " Sincronização Finalizada em $DATAFINAL $HORAFIM " >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo "" >> $LOG

else


DATAFINAL=`date +%Y-%m-%d` #data do sistema
HORAFIM=`date +%H:%M:%S`  #hora do sistema
echo "" >> $LOG
echo "Ocorreu erro no processo de Backup/Sincronização" >> $LOG
echo " Sincronização Finalizada em $DATAFINAL $HORAFIM " >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " " >> $LOG
echo " " >> $LOG

fi
