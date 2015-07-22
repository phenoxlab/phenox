このチュートリアルは以下の作業の習得を目的としています。なお、ホストPCとしてUbuntu14.04を使用します。

- サンプルコードを実行し、PythonからPhenox APIを利用する方法を確認します。
- いくつかの具体例を通じ、PythonライブラリとC言語ライブラリの相違および注意点を確認します。

本チュートリアルの前に[Python環境の構築](../dev/pythonenv)を完了していることが前提となります。

# 1. サンプルコードの入手と配置
 [GitHub](https://github.com/atsushisugiyama/phenox_python/)のファイルを取得します。[Python環境の構築](../dev/pythonenv)で取得したディレクトリがある場合`git clone`までの操作は不要です。

```bash
cd ~
mkdir pxpy_temp
cd pxpy_temp
git clone https://github.com/atsushisugiyama/phenox_python.git
```

Phenox2用のSDカードをホストPCに挿入し、スクリプトを配置します。

```bash
cd /media/<username>/root/root/phenox/work
mkdir tutorial_python
cp -r ~/pxpy_temp/phenox_python/sample/ phenox_python/
```

ただし`<username>`はPCユーザの名前です。以上が終了したらホストPCからSDカードをアンマウントしてください。

# 2. 電源、シリアル通信の準備
[電源について](../start/power) を参考に電源のセットアップを行い、[通信方法について](../start/com)を参考にシリアル通信によるログインまで進んでください。本チュートリアルでは終了時までシリアル通信を用いてPhenoxを通信を行います。

# 3. サンプルコードの実行
先ほど SD カード内に移動したファイルがあることを確認します。
```bash
cd /root/phenox/work/python_led
ls
```

以下の3ファイルが表示されていれば問題ありません。
```bash
autohover.py
led_blink.py
phenox_params.py
```

Phenox2を平らな所に置き、サンプルコードを実行してください。
```bash
cd /root/phenox/work/python_led
python led_blink.py
```

このプログラムでは以下の処理が行われます。

1. Phenoxライブラリの初期化
2. 1秒おきにPhenox2上面後部に装着された赤色LEDを点滅させる

このプログラムは中断されない限り継続します。動作を確認したら、`Ctrl+c`コマンドによってプログラムを終了してください。


# 4. 対話型モードによる再現
サンプルコードの処理内容をより明確に理解するため、Pythonの対話型モード環境で同様の処理を実践してみます。

```bash
cd /root/phenox/work/tutorial_python
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

今度はLEDが消灯します。以上を繰り返すことでLEDを点滅させることが出来ます。また`set_led`関数の第一引数に`1`を指定して同様にすることで、緑色LEDを点滅させることも可能です。

動作が確認できたら対話型モードを終了してください。
```Python
exit()
```

なおC言語プログラムの場合プログラム終了前に`pxclose_chain`関数を呼び出す必要がありますが、Pythonの場合は不要です(逆に実行するとプログラム終了時にメモリエラーが起きてしまいます)。

