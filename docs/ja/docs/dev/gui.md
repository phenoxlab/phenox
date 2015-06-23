

##GUIアプリケーションを使ってパーティションを作成する方法

fdiskだとハードルが高いという人は[GParted](http://gparted.org)を使うと
比較的簡単にパーティションが作成できます。

**(ddコマンドまで終わっていることを想定）**

1\. GPartedをインストールする

GPartedはパーティションを作成・編集するためのGUIアプリケーションです。
Ubuntuであれば以下のコマンドでインストールすることが出来ます。

```bash
sudo apt-get install gparted 
```

2\. GPartedを起動する

認証が必要となります。パスワードを入力してGPartedを起動します。
![authentication](/img/phenox_build_gui/authentication.png)


起動後の画面です。右上のプルダウンメニューが先ほど`dsmeg`で確認した
識別子となっていることを確認してください。(例では`mmcblk0`となっています。)


![init](/img/phenox_build_gui/init.png)

3\. メニューの`Device`→`Create Partition Table`を選択します。
`msdos`を選択し、パーティションテーブルを作成します。

![partition table](/img/phenox_build_gui/partition_table.png)

4\. bootパーティションを作成します。
まず、新規作成のアイコンをクリックします。

![new](/img/phenox_build_gui/new.png)

`New_size`を256、`File system`をfat32、`Label`をbootとし、
`Add`を押して作成します。

![boot](/img/phenox_build_gui/boot.png)

5\. rootパーティションを作成します。
同様に、新規作成のアイコンをクリックします。
`New_size`はデフォルトのまま、`File system`をext4、
`Label`をrootとし、`Add`を押して作成します。
![root](/img/phenox_build_gui/root.png)

6\. `Apply All Operations`のアイコンをクリックし、ディスクに書き込みます。

![apply](/img/phenox_build_gui/apply.png)

以下の警告画面が出るので、`Apply`を選択します。

![warning](/img/phenox_build_gui/warning.png)

書き込みが正常に完了すると以下の画面が出るので、`Close`を選択してください。
![complete](/img/phenox_build_gui/complete.png)

7\. bootパーティションを右クリックし、`Manage Flags`を選択します。
`boot`と`lba`にチェックをいれ、`Close`を押します。

![flag](/img/phenox_build_gui/flags.png)


以上でパーティションの作成は終了です。

パーティション構成が以下と同様になっていることを
確認の上、メニューの`GParted`→`Quit`からGPartedを終了してください。
![end](/img/phenox_build_gui/end.png)

**(8番(wget以降)からは同様の作業)**
