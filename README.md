# Logserver_test
rsyslogおよびLogstashサーバをテスト/検証するためのリポジトリです。

# コマンドメモ
1. コンテナ間で通信する専用LANを作るコマンド(一回だけ叩く)
    - これを叩くとIPアドレスでは無く、コンテナ名で通信できる
      - `docker network create syslog-net`

2. コンテナイメージのデプロイ
    - `docker build -t sample_rsyslog_server:1.0 -f .\receiver\Dockerfile .\receiver\`

3. rsyslogサーバコンテナを起動する
    - コンテナを作り直す場合：`docker rm -f rsyslog-server`
    - `docker run -d --name rsyslog-server --network syslog-net -p 514:514/tcp sample_rsyslog_server:1.0`

4. sender/ホスト側コンテナを起動する
    - `docker run -it --name sender --network syslog-net sender:1.0`

5. コンテナ一覧確認
    - `docker ps` または `docker container ls`

6. ログ送信の確認
    - `logger`コマンドは、syslogにログを投げるための送信ツール
    - `logger -n rsyslog-server -P 514 -T "hello rsyslog server"`
```
logger "hello"
logger -p daemon.crit "critical error"
logger -n rsyslog-server -P 514 -T "remote log"
```

7. syslogサーバのTerminalに入り、ログ送信されたか確認する
    - `docker exec -it {コンテナIDまたはコンテナ名} bash`