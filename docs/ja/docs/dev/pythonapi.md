ここで紹介する関数の使用例は、チュートリアルを参照してください。

# はじめに
Python APIはC言語用APIのラッパーとして実装されています。
ライブラリの入手は[Python環境の構築](./pythonenv)を参考に行ってください。

Python APIはC言語用APIと細かい点が異なります。特に重要な差異を次に示しますが、これ以外にも細かな変更が行われている事に注意してください。

 - C言語APIでは初期化として`pxinit_chain`および`pxget_cpu1ready`関数を用いたユーザーコードが必要ですが、Python APIではモジュールをimportした時点で初期化が完了するため、import以外の初期化は不要です(透過性を重視して`pxinit_chain`等のラップ関数も用意していますがユーザコードで使用しないでください)。
 - C言語用APIで定義されている構造体とは別の名前でPython APIの対応クラスが定義されています。たとえばC言語用APIの`px_pconfig`構造体はPython APIでは`phenox.PhenoxConfig`クラスとして定義されています。これはPythonの命名規則などを考慮した命名修正です。
 - C言語用APIで引数や戻り値が`0または1`の形で用いられているもので`bool`による置き換えが自然であるものについてはPython APIでは`bool`型を使用できます。


# 基本関数、状態取得関数
### phenox.init_chain()
`pxinit_chain`のラッパー関数です。飛行制御システム (CPU1) を起動し、パラメータの初期化を行います。戻り値はありません。

### phenox.get_cpu1ready()
`pxget_cpu1ready()`のラッパー関数です。`phenox.init_chain()`実行後、飛行制御システム(CPU1)の準備ができた場合はTrueを返し、それ以外ではFalseを返します。飛行制御システムの準備が完了してから3秒後にジャイロセンサのキャリブレーションが実行されるため、キャリブレーションの終了までは機体を必ず静止させ、Phenox2を手で掴まないで下さい。

### phenox.get_motorstatus()
`pxget_motorstatus()`のラッパー関数です。モーターが回転状態(上昇状態、ホバー状態、下降状態)のときはTrueを返し、それ以外ではFalseを返します。

### phenox.get_pconfig(param=None)
`pxget_pconfig(px_pconfig *param)`のラッパー関数です。現在の機体パラメータを取得します。

この関数は引数によって挙動を変化させます。引数が後述する`PhenoxConfig`型変数である場合、引数として与えられたparamに機体パラメータが書き込まれ、戻り値はありません。
```Python
pconfig = phenox.PhenoxConfig()
phenox.get_pconfig(pconfig)
```
それ以外の場合、新たに生成された`PhenoxConfig`型の変数に機体パラメータが書き込まれ、戻り値として返されます。
```Python
pconfig = phenox.get_pconfig()
```

前者の方法は分かりづらい代わりパフォーマンスに優れています。もしこの関数を頻繁に呼び出すのであれば前者の方法を利用してください。

### phenox.set_pconfig(param)
`pxset_pconfig(px_pconfig *param)`のラッパー関数です。`PhenoxConfig`型変数である`param`を受け取り、paramに格納されたパラメータを飛行制御システムに反映します。パラメーターの一部を書き換える場合は

```Python
pconfig = phenox.get_pconfig()

#pconfigのパラメータを書き換える

phenox.set_pconfig(pconfig)
```

のような手順を踏んでください。



### phenox.get_selfstate(state=None)
`pxget_selfstate(px_selfstate *state)`のラッパー関数です。機体の状態の一覧 (`SelfState`構造体を参照)を取得します。

この関数は引数によって挙動を変化させます。引数が後述する`SelfState`型変数である場合、引数として与えられた`state`に機体の状態が書き込まれ、戻り値はありません。

```Python
state = phenox.SelfState()
phenox.get_selfstate(state)
```

それ以外の場合、新たに生成された`SelfState`型の変数に機体パラメータが書き込まれ、戻り値として返されます。

```Python
state = phenox.get_selfstate()
```

前者の方法はパフォーマンスに優れています。この関数を頻繁に呼び出す場合(飛行制御では多くの場合そのようになります)は前者の方法を用いてください。


