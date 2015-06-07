Phenox2 では、自身の Linux システムを用いて、画像、音声、姿勢などのセンサ情報の取得や、飛行 制御、他のライブラリと連動したプログラムを作成することを可能にするための、オンボード API 群とビルド環境を提供しています。

# phenox ライブラリphenox ライブラリの中身は大きく分けて2つのディレクトリ (phenox/library, phenox/work) で構 成されています。phenox/library にはライブラリ本体が入っており、phenox/work にはチュートリ アルやカスタムプロジェクトが入っています。phenox/work 下のプロジェクトは、phenox/library であらかじめビルドされたファイルである pxlib.a, pxlib.h, pxlib.so を取り込むことで、phenox ラ イブラリで提供される API を呼び出すことができます。

# カスタムプロジェクトの作成とビルド
## Phenox ライブラリの取得
市販の microSD カードを使用して Phnoex ライブラリを取得する場合は、??を参照に、環境構築を 行って下さい。
## C 言語プロジェクトここでは、C 言語プロジェクトを作成する方法を説明します。最も簡単な方法は、以下のように チュートリアルプロジェクトをコピーすることです。```phenox# cd /root/phenox/work/phenox# cp -a tutorial autohover myproject# main.c, parameter.c を適宜書き換えた上で、ビルドを行ってください。
phenox# cd /root/phenox/work/myprojectphenox# make clean all# コンパイルされたプログラムは、その場で実行することができます。phenox# ./main
```

## Python プロジェクト
