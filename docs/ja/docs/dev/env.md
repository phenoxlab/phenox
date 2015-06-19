# マイクロ SD カード上に環境構築をする
Phenox2 には Linux (Ubuntu 13.04) が搭載されており、
この Linux 上で飛行制御システムが作動しています。
この Linux はマイクロ SD カード上に構築されており、
ユーザーの好みに応じてカスタマイズすることが可能です。
ここでは、出荷時と同等の環境をマイクロ SD カード上に構築する方法を説明します。

なお以下の環境構築には Ubuntu 14.04 LTS を使用しています。

1\. まず、4 GB以上の容量を持った マイクロ SD カードを用意してください。
SD カード内にデータがある場合は、環境構築を行うと全て失われてしまいますので、
必要に応じてバックアップを取ってください。

2\. ターミナル（端末、Terminal）を開きます。
デスクトップからメインメニューを開いてください。
![ターミナルの開き方1] (/img/phenox_build_ja/1.1.open_terminal.png)

検索窓に "terminal" と入力し、`端末`をクリックしてください。
![ターミナルの開き方2] (/img/phenox_build_ja/1.2.open_terminal.png) 

ターミナルが開き、待機状態になります。
![ターミナルの開き方2] (/img/phenox_build_ja/1.4.open_terminal.png) 

3\. 用意した SD カードをコンピューターに接続してください。

4\. SD カードの識別子を確認します。
ターミナルで`dmesg`コマンドを実行してください。    
（`dmesg`と入力して`Enter`を押してください。）   
![ターミナルの開き方3] (/img/phenox_build_ja/2.1.find_identifier.png)

画面出力の最後の方に SD カードについてのメッセージが現れます。
![SDカードの識別子を探す1] (/img/phenox_build_ja/2.2.find_identifier.png)

メッセージの中に、以下の写真で示すような `sdX` (`X`部分は環境によって変化します)
の文字を探します。この例では識別子は `sdb` となっています。
![SDカードの識別子を探す2] (/img/phenox_build_ja/2.3.find_identifier.png)

5\. SD カードのフォーマットを行います。
次のコマンドの `sdX` 部分を先程確認した値に置き換え、実行してください。
```bash
sudo dd if=/dev/zero of=/dev/sdX bs=1024 count=1
```
![SDカードのフォーマット1] (/img/phenox_build_ja/3.1.format.png)

`sudo` を実行するのが初めての場合は、管理者権限のパスワードを尋ねられます。
パスワードを入力して `Enter` を押してください。
![SDカードのフォーマット2] (/img/phenox_build_ja/3.2.format.png)

以下のような出力が出れば成功です。
![SDカードのフォーマット2] (/img/phenox_build_ja/3.3.format.png)

6\. 次に SD カードにパーティションを２つ作成します。
次のコマンドの `sdX` 部分を先程確認した値に置き換え、実行してください。
```bash
sudo fdisk /dev/sdX
```
ターミナルが対話モードに切り替わります。
![SDカードのパーティション作成1] (/img/phenox_build_ja/4.1.partition.png)

`コマンド（mでヘルプ）:`と出ますので`n` と入力します。
![SDカードのパーティション作成1.2] (/img/phenox_build_ja/4.1.2.partition.png)

`Select (default p):`に`p` と入力します。
![SDカードのパーティション作成2] (/img/phenox_build_ja/4.2.partition.png)

`パーティション番号（1-4、初期値１）:` に`1` と入力します。
![SDカードのパーティション作成3] (/img/phenox_build_ja/4.3.partition.png)

`最初 セクタ （2048-XXXXXXX、初期値 2048）：`には何も入力しないで `Enter` を押します。
![SDカードのパーティション作成4] (/img/phenox_build_ja/4.4.partition.png)

`初期値 2048を使います`と出力されます。
![SDカードのパーティション作成5] (/img/phenox_build_ja/4.5.partition.png)

`Last セクタ, +セクタ数 or +size{K,M,G} (2048-XXXXXXX, 初期値 XXXXXXX)：`に`+256M` と入力します。
![SDカードのパーティション作成6] (/img/phenox_build_ja/4.6.partition.png)

特に出力はありませんが、これで１つ目のパーティション作成は完了です。
![SDカードのパーティション作成7] (/img/phenox_build_ja/4.7.partition.png)

続けて二つ目のパーティションを作成します。    
`コマンド（mでヘルプ）:`に`n`、    
`Select (default p):`に`p`、     
`パーティション番号（1-4、初期値１）:` に`2` と順に入力していきます。
![SDカードのパーティション作成8] (/img/phenox_build_ja/4.8.partition.png)

`最初 セクタ （XXXXXXX-YYYYYYY、初期値 XXXXXXX）：`には何も入力しないで `Enter` を押します。    
![SDカードのパーティション作成8] (/img/phenox_build_ja/4.9.1.partition.png)

`初期値 XXXXXXXを使います`と出力されます。
![SDカードのパーティション作成8] (/img/phenox_build_ja/4.9.2.partition.png)


`Last セクタ, +セクタ数 or +size{K,M,G} (XXXXXXX-YYYYYYY, 初期値 YYYYYYY)：`に再び何も入力しないで `Enter`を押します。
![SDカードのパーティション作成9] (/img/phenox_build_ja/4.10.1.partition.png)

２つ目のパーティション作成が完了しました。
![SDカードのパーティション作成9] (/img/phenox_build_ja/4.10.2.partition.png)


次に、それぞれのパーティションのシステムタイプと ID を変更します。
まずパーティション１のシステムタイプを変更します。
`コマンド（mでヘルプ）:`と出ますので`a` と入力します。  
![SDカードのパーティション作成10] (/img/phenox_build_ja/4.11.partition.png)


`パーティション番号（1-4）:` に `1` と入力します。
![SDカードのパーティション作成11] (/img/phenox_build_ja/4.12.partition.png)


`コマンド（mでヘルプ）:`に`t` と入力します。
![SDカードのパーティション作成12] (/img/phenox_build_ja/4.13.partition.png)


`パーティション番号（1-4）:` に `1` と入力します。
![SDカードのパーティション作成13] (/img/phenox_build_ja/4.14.partition.png)


`16進数コード（Lコマンドでコードリスト表示）：` に `c` と入力します。
![SDカードのパーティション作成14] (/img/phenox_build_ja/4.15.partition.png)
パーティション１のシステムタイプが変更されました。


次はパーティション２のシステムタイプを変更します。
`コマンド（mでヘルプ）:`に`t` と入力します。
![SDカードのパーティション作成15] (/img/phenox_build_ja/4.16.partition.png)


`パーティション番号（1-4）:` に`2` と入力します。
![SDカードのパーティション作成16] (/img/phenox_build_ja/4.17.partition.png)


`16進数コード（Lコマンドでコードリスト表示）：` に `83` と入力します。
![SDカードのパーティション作成17] (/img/phenox_build_ja/4.18.partition.png)
パーティション２のシステムタイプが変更されました。


これまでの入力を確認します。
`コマンド（mでヘルプ）:`に`p` と入力します。
![SDカードのパーティション作成19] (/img/phenox_build_ja/4.19.partition.png)
<br>
次のようになっていることを確認します。(数字部分は環境によって異なります)

|デバイス| ブート | 始点 | 終点 | ブッロク | Id | システム |
|:---------|:----- |:------- |:------- |:------- |:-- |:-------|
|/dev/sdX1 |   *   | XXXXXXX | YYYYYYY | BBBBBBB |  c | W95 FAT32 (LBA)|
|/dev/sdX2 |   | XXXXXXX | YYYYYYY | BBBBBBB | 83 | Linux|

もし結果が違っていれば、`Ctrl+c`で操作を中断し、一連の操作を最初からやり直してください。
正しく進んでいれば `w` を入力し、変更を反映させます。
![SDカードのパーティション作成18] (/img/phenox_build_ja/4.20.partition.png)
fdisk の書き込みが完了したら、SD カードを一度抜き、再び差し直します。

7\. 作成した２つのパーティションにファイルシステムを構築します。    
次の２つのコマンドを、`sdX` を先程確認した値に置き換えた上で、順番に実行してください。    
```bash
sudo mkfs.vfat -F 32 -n boot /dev/sdX1
sudo mkfs.ext4 -L root /dev/sdX2
``` 

(注意：このコマンドでは先程作成したパーティションを指定するために、
`sdX` の後に `1`, `2` が付け加わっています。注意して実行してください。)
![SDカードのファイルシステム構築1] (/img/phenox_build_ja/5.1.mount.png)

![SDカードのファイルシステム構築2] (/img/phenox_build_ja/5.2.mount.png)

![SDカードのファイルシステム構築3] (/img/phenox_build_ja/5.3.mount.png)

![SDカードのファイルシステム構築4] (/img/phenox_build_ja/5.4.mount.png)
処理が完了したら、SD カードを一度抜き、再び差し直します。

8\. 最後に、Phenox Lab の Web サイトより、
必要なソフトウェアをダウンロードし、SD カード上に展開します。

以下のコマンドを実行して、ソフトウェアをダウンロードしてください。```bash
wget http://phenoxlab.com/static/phenox_boot_master.tar.gz
wget http://phenoxlab.com/static/phenox_ubuntu_master.tar.gz
```
![ダウンロード1] (/img/phenox_build_ja/6.1.download.png)

![ダウンロード2] (/img/phenox_build_ja/6.2.download.png)

![ダウンロード3] (/img/phenox_build_ja/6.3.download.png)

![ダウンロード4] (/img/phenox_build_ja/6.4.download.png)


次に、以下のコマンドでダウンロードした圧縮ファイルを解凍します。
```bash
tar zxvfp phenox boot master.tar.gz
tar zxvfp phenox ubuntu master.tar.gz
```
最後に、解凍したファイルを SD カードにコピーします。
以下のコマンドの `<username>` 部分を現在ログインしているユーザー名に置き換え、実行してください。    
写真の例ではユーザー名は `phenox` になっています。    
（なお、最後のコピーには時間がかかりますのでご注意ください。）
```bash
cp -a phenox boot master/* /media/<username>/boot
sudo cp -a phenox ubuntu master/* /media/<username>/root
```
![コピー1] (/img/phenox_build_ja/7.1.copy.png)

![コピー2] (/img/phenox_build_ja/7.2.copy.png)
![コピー3] (/img/phenox_build_ja/7.3.copy.png)

![コピー4] (/img/phenox_build_ja/7.4.copy.png)

コピーが完了したら、SD カードをコンピューターから取り出します。
次のコマンドの `<username>` 部分を現在ログインしているユーザー名に置き換え、実行してください。  　
```bash
umount /media/<username>/root /media/<username>/boot
```
![アンマウント] (/img/phenox_build_ja/8.unmount.png)
