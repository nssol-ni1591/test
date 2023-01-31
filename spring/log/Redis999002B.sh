#!/bin/sh
###############################################################################
# シェル名       : Redis999002B.sh
# 機能概要       : ログからバックアップファイルを作成する。指定期間を経過したバックアップファイルを削除する。
# 実行ユーザ     : ajsjob
# パラメータ     : 起動日時($1)
# リターンコード : 正常=0,警告=40,異常=100
# 作成者/作成日  : 立原/2022年10月27日
# 更新者/更新日  : 河渡/2023年 1月31日
###############################################################################

###########################################
# 共通設定
###########################################
# なし。

###########################################
# 個別設定
###########################################
# 指定期間(テンポラリ)
readonly PARAM_LAPSED_DAYS_AP_TMP=31
# 指定期間(APログ)
readonly PARAM_LAPSED_DAYS_AP_LOG=90

# Redisログファイルディレクトリ
readonly TARGET_DIR_REDIS="/export2/containers/spring-redis-*/"

# メンテナンスログファイル
LOG_FILE_MNT="/export2/batch/redis/log/Redis999002B.log"
# ログファイル圧縮用ファイル名
LOG_FILE_NAME=`date '+%Y%m%d'`
# リターンコード
STATUS=0

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
			# 対象ファイルを空にする
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

DIRS=`find $TARGET_DIR_REDIS -name data -type d`
if [ -n "$DIRS" ]; then
	for dir in $DIRS; do
		[ -d ${dir}/../bk ] && (lotate $dir) && continue
		echo "REMOVE_TMP_FILE ERROR `date '+%Y/%m/%d %H:%M:%S'` ${dir}/../bk not found" <&- >>${LOG_FILE_MNT} 2>&1
		STATUS=40
	done
else
	echo "REMOVE_TMP_FILE ERROR `date '+%Y/%m/%d %H:%M:%S'` \$DIRS is empty" <&- >>${LOG_FILE_MNT} 2>&1
	STATUS=100
fi
exit $STATUS