### phenox.set_keepalive()
`pxset_keepalive()`のラッパー関数です。機体制御システムに対して、Linux(CPU0)がphenoxモジュールを使用したアプリケーションを実行中であることを伝えます。戻り値はありません。この関数は、ユーザー自身がタイマー割り込み関数などを用いて定期的に呼び出すようにしてください。

### phenox.get_battery()
`pxget_battery()`のラッパー関数です。バッテリの残量状態を取得します。バッテリの残量が残り少ない状態では`True`を返し、それ以外では`False`を返します。この値が`True`になった場合は、飛行制御システムによって自動的に、ホバー状態 (`phenox.PX_HOVER`)のPhenoxは下降状態 (`phenox.PX_DOWN`) に遷移し、`PhenoxConfig`の`downtime_max`で指定した時間(秒)が経過した後、停止状態(`phenox.PX_HALT`)に遷移します。この関数の戻り値が`True`であった場合、速やかにユーザプログラムを終了し`shutdown`コマンドなどを用いてLinuxシステムをシャットダウンしてください。あるいはプログラム中でシャットダウン処理を実行できるようにしてください。

# 制御関数
### phenox.get_operate_mode()
`pxget_operate_mode()`のラッパー関数です。飛行状態を取得します。戻り値は整数であり4種類の定数によって対応(`phenox.PX_HALT=0, phenox.PX_UP=1, phenox.PX_HOVER=2, phenox.PX_DOWN=3`)があり、それぞれ停止状態、上昇状態、ホバー状態、下降状態を表します。

### phenox.set_operate_mode(mode)
`pxset_operate_mode(`px_flymode` mode)`のラッパー関数です。
飛行状態を設定します。`px_flymode` 型は 4 種類の状態 (`phenox.PX_HALT, phenox.PX_UP, phenox.PX_HOVER, phenox.PX_DOWN`) があり、それぞれ停止状態、上昇状態、ホバー状態、下降状態を表します。

`phenox.HALT`を指定するとプロペラを即時停止させます。`phenox.PX_UP`を指定すると`PhenoxConfig`上で設定した`uptime_max`の時間(秒)だけ上昇を行いホバー状態へ移行します。`phenox.PX_DOWN`を指定すると`PhenoxConfig`上で設定した`downtime_max`の時間(秒)だけ下降し停止状態へ移行します。また`PX_HALT`状態から他の状態へ遷移する場合には、3秒間の始動状態(プロペラの弱い回転運動状態)が飛行制御システムによって挿入されます。

### phenox.set_visioncontrol_xy(tx, ty)
`pxset_visioncontrol_xy(float tx, float ty)`のラッパー関数です。水平方向 (機体軸 X,Y) の目標自己位置を設定し、飛行状態の場合(`phenox.get_operate_mode()`の戻り値が`phenox.HOVER`である場合)はPhenox2を追従させます。引数 `tx`, `ty` には、現在の水平方向位置 (`SelfState` 構造体の `vision_tx`, `vision_ty`) に、移動したい方向の小ベクトル (大きさ −120 ∼ 120 程度) を足した量を指定することを強くお勧めします(チュートリアル参照)。    
飛行制御プログラム(CPU1)は、`PhenoxConfig`の`pgain_vision_tx`, `pgain_vision_ty`(比例ゲイン) と `dgain_vision_tx`, `dgain_vision_ty` (微分ゲイン) で指定した強度に応じて目標位置に追従しようと試みます。なお本制御に積分項は含まれておらず多少のバイアスが残るため、必要に応じてユー ザー自身で積分項を入れるか、画像情報を元にバイアス (`PhenoxConfig`の`duty_bias*`変数)を補正するなどの試みを行って下さい。また座標系は画像座標系で表現されるため、移動量は地面からの距離に反比例します。そのため、必要に応じて高度情報(`SelfState`の`height`変数)を加味したゲイン設定を行って下さい。
###### DOTO: Check duty_bias* <- pointer?

