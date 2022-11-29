#!/bin/sh
###############################################################################
# シェル名       : Redis999002B.sh
# 機能概要       : 指定期間を経過したファイルを削除する。バックアップログファイルを圧縮する(アプリ用ファイルサーバ)
# 実行ユーザ     : ajsjob
# パラメータ     : 起動日時($1)
# リターンコード : 正常=0,警告=40(未使用),異常=100
# 作成者/作成日  : 立原/2022年10月27日
# 更新者/更新日  : 立原/2022年11月14日
###############################################################################

###########################################
# 共通設定
###########################################
# なし。

###########################################
# 個別設定
###########################################
readonly PARAM_LAPSED_DAYS_AP_TMP=31                                                                   #指定期間(テンポラリ)
readonly PARAM_LAPSED_DAYS_AP_LOG=90                                                                   #指定期間(APログ)
readonly TARGET_DIR_SINGLE_MASTAR="/export/containers/spring-redis-single-0/data"                      #ログファイルディレクトリ(Redisシングル構成（マスタ）または、Redis可用性構成（マスタ）)
readonly TARGET_DIR_SINGLE_SLAVE1="/export/containers/spring-redis-single-1/data"                      #ログファイルディレクトリ(Redis可用性構成（スレーブ1）)
readonly TARGET_DIR_SINGLE_SLAVE2="/export/containers/spring-redis-single-2/data"                      #ログファイルディレクトリ(Redis可用性構成（スレーブ2）)
readonly TARGET_DIR_SENTINEL0="/export/containers/spring-redis-sentinel-0/data"                        #ログファイルディレクトリ(Redis可用性構成（slot#0 sentinel）)
readonly TARGET_DIR_SENTINEL1="/export/containers/spring-redis-sentinel-1/data"                        #ログファイルディレクトリ(Redis可用性構成（slot#1 sentinel）)
readonly TARGET_DIR_SENTINEL2="/export/containers/spring-redis-sentinel-2/data"                        #ログファイルディレクトリ(Redis可用性構成（slot#2 sentinel）)

BK_DIR_SINGLE_MASTAR="/export/containers/spring-redis-single-0/bk"                                     #バックアップディレクトリ(Redisシングル構成（マスタ）または、Redis可用性構成（マスタ）)
BK_DIR_SINGLE_SLAVE1="/export/containers/spring-redis-single-1/bk"                                     #バックアップディレクトリ(Redis可用性構成（スレーブ1）)
BK_DIR_SINGLE_SLAVE2="/export/containers/spring-redis-single-2/bk"                                     #バックアップディレクトリ(Redis可用性構成（スレーブ2）)
BK_DIR_SENTINEL0="/export/containers/spring-redis-sentinel-0/bk"                                       #バックアップディレクトリ(Redis可用性構成（slot#0 sentinel）)
BK_DIR_SENTINEL1="/export/containers/spring-redis-sentinel-1/bk"                                       #バックアップディレクトリ(Redis可用性構成（slot#1 sentinel）)
BK_DIR_SENTINEL2="/export/containers/spring-redis-sentinel-2/bk"                                       #バックアップディレクトリ(Redis可用性構成（slot#2 sentinel）)

LOG_FILE_MNT="/export/batch/log/Redis999002B.log"                                                      #メンテナンスログファイル

LOG_FILE_NAME=`date '+%Y%m%d'`                                                                         #ログファイル圧縮用ディレクトリ名

###########################################
# 前処理
###########################################
echo "REMOVE_TMP_FILE STARTED `date '+%Y/%m/%d %H:%M:%S'`" <&- >>${LOG_FILE_MNT} 2>&1;

###########################################
# コマンドの実行
###########################################

# Redisシングル構成（マスタ）または、Redis可用性構成（マスタ）の処理

