#!/bin/sh
###############################################################################
# シェル名       : Redis999002B.sh
# 機能概要       : ログからバックアップファイルを作成する。指定期間を経過したバックアップファイルを削除する。
# 実行ユーザ     : ajsjob
# パラメータ     : 起動日時($1)
# リターンコード : 正常=0,警告=40(未使用),異常=100
# 作成者/作成日  : 立原/2022年10月27日
# 更新者/更新日  : 河渡/2022年11月30日
###############################################################################

###########################################
# 共通設定
###########################################
# なし。

###########################################
# 個別設定
###########################################
readonly PARAM_LAPSED_DAYS_AP_TMP=31                                                #指定期間(テンポラリ)
readonly PARAM_LAPSED_DAYS_AP_LOG=90                                                #指定期間(APログ)
readonly TARGET_DIR_SINGLE_MASTAR="/export/containers/spring-redis-single-0/data"   #ログファイルディレクトリ(Redisシングル構成（マスタ）または、Redis可用性構成（マスタ）)
readonly TARGET_DIR_SINGLE_SLAVE1="/export/containers/spring-redis-single-1/data"   #ログファイルディレクトリ(Redis可用性構成（スレーブ1）)
readonly TARGET_DIR_SINGLE_SLAVE2="/export/containers/spring-redis-single-2/data"   #ログファイルディレクトリ(Redis可用性構成（スレーブ2）)
readonly TARGET_DIR_SENTINEL0="/export/containers/spring-redis-sentinel-0/data"     #ログファイルディレクトリ(Redis可用性構成（slot#0 sentinel）)
readonly TARGET_DIR_SENTINEL1="/export/containers/spring-redis-sentinel-1/data"     #ログファイルディレクトリ(Redis可用性構成（slot#1 sentinel）)
readonly TARGET_DIR_SENTINEL2="/export/containers/spring-redis-sentinel-2/data"     #ログファイルディレクトリ(Redis可用性構成（slot#2 sentinel）)

LOG_FILE_MNT="/export/batch/log/Redis999002B.log"                                   #メンテナンスログファイル

LOG_FILE_NAME=`date '+%Y%m%d'`                                                      #ログファイル圧縮用ディレクトリ名

###########################################
# ローテ関数
###########################################
lotate() {
	cd $1
	FILES=`find -maxdepth 1 -type f -name '*.log*' -o -name '*.out' -o -name '*.txt'`
	if [ -n "$FILES" ]; then
		# logファイルのディレクトリ格納処理
		mkdir ${LOG_FILE_NAME}
		for file in $FILES; do
			cp -p $file ${LOG_FILE_NAME}/
			cp /dev/null $file
		done

		# ログファイル圧縮
		tar --remove-files -czf ${LOG_FILE_NAME}.tar.gz ${LOG_FILE_NAME}/

		# bkへ移動
		mv ${LOG_FILE_NAME}.tar.gz ../bk
	fi

	# log系ファイルの削除処理
	find ../bk -maxdepth 1 -type f -mtime +${PARAM_LAPSED_DAYS_AP_LOG} -name '*.tar.gz' -exec rm -f {} \;
}

###########################################
# 前処理
###########################################
echo "REMOVE_TMP_FILE STARTED `date '+%Y/%m/%d %H:%M:%S'`" <&- >>${LOG_FILE_MNT} 2>&1;

###########################################
# コマンドの実行
###########################################

# Redisシングル構成 または Redisマスタ-スレーブ構成の処理
DIRS="$TARGET_DIR_SINGLE_MASTAR $TARGET_DIR_SINGLE_SLAVE1 $TARGET_DIR_SINGLE_SLAVE2"
for dir in $DIRS; do
	[ -d $dir ] || continue
	(lotate $dir)
done

# Redisセンチネル構成の処理
DIRS="$TARGET_DIR_SENTINEL0 $TARGET_DIR_SENTINEL1 $TARGET_DIR_SENTINEL2"
for dir in $DIRS; do
	[ -d $dir ] || continue
	(lotate $dir)
done

exit 0;