### phenox.set_rangecontrol_z(tz)
`pxset_rangecontrol z(float tz)`のラッパー関数です。
高度方向(機体軸 Z)の目標自己位置を設定し、飛行状態の場合(`phenox.get_operate_mode()`の戻り値が`phenox.HOVER`の場合)はPhenox2を追従させます。水平方向の移動量は下向きカメラを用いることに対して、高度方向の制御は超音波センサを用いているため、機体軸XYとZとの間で関数が分かれています。 `tz`の単位はセンチメートルで、指定する値は100 ∼ 180の範囲をお勧めします。飛行制御プログラム(CPU1)は、`PhenoxConfig`構造体の`pgain_sonar_tz`,(比例ゲイン)と`dgain_sonar_tz`(微分ゲイン)で指定した強度に応じて目標位置に追従しようと試みます。なおこの制御に積分項は含まれておらず、積載重量とパラメータ(`PhenoxConfig`上の`duty_hover`変数)によっては大きなバイアスが残るため、必要に応じてユーザー自身で積分項を入れるか、高度情報を元にバイアス(`PhenoxConfig`上の`duty_hover`変数)を補正するなどの試みを行って下さい。

### phenox.set_dst_degx(val)
`pxset_dst_degx(float val)`のラッパー関数です。
Phenox2の`degx`(機体軸 X に対する右ネジ向きの回転角度)の目標値を度数法で設定し、飛行状態の場合(`phenox.get_operate_mode()`の戻り値が`phenox.HOVER`の場合)はPhenox2 を追従させます。この関数には有効期間(`PhenoxConfig`構造体の`selxytime_max`)が秒単位で設定されており、本関数を最後に実行してから設定時間以上が経過すると、飛行制御プログラムによって自動的に、下向きカメラの画像特徴点を元に推定した自己制御(`pxset_visioncontrol_xy()`)が行われ、現在の位置に留まろうとする制御が行われます。従って、常に指定した角度にPhenox2を制御させたい場合はタイマ割り込み関数などを用いて、周期的に本関数を呼び出す必要があります。大きな値を指定するほど急な移動につながりますので、指定する値としては 0 ∼ 10.0 を目安としてください。

### phenox.set_dst_degy(val)
`pxset_dst_degy(float val)`のラッパー関数です。
Phenox2の`degy`(機体軸Yに対する右ネジ向きの回転角度)の目標値を度数法で設定し、飛行状態の場合(`phenox.get_operate_mode()`の戻り値が`phenox.HOVER`の場合)はPhenox2 を追従させます。この関数には有効期間(`PhenoxConfig`構造体の`selxytime_max`)が秒単位で設定されており、本関数を最後に実行してから設定時間以上が経過すると、飛行制御プログラムによって自動的に、下向きカメラの画像特徴点を元に推定した自己制御(`pxset_visioncontrol_xy()`)が行われ、現在の位置に留まろうとする制御が行われます。従って、常に指定した角度にPhenox2を制御させたい場合はタイマ割り込み関数などを用いて、周期的に本関数を呼び出す必要があります。大きな値を指定するほど急な移動につながりますので、指定する値としては 0 ∼ 10.0 を目安としてください。


### phenox.set_dst_degz(val)
`void pxset_dst_degy(float val)`のラッパー関数です。
Phenox2の`degz`(機体軸Zに対する右ネジ向きの回転角度)の目標値を度数法で設定し、飛行状態の場合(`phenox.get_operate_mode()`の戻り値が`phenox.HOVER`の場合)はPhenox2を追従させます。引数は離陸時のZ角度を0とした相対値で指定します。たとえばPhenox2が周囲を見回すような動きを生成するためには
```
for i in range(360):
    phenox.set_dst_degz(i)
    #待機処理など
```
のような呼び出し方が必要になります。本関数はXY軸の回転角度制御関数(`phenox.set_dst_degx`, `phenox.set_dst_degy`)と異なり、時間が経過しても指定した値を維持し続けます。

