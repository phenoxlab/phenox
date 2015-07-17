# Phenox 上で Python が実行可能な環境を整備する

ここでは [「マイクロ SD カード上に環境構築をする」](env)が終了した状態のマイクロSDカード上に、更に Python を利用できる環境を構築する手順を説明します。

Phenox2 の標準マイクロSDカードには Python 2.7 が標準でインストールされているため、このままでもPython環境は構築されていると言えます。しかしPhenox2 特有のC言語用APIを使用するには最低限のPython環境は十分ではありません。そこで有志により作成されているPythonラッパーライブラリを導入し、Phenoxの飛行や音声認識といったAPIをPythonからでも利用可能にします。なお、以下の操作ではUbuntu 14.04を使用しています。

## 1. ライブラリの入手及び配置<a id="get_library"></a>
[GitHub](https://github.com/atsushisugiyama/phenox_python/) からPhenox用のPython 関連ファイルを取得できます。
```bash
cd ~
mkdir pxpy_temp
cd pxpy_temp
git clone https://github.com/atsushisugiyama/phenox_python.git
```

Phenox2用のSDカードをホストPCに挿入し、スクリプトを配置します。

```bash
cd /media/<username>/root/root/phenox/work
mkdir phenox_python
cp ~/pxpy_temp/phenox_python/library/phenox.py phenox_python/phenox.py
```
ただし`<username>`はPCユーザの名前です。また上記の設定に加えPythonのimport設定を追加します。
```bash
cd /media/<username>/root/root
echo "export PYTHONPATH=\"/root/phenox/work/phenox_python\"" >> .bash_profile
```

この編集によって`phenox_python`ディレクトリがPythonのimport文の検索対象となります。以上の操作が完了したらSDカードを抜いてください。


## 3. 動作確認
以下の操作はPhenoxにログインした状態で行います。

[電源について](../start/power) を参考に電源のセットアップを行い、[通信方法について](../start/com)を参考にシリアル通信のセットアップと電源の投入を行い、root としてログインします。ログインが完了したらホームディレクトリでPythonの対話型モードを立ち上げます。

```bash
python
```

対話型モードを開始したらphenoxモジュールのimportを試します。

```Python
import phenox
```

エラーが出ずにphenoxモジュールが追加され、下記のメッセージが表示されたら成功です。

```Python
phenox module: CPU0 Start Initialization. Please do not move Phenox
phenox module: CPU0 Finished Initialization
```

成功、失敗に関わらずPython対話型モードを終了します。
```Python
exit()
```

## 4. エラーが発生した場合
ファイルの配置とbashの設定を確認します。まず`phenox.py`自体が正しく配置されているかどうか確認します。

```bash
cd /root/phenox/work/phenox_python/
ls
```

上記のディレクトリが存在しない場合ファイル配置に失敗しています。一方ディレクトリに正しく`phenox.py`が配置されている場合、このディレクトリであればphenoxモジュールがimportできるはずです。Python対話型モードを立ち上げ、再びimportを試みます。

```bash
python
```

```Python
import phenox
```

これでimportに成功した場合、`.bash_profile`の編集に失敗している可能性があります。

これでimportに失敗した場合、Pythonインタプリタからのエラーメッセージを細かく確認してください。エラーが`phenox.py`中で発生している場合、ダウンロードした`phenox.py'自体に問題がある可能性があります。自力でエラーを修正するか[GitHub](https://github.com/atsushisugiyama/phenox_python/)へ何らかのコンタクトを取ってください。

