このチュートリアルは以下の作業の習得を目的としています。なお、ホストPCとしてUbuntu14.04を使用します。

- サンプルコードを実行し、PythonからPhenox APIを利用する方法を確認します。
- いくつかの具体例を通じ、PythonライブラリとC言語ライブラリの相違および注意点を確認します。

本チュートリアルの前に[Python環境の構築](../dev/pythonenv)を完了していることが前提となります。

# 1. 電源、シリアル通信の準備
[電源について](../start/power) を参考に電源のセットアップを行い、[通信方法について](../start/com)を参考にシリアル通信あるいはSSH接続によるログインまで進んでください。本チュートリアルはシリアル通信、SSH接続のいずれでも実行可能です。

# 2. LED点滅サンプルコードの実行
サンプルプログラムが配置されたディレクトリに移動します。
```bash
cd /root/phenox/work/python_tutorial
ls
```

ここにはサンプルとして4つのPythonスクリプトが配置されています。
```bash
autohover.py
get_image.py
led_blink.py
phenox_params.py
```

ここでは上記のうち`led_blink.py`および`get_image.py`を実行してみましょう。Phenox2を平らな所に置き、サンプルコードを実行します。
```bash
python led_blink.py
```

このプログラムでは以下の処理が行われます。

1. Phenoxライブラリの初期化
2. 1秒おきにPhenox2上面後部に装着された赤色LEDを点滅させる

このプログラムは中断されない限り継続します。動作を確認したら、`Ctrl+c`コマンドによってプログラムを終了してください。


# 3. 対話型モードによる再現
サンプルコードの処理内容をより明確に理解するため、Pythonの対話型モード環境で同様の処理を実践してみます。

```bash
python
```

Python対話型モードが開始したら、はじめにPhenox2のラッパーライブラリをimportします。
```Python
import phenox as px
```

ここでpxは単なる短縮表記なので、他の名前を用いたりphenoxというモジュール名をそのまま使っても構いません。準備が完了したら`led_blink.py`中の処理、つまりLEDの点灯を手作業で試してみます。
```Python
px.set_led(0, True)
```

これにより、Phenox2の基盤上面に取り付けられた赤色LEDが点灯します。消灯も同様です。
```Python
px.set_led(0, False)
```

今度はLEDが消灯します。以上を繰り返すことでLEDを点滅させることが出来ます。また`set_led`関数の第一引数に`1`を指定して同様にすることで、緑色LEDを点滅させることも可能です。動作が確認できたら対話型モードを終了してください。
```Python
exit()
```

なおC言語プログラムの場合プログラム終了前に`pxclose_chain`関数を呼び出す必要がありますが、Pythonの場合は不要です(実行するとプログラム終了時にメモリエラーが起きてしまうので実行しないでください)。


# 4. カメラによる画像取得サンプルコードの実行
LEDより実用性の高い例としてカメラによる画像取得を行います。
```bash
cd /root/phenox/work/tutorial_python
python get_image.py
```

このスクリプトでは以下の処理を行います。

1. Phenoxライブラリの初期化
2. 前方カメラで撮影した画像を2枚取得
3. 取得した画像を`test_iplimage.jpg`および`test_ndarray.jpg`という名前で保存

なお撮像が安定するまでの時間を確保するため、このプログラムは初期化後に約1秒待機するようになっています。

画像が取得出来たらPhenoxをシャットダウンし、SDカードを取り出してホストPCに挿入し、画像を確認します。ファイルの権限書き換えが必要なことに注意してください。
```bash
cd /media/<username>/root/root/phenox/work/tutorial_python
sudo chmod 777 test_iplimage.jpg
sudo chmod 777 test_ndarray.jpg
xdg-open test_iplimage.jpg
```

なお、ホストPCがUbuntuではない場合はSDカードの`root`パーティションが認識されない場合があります。その場合は[プロジェクトのビルド](./build)で"5.プログラムの実行"に記載された方法を参考に`get_image.py`の保存ファイル名を書き換えて下さい。