### phenox.set_visualselfposition(tx, ty)
`pxset_visualselfposition(float tx,float ty)`のラッパー関数です。`SelfState`クラスの`vision_tx`および`vision_ty`をそれぞれ、引数に指定した `tx`および`ty`の値に修正します。本関数を実行すると`phenox.set_visioncontrol_xy`関数が影響を受けます。(そのため、`pxset_visioncontrol_xy`関数の引数`tx`, `ty`を設定する際には単なる絶対座標を指定するのではなく、`phenox.get_selfstate`関数を用いて現在の状態を`SelfState`型変数として取得し、`vision_tx`, `vision_ty`を得た上で、これらの変数に移動したい相対位置を足した量として`tx`, `ty`を指定するのが安全な方法です。)この関数が使用されるケースとしては、画像特徴点ベースの自己位置推定値の積算誤差をリセットし、あるランドマークを原点とした画像座標系を再定義したい場合を想定しています。

# 画像、画像特徴点
### phenox.get_imgfullwcheck(cam, img)
`pxget_imgfullwcheck(px_cameraid cam, IplImage **img)`のラッパー関数ですが、現在実装されておらず、何も行わない関数となっています。これはOpenCVのC/C++向けAPIで提供されているIplImage型とPythonの画像表現となるnumpy.ndarray型の変換が技術的に難しいことが理由です。

### phenox.set_img_seq(cam)
`pxset_img_seq(px_cameraid cam)`のラッパー関数です。
`pxget_imgfullwcheck()`関数で画像を取得するための前処理を行います。引数には前面カメラを表す`phenox.PX_FRONT_CAM`または下方カメラを表す`phenox.PX_BOTTOM_CAM`を指定します。この関数によって、指定したカメラの画像をメモリ領域にコピーする処理がFPGAへ指示されます。この処理を定期的に呼び出しておくことで`phenox.get_imgfullwcheck`関数の結果として最新の画像が得られるようになります。画像取得処理を行う場合、タイマーなどを用いて本関数を周期的に呼び出して下さい。

### phenox.set_imgfeature_query(cam)
`pxset_imgfeature_query(px_cameraid cam)`
引数camで指定したカメラから得られた画像特徴点を、Linux から取得するための要求を、飛行制御システムに発行します。引数には`phenox.PX_FRONT_CAM`または`phenox.PX_BOTTOM_CAM`を指定してください。この関数は成功すると1を返します。一度要求を発行すると、飛行制御システム内で処理が終了するまで-1を返します。

### phenox.get_imgfeature(maxnum, ft=None)
`pxget_imgfeature(px_imgfeature *ft,int maxnum)`のラッパー関数です。
`phenox.set_imgfeature_query`関数によって発行された画像特徴点取得要求の結果を取得します。正常に終了した場合は、引数`ft`に特徴点の座標情報が書き込まれ、発見された特徴点の個数を返し、処理が完了していない場合は-1を返します。引数`maxnum`には想定する特徴点の最大個数を指定します。

この関数は第二引数`ft`によって挙動を変化させます。`ft`が`phenox.ImageFeature`型変数である場合、特徴点情報は`ft`に書き込まれ、戻り値は特徴点の個数となります。それ以外の場合、`maxnum`の値をもとに`phenox.ImageFeature`の配列に相当するインスタンスが生成されて、特徴点の個数とともに戻り値が返されます。

```Python
featurePointNumber, features = phenox.get_imgfeature(100)
```

######TODO: この関数は動作確認が不十分です。特に`ft`に`ImageFeature`型変数を代入した場合、挙動が不安定になる可能性があることに注意してください。

### phenox.set_blobmark_query(cameraId, min_y, max_y, min_u, max_u, min_v, max_v)
`pxset_blobmark_query(px_cameraid cam, float min_y, float max_y, float min_u,float max_u, float min_v, float max_v)`のラッパー関数です。
引数`cam`で指定したカメラから得られた画像に対して、YUV 色空間内で指定された範囲の色のピクセル総数と重心を求める処理の要求を飛行制御システムに発行します。`cam`引数には前面カメラを表す`phenox.PX_FRONT_CAM`または下方カメラを表す`phenox.PX_BOTTOM_CAM`を指定します。Y の範囲は `min_y` から `max_y` の範囲、U の範囲は `min_u` から `max_u` の範囲、V の範囲は `min_v` から `max_v` の範囲で指定 します。この関数が成功すると、1 を返します。一度要求を発行すると、飛行制御システム内で処理 が終了するまで-1 を返します。

### phenox.get_blobmark()
`pxget_blobmark(float *x,float *y, float *size)`のラッパー関数です。
`pxset_blobmark_query()` 関数によって発行された、YUV 色空間内で指定された範囲の色のピクセ ル総数と重心を求める要求が、飛行制御システムによって処理され、完了されたかどうかを調べます。
戻り値は4つの値からなるタプルとなっています。第一引数には関数処理が成功したかどうかを表すフラグが格納されており、成功した場合は1、失敗した場合は-1が入ります。タプルの第二、第三、第四要素はそれぞれ色ピクセルの重心位置`x`, `y`およびピクセル総数`size`が書き込まれています。

# 音声
### phenox.get_whistle_is_detected()
`pxget_whisle_detect()`のラッパー関数です。3kHzの音を検出し、音が検出された場合は`True`、そうでない場合は`False`を返します。`PhenoxConfig`の`whistleborder`変数を書き換えることで感度を調整できます。

### reset_whistle_is_detected()
`pxset_whisle_detect_reset()`のラッパー関数です。`phenox.get_whistle_is_detected()`で取得しているフラグは本関数の呼び出しによって下げられます(本関数を呼び出さない場合、一度検出された音によって常に`phenox.get_whistle_is_detected`関数の戻り値が`True`になります)。本関数を用いて音検出のフラグを下げ直すことにより、再び音の検出が可能となります。

### phenox.set_sound_recordquery(recordtime)
`pxset_sound_recordquery()`のラッパー関数です。マイクで録音された音声を取得するための要求を飛行制御システムに発行します。

######TODO: 引数の表記が実際のpxlib.hと食い違っています。

### phenox.get_sound_recordstate()
`pxget_sound_recordstate()`のラッパー関数です。`pxset_sound_recordquery()`関数によって発行された音声取得の要求が飛行制御システムによって処理され、完了したかどうかを調べます。処理中の場合は-1を返し、完了した場合は1を返します。

### phenox.get_sound(recordtime)
`pxget_sound(short *buffer, float recordtime)`のラッパー関数です。
引数`recordtime`で指定した時間長さの音声信号を整数値のリストとして返します。音声信号はサンプリングレート10kHz、量子化ビット数16bit(C言語の`short`型相当)、モノラルチャネルの波形データとして表現されています。この関数は`phenox.get_sound_recordstate`関数を使って飛行制御システムによる音声処理が完了したことを確認の上で実行してください。

# デバッグ
### phenox.set_led(led, led_on)
`pxset_led(int led, int state)`のラッパー関数です。Phenox2に搭載されたLEDを点灯あるいは消灯します。第一引数ledには0あるいは1を指定します。0はPhenox2上面の赤色LEDに対応し、1はPhenox2上面の緑色LEDに対応します。第二引数`state`には`bool`値を与えます。`True`を指定するとLEDが点灯し、`False`を指定するとLEDを消灯します。

### phenox.set_buzzer(state)
`pxset_buzzer(int state)`のラッパー関数です。
引数stateを`True`とするとブザーを鳴らし、`False`とするとブザーを停止します。

### phenox.set_systemlog()
`pxset_systemlog()`のラッパー関数です。
飛行制御システムによるログを`systemlog.txt`に書き出します。この関数はタイマ割り込み関数などを用いて周期的に呼び出すようにして下さい
。


# クラス定義について

### phenox.PhenoxConfigクラス
C言語版APIの`px_pconfig`構造体に相当するクラスです。メンバ変数等は[パラメータ一覧](./param)に準拠します。

### phenox.SelfStateクラス
C言語版APIの`px_selfstate`構造体に相当するクラスです。メンバ変数等は[状態量一覧](./state)に準拠します。

### phenox.ImageFeatureクラス
C言語版APIの`px_imgfeature`構造体に相当するクラスです。メンバ変数は下記の通りです。

 - pcx(float)
 - pcy(float)
 - cx(float)
 - cy(float)
 
