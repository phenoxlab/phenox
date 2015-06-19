# Phenox ライブラリ
Phenox ライブラリの中身は大きく分けて2つのディレクトリ (phenox/library, phenox/work) で構成されています。phenox/library にはライブラリ本体が入っており、phenox/work にはチュートリ アルやカスタムプロジェクトが入っています。phenox/work 下のプロジェクトは、phenox/library であらかじめビルドされたファイルである pxlib.a, pxlib.h, pxlib.so を取り込むことで、phenox ライブラリで提供される API を呼び出すことができます。

# カスタムプロジェクトの作成とビルド
## Phenox ライブラリの取得
市販の microSD カードを使用して Phnoex ライブラリを取得する場合は、??を参照に、環境構築を 行って下さい。
## C 言語プロジェクト
ここでは、C 言語プロジェクトを作成する方法を説明します。最も簡単な方法は、以下のように チュートリアルプロジェクトをコピーすることです。
```bash
cd /root/phenox/work/
cp -a tutorial autohover myproject
# main.c, parameter.c を適宜書き換えた上で、ビルドを行ってください。
cd /root/phenox/work/myproject
make clean all
# コンパイルされたプログラムは、その場で実行することができます。
./main
```

## Python プロジェクト
