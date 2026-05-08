###########################
# ベースイメージのインストール
###########################
FROM ubuntu:latest

########################################################################
# RUN命令でコンテナ内にrsyslogエージェントなどの必要エージェントをインストール
########################################################################
# RUN命令は、コンテナ起動時にコンテナ自体に対して投げるコマンドを書く

# rsyslogのインストール
RUN apt-get update
RUN apt-get install -y -q rsyslog

# ダウンロードしたパッケージ(ライブラリ)のキャッシュを削除する。Dockerイメージのサイズ削減のため。
RUN apt-get clean

# apt-get updateで取得したパッケージ(ライブラリ)の一覧リストを削除する。これもイメージサイズ削減のため。
RUN rm -rf /var/lib/apt/lists/*

# rsyslog.sysconfigファイルをホストからサーバにコピーする
COPY rsyslog.sysconfig /etc/sysconfig/rsyslog

# chmodコマンドでファイルの権限を変更する
# 755は、[所有者]=7, [グループ]=5, [その他ユーザ]=5
# Read=4, Write=2, Execute=1なので、7=4+2+1(読む/書く/実行できる), 5=4+1(読む/実行できる)
RUN chmod 755 /etc/sysconfig/rsyslog

##################################################
# COPY命令でホスト側のconfigファイルをサーバ側にコピー
##################################################
COPY ./rsyslog.conf /etc/rsyslog.conf
COPY rsyslog.init /etc/sysconfig/rsyslog
COPY rsyslog.log /etc/logrotate.d/rsyslog

############################
# rsyslog(rsyslogd)を起動する
############################
CMD [ "rsyslogd", "-n" ]

# rsyslogd -N 1でrsyslog.confファイルをチェックし、問題無ければ、rsyslogd -n でフォアグラウンド起動する
#CMD [ "sh", "-c", "rsyslogd -N 1 && rsyslogd -n" ]
