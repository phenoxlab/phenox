#　ホーム
Welcome to Phenox documentation. 

Phenox プロジェクトについては[こちら](http://phenoxlab.com/?lang=ja)を参照ください。

このページでは Phenox2 開発キットの使い方、API の仕様について説明します。

Phenox はユーザーがプログラムを書き換えることで、独自の挙動を実行することができます。しかし、周辺環境の状態によっては予期しない動作を行うことがあります。この章では Phenox を安全に使うために必要な事項を説明してきます。実機に触れながら理解を深めて、読み進めていってください。

##ファームウェアの更新
ファームウェアは不定期に更新されることがあります。ファームウェアの更新方法は、以下のURLよりファイルをダウンロード・展開し、microSDカードにコピーしてください。
```bash
http://phenoxlab.com/static/phenox_boot_master.tar.gz
http://phenoxlab.com/static/phenox_ubuntu_master.tar.gz
```
なお、現状のリビジョン番号はmicroSDカード内の"boot"フォルダと"root"フォルダ内にある,"revision.log"を見ることで確認が可能です。
##phenox_boot_master ("boot"フォルダにコピーするファイル)
最新版は20150930です。
##phenox_ubuntu_master ("root"フォルダにコピーするファイル)
最新版は20150917です。