# logファイルのディレクトリ格納処理
cd ${TARGET_DIR_SINGLE_MASTAR}
find ${TARGET_DIR_SINGLE_MASTAR}/*.log* *.out *.txt -type f 2>/dev/null
if [ $? -eq 0 ]; then
     mkdir ${LOG_FILE_NAME}
     mv *.log* *.out *.txt ${LOG_FILE_NAME}/
     
     # ログファイル圧縮
     tar --remove-files -czf ${LOG_FILE_NAME}.tar.gz ${LOG_FILE_NAME}/
     
     # bkへ移動
     mv *.tar.gz ${BK_DIR_SINGLE_MASTAR}
fi


# log系ファイルの削除処理
LOG_LIST_SINGLE_MASTAR=`find ${BK_DIR_SINGLE_MASTAR}/*.tar.gz -type f -mtime +${PARAM_LAPSED_DAYS_AP_TMP} 2>/dev/null`
if [ "$LOG_LIST_SINGLE_MASTAR"!=0 ]; then
     for filename in $LOG_LIST_SINGLE_MASTAR
     do
       rm -f $filename
     done
fi


# Redis可用性構成（スレーブ1）の処理

# logファイルのディレクトリ格納処理
cd ${TARGET_DIR_SINGLE_SLAVE1}
mkdir ${LOG_FILE_NAME}
mv *.log ${LOG_FILE_NAME}/

# log系ファイルの削除処理
cd ${TARGET_DIR_SINGLE_SLAVE1}
find ${TARGET_DIR_SINGLE_SLAVE1}/*.log* *.out *.txt -type f 2>/dev/null
if [ $? -eq 0 ]; then
     mkdir ${LOG_FILE_NAME}
     mv *.log* *.out *.txt ${LOG_FILE_NAME}/
     
     # ログファイル圧縮
     tar --remove-files -czf ${LOG_FILE_NAME}.tar.gz ${LOG_FILE_NAME}/
     
     # bkへ移動
     mv *.tar.gz ${BK_DIR_SINGLE_SLAVE1}
fi


# log系ファイルの削除処理
LOG_LIST_SINGLE_SLAVE1=`find ${BK_DIR_SINGLE_SLAVE1}/*.tar.gz -type f -mtime +${PARAM_LAPSED_DAYS_AP_TMP} 2>/dev/null`
if [ "$LOG_LIST_SINGLE_SLAVE1"!=0 ]; then
     for filename in $LOG_LIST_SINGLE_SLAVE1
     do
       rm -f $filename
     done
fi


# Redis可用性構成（スレーブ2）の処理

# logファイルのディレクトリ格納処理
cd ${TARGET_DIR_SINGLE_SLAVE2}
find ${TARGET_DIR_SINGLE_SLAVE2}/*.log* *.out *.txt -type f 2>/dev/null
if [ $? -eq 0 ]; then
     mkdir ${LOG_FILE_NAME}
     mv *.log* *.out *.txt ${LOG_FILE_NAME}/
     
     # ログファイル圧縮
     tar --remove-files -czf ${LOG_FILE_NAME}.tar.gz ${LOG_FILE_NAME}/
     
     # bkへ移動
     mv *.tar.gz ${BK_DIR_SINGLE_SLAVE2}
fi

# log系ファイルの削除処理
LOG_LIST_SINGLE_SLAVE2=`find ${BK_DIR_SINGLE_SLAVE2}/*.tar.gz -type f -mtime +${PARAM_LAPSED_DAYS_AP_TMP} 2>/dev/null`
if [ "$LOG_LIST_SINGLE_SLAVE2"!=0 ]; then
     for filename in $LOG_LIST_SINGLE_SLAVE2
     do
       rm -f $filename
     done
fi


# Redis可用性構成（slot#0 sentinel）の処理

# logファイルのディレクトリ格納処理
cd ${TARGET_DIR_SENTINEL0}
find ${TARGET_DIR_SENTINEL0}/*.log* *.out *.txt -type f 2>/dev/null
if [ $? -eq 0 ]; then
     mkdir ${LOG_FILE_NAME}
     mv *.log* *.out *.txt ${LOG_FILE_NAME}/
     
     # ログファイル圧縮
     tar --remove-files -czf ${LOG_FILE_NAME}.tar.gz ${LOG_FILE_NAME}/
     
     # bkへ移動
     mv *.tar.gz ${BK_DIR_SENTINEL0}
fi

# log系ファイルの削除処理
LOG_LIST_SENTINEL0=`find ${BK_DIR_SENTINEL0}/*.tar.gz -type f -mtime +${PARAM_LAPSED_DAYS_AP_TMP} 2>/dev/null`
if [ "$LOG_LIST_SENTINEL0"!=0 ]; then
     for filename in $LOG_LIST_SENTINEL0
     do
       rm -f $filename
     done
fi


# Redis可用性構成（slot#1 sentinel）の処理

# logファイルのディレクトリ格納処理
cd ${TARGET_DIR_SENTINEL1}
find ${TARGET_DIR_SENTINEL1}/*.log* *.out *.txt -type f 2>/dev/null
if [ $? -eq 0 ]; then
     mkdir ${LOG_FILE_NAME}
     mv *.log* *.out *.txt ${LOG_FILE_NAME}/
     
     # ログファイル圧縮
     tar --remove-files -czf ${LOG_FILE_NAME}.tar.gz ${LOG_FILE_NAME}/
     
     # bkへ移動
     mv *.tar.gz ${BK_DIR_SENTINEL1}
fi


# log系ファイルの削除処理
LOG_LIST_SENTINEL1=`find ${BK_DIR_SENTINEL1}/*.tar.gz -type f -mtime +${PARAM_LAPSED_DAYS_AP_TMP} 2>/dev/null`
if [ "$LOG_LIST_SENTINEL1"!=0 ]; then
     for filename in $LOG_LIST_SENTINEL1
     do
       rm -f $filename
     done
fi


# Redis可用性構成（slot#2 sentinel）の処理

# logファイルのディレクトリ格納処理
cd ${TARGET_DIR_SENTINEL2}
find ${TARGET_DIR_SENTINEL2}/*.log* *.out *.txt -type f 2>/dev/null
if [ $? -eq 0 ]; then
     mkdir ${LOG_FILE_NAME}
     mv *.log* *.out *.txt ${LOG_FILE_NAME}/
     
     # ログファイル圧縮
     tar --remove-files -czf ${LOG_FILE_NAME}.tar.gz ${LOG_FILE_NAME}/
     
     # bkへ移動
     mv *.tar.gz ${BK_DIR_SENTINEL2}
fi

# log系ファイルの削除処理
LOG_LIST_SENTINEL2=`find ${BK_DIR_SENTINEL2}/*.tar.gz -type f -mtime +${PARAM_LAPSED_DAYS_AP_TMP} 2>/dev/null`
if [ "$LOG_LIST_SENTINEL2"!=0 ]; then
     for filename in $LOG_LIST_SENTINEL2
     do
       rm -f $filename
     done
fi
exit 0;
