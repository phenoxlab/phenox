ここで紹介する関数の使用例は、チュートリアルを参照してください。
# 基本関数、状態取得関数
### void pxinit_chain()    
飛行制御システム (CPU1) を起動し、パラメータの初期化を行います。
### int pxget_cpu1ready()
`pxinit chain()` 実行後、飛行制御システム (CPU1) の準備ができた場合は 1 を返し、それ以外では 0 を返します。飛行制御システムの準備が完了してから 3 秒後にジャイロセンサのキャリブレーションが実行されるため、キャリブレーションの終了までは機体を必ず静止させ、Phenox2 を手で掴まないで下さい。

### pxget_motorstatus()
モーターが回転状態(上昇状態、ホバー状態、下降状態)のときは 1 を返し、それ以外では 0 を返し ます。

### void pxget_pconfig(px_pconfig *param)
現在の機体のパラメータの一覧 (`px_pconfig`) をローカル変数 `param` に格納します。

### void pxset_pconfig(px_pconfig *param)
ローカル変数 `param` に格納されたパラメータの一覧を、飛行制御システムに反映します。パラメーターの一部を書き換える場合は、一度 `pxget_pconfig()` 関数を実行することで変数 `param` の一覧を取 得してから、目的の変数を変更し、`pxset_pconfig()` 関数で設定を反映して下さい。

### void pxget_selfstate(px_selfstate *state)
機体の状態の一覧 (`px_selfstate` 構造体を参照) を取得します。

### void pxset_keepalive()
機体制御システム(CPU1)に対して、Linux(CPU0) が phenox ライブラリを使用したアプリケーションを実行中であることを伝えます。この関数は、ユーザー自身がタイマー割り込み関数などを用いて定期的に呼び出すようにしてください。

### int pxget_battery()
バッテリの残量状態を取得します。バッテリの残量が残り少ない状態では 1 を返し、それ以外では 0 を返します。この値が 1 になった場合は、飛行制御システムによって自動的に、ホバー状態 (`PX_HOVER`) の Phenox は下降状態 (`PX_DOWN `) に遷移し、`px_pconfig` 構造体の `downtime_max` で指定した時間 (秒)が経過した後、停止状態 (`PX_HALT`) に遷移します。ユーザー側では、`shutdown` コマンドなどを用いて Linux システムをシャットダウンしてください。

# 基本関数、状態取得関数
### px_flymode pxget_operate_mode()
飛行状態を取得します。`px_flymode` 型は 4 種類の状態 (`PX_HALT`, `PX_UP`, `PX_HOVER`, `PX_DOWN`) があり、それぞれ停止状態、上昇状態、ホバー状態、下降状態を表します。

### void pxset_operate_mode(`px_flymode` mode)
飛行状態を設定します。`px_flymode` 型は 4 種類の状態 (`PX_HALT`, `PX_UP`, `PX_HOVER`, `PX_DOWN`) があり、それぞれ停止状態、上昇状態、ホバー状態、下降状態を表します。
`PX_UP`, `PX_DOWN` に設定した場合は、`px_pconfig` 構造体の `uptime_max`, `downtime_max` で指定した時間 (秒)が経過すると、飛行制御システムによって自動的にそれぞれホバー状態、停止状 態に遷移します。また、`PX_HALT` 状態から他の状態へ遷移する場合には、3 秒間の始動状態(プロペラの弱い回転運動状態)が飛行制御システム(CPU1)によって挿入されます。

### void pxset_visioncontrol_xy(float tx, float ty)
水平方向 (機体軸 X,Y)における現在の自己位置(`px_selfstate` 構造体の `vision_tx`, `vision_ty`)を基準とした目標位置を設定し、飛行状態の場合 (`pxget_operate_mode() == PX_HOVER`) は Phenox2 を水平方向に動かし、目標位置に追従させます。

飛行制御プ ログラム (CPU1) は、`px_pconfig` 構造体の `pgain_vision_tx`, `pgain_vision_ty`(Pゲイン) と `dgain_vision_tx`, `dgain_vision_ty` (Dゲイン) で指定した強度に応じて、目標位置(tx,ty)に追従しようと試みます。そのため、現在の自己位置に対して、大きく離れた値を目標位置に設定するほど、強く追従しようと試みます。

この制御に積分項は含まれておらず、多少のバイアスが残るため、必要に応じてユー ザー自身で積分項を入れるか、一度目標位置からバイアス相当だけずれた状態でのホバー状態を実行し、静止した位置を基準とした相対位置を目標に設定する必要があります。

また、自己位置は画像座標系で表現されるため、移動量は地面からの距離に反比例します。そのため、必要に応じて高度情報 (`px_selfstate` 構造体の `height` 変数) を加味したゲイン設定を行って下さい。

実際の使用例として、チュートリアルの[Phenox を飛行中に移動させる](../tut/controll_move.md)を参照してください。

### void pxset_rangecontrol z(float tz)
高度方向 (機体軸 Z) の目標自己位置を設定し、飛行状態 (`pxget_operate_mode() == PX_HOVER`) の場合は Phenox2 を追従させます。水平方向の移動量は下向きカメラを用いることに対して、高度 方向の制御は超音波センサを用いているため、機体軸 XY と Z との間で異なる関数となっています。 `tz` の単位は大体センチメートルで、指定する値は 130 ∼ 180 の範囲をお勧めします。飛行制御プログラム (CPU1) は、`px_pconfig` 構造体の `pgain_sonar_tz`,(比例ゲイン) と `dgain_sonar_tz`(微分ゲイン) で指定した強度に応じて、目標位置に追従しようと試みます。なお、この制御に積分項は含まれて おらず、積載重量とパラメータ (`px_pconfig` 構造体の `duty_hover` 変数) によっては大きなバイアス が残るため、必要に応じてユーザー自身で積分項を入れるか、高度情報を元にバイアス (`px_pconfig` 構造体の `duty_hover` 変数) を補正するなどの試みを行って下さい。

### void pxset_dst_degx(float val)
Phenox2 の `degx` (機体軸 X に対する右ネジ向きの回転角度) の目標値を 180 度数単位で設定し、飛行状態 (`pxget_operate_mode() == PX_HOVER`) の場合は Phenox2 を追従させます。本関数は、引数valを目標角度とし、`px_pconfig` 構造体の`pgain_degx`,`dgain_degx`をそれぞれPDゲインとした、PD制御となっています。

本関数を実行すると、画像特徴点ベースの追従制御である`pxset_visioncontrol_xy()`関数が無効化されます。同様に、`pxset_visioncontrol_xy()`関数を実行することで、本関数も無効化されます。

実際の使用例として、チュートリアルの[Phenox をコントローラで操縦する](../tut/controll_manual.md)を参照してください。

### void pxset_dst_degy(float val)
Phenox2 の `degy` (機体軸 Y に対する右ネジ向きの回転角度) の目標値を 180 度数単位で設定し、飛行状態 (`pxget_operate_mode() == PX_HOVER`) の場合は Phenox2 を追従させます。本関数は、引数valを目標角度とし、`px_pconfig` 構造体の`pgain_degy`,`dgain_degy`をそれぞれPDゲインとした、PD制御となっています。

本関数を実行すると、画像特徴点ベースの追従制御である`pxset_visioncontrol_xy()`関数が無効化されます。同様に、`pxset_visioncontrol_xy()`関数を実行することで、本関数も無効化されます。

実際の使用例として、チュートリアルの[Phenox をコントローラで操縦する](../tut/controll_manual.md)を参照してください。

### void pxset_dst_degz(float val)
Phenox2 の `degx`(機体軸 Z に対する右ネジ向きの回転角度) の目標値を 180 度数単位で設定し、飛 行状態 (`pxget_operate_mode() == PX_HOVER`) の場合は Phenox2 を追従させます。引数は、上昇開始時 の Z 角度に対する相対角度として与えられ、回転させたい角度への変化量を指定してください (上昇開始時におけるPhenox2が向いている方向から半時計回りに 10.5 度回転させたい場合は, `val = 10.5`, 時計回りに 10.5 度回転させたい場合は, `val = -10.5`)。

### int pxset_visualselfposition(float tx,float ty)
`px_selfstate` 構造体の `vision_tx`, `vision_ty` を引数に指定した `tx`, `ty` の値に修正します。従って、本関 数の実行によって `pxset_visioncontrol_xy` 関数の実行結果が影響を受けます (そのため、`pxset_visioncontrol_xy` 関数の引数 `tx`, `ty` には、`px_selfstate` 構造体の `vision_tx`, `vision_ty` に、移動したい相対位置を足した量を指定することをお勧めします)。この関数が使用されるケースとして、画像特徴点ベースの自己位置推定値の積算誤差をリセットし、あるランドマークを原点とした画像座標系を再び定義したい場合を想定しています。

実際の使用例として、チュートリアルの[Phenox を飛行中に色マーカーに追従させる](../tut/controll_color.md)を参照してください。

# 画像、画像特徴点
### int pxget_imgfullwcheck(px_cameraid cam, IplImage **img)
引数 `cam` で指定したカメラから得られた画像を `img` に保存します。`cam` は `px_cameraid` 型の構造 体 (`px_FRONT_CAM`, `px_BOTTOM_CAM`) で、正面カメラ、あるいは下面カメラを指定します。 `img` は `OpenCV` で定義された構造体である `IplImage` 型で、あらかじめ `cvCreateImage` 関数などで 初期化しておきます。画像サイズは QVGA(320x240) で固定で、1 秒間に 30 フレームの取得が可能 です。なお、この関数を使用する際には、`pxset_img_seq()` 関数をタイマ割り込み関数などを用いて 周期的に呼び出す必要があります。

### void pxset_img_seq(px_cameraid cam)
`pxget_imgfullwcheck()` 関数で画像を取得するための、前処理を行います。この前処理は、FPGA に よって書き込まれた画像情報をメモリから読み出し、YUV422規格からRGB規格へと画素値を変換した上で、さらに別のプライベートなメモリ領域にコピーする処理となっており、この処 理を定期的に行うことによって、画像を読み出したいタイミングで常に最新の画像を取得すること ができます。この関数はタイマ割り込み関数などを用いて周期的に呼び出すようにして下さい。

### int pxset_imgfeature_query(px_cameraid cam)
引数 cam で指定したカメラから得られた画像特徴点を、Linux から取得するための要求を、飛行制 御システムに発行します。この関数が成功すると、1 を返します。一度要求を発行すると、飛行制御 システム内で処理が終了するまで-1 を返します。

### int pxget_imgfeature(px_imgfeature *ft,int maxnum)
pxset_imgfeature query() 関数によって発行された画像特徴点取得要求が、飛行制御システムによっ て処理され、完了されたかどうかを調べます。正常に終了した場合は、引数 `ft` に特徴点の座標情報 が書き込まれ、発見された特徴点の個数を返し、処理中がまだ完了していない場合は-1 を返します。 引数 `maxnum` には `ft` のサイズを指定します。

### int pxset_blobmark_query(px_cameraid cam, float min_y, float max_y, float min_u,float max_u, float min_v, float max_v)
引数 `cam` で指定したカメラから得られた画像に対して、YUV 色空間内で指定された範囲の色のピクセル総数と重心を求める処理の要求を飛行制御システムに発行します。Y の範囲は `min_y` から `max_y` の範囲、U の範囲は `min_u` から `max_u` の範囲、V の範囲は `min_v` から `max_v` の範囲で指定 します。この関数が成功すると、1 を返します。一度要求を発行すると、飛行制御システム内で処理 が終了するまで-1 を返します。

実際の使用例として、チュートリアルの[Phenox を飛行中に色マーカーに追従させる](../tut/controll_color.md)を参照してください。

### int pxget_blobmark(float *x,float *y, float *size)
`pxset_blobmark_query()` 関数によって発行された、YUV 色空間内で指定された範囲の色のピクセ ル総数と重心を求める要求が、飛行制御システムによって処理され、完了されたかどうかを調べます。正常に終了した場合は、引数 `x`, `y` に重心位置、引数 `size` にピクセル総数が書き込まれ、1 を返し ます。処理中がまだ完了していない場合は-1 を返します。

実際の使用例として、チュートリアルの[Phenox を飛行中に色マーカーに追従させる](../tut/controll_color.md)を参照してください。

# 音声
### int pxget_whisle_detect()
3kHz の音を検出します。3kHz の音が検出された場合は 1 を返し、それ以外では 0 を返しま す。`px_pconfig` 構造体の `whisleborder` 変数を書き換えることで、感度を調整することができま す。 

### void pxset_whisle_detect_reset()
3kHz の音の検出する関数である `pxget_whisle detect()` には、過去に検出された状態が残り続ける ため、本関数を使用することで、一度検出状態を解除することができます。

### int pxset_sound_recordquery(float recordtime)
recordrimeで指定した秒間、マイクで録音を行うための要求を飛行制御システムに発行します。音声信号は 10kHz のサンプリングレート, 16bit の `short` 型, Raw データで表現されています。

### int pxget_sound_recordstate()
`pxset_sound_recordquery()` 関数によって発行された、音声を取得するための要求が飛行制御システムによって処理され、完了したかどうかを調べます。処理中の場合は -1 を返し、完了した場合は 1 を返します。

### int pxget_sound(short *buffer, float recordtime)
引数 `buffer` に、引数 `recordtime` で指定した時間長さの音声信号を書き込みます。音声信号は 10kHz のサンプリングレート, 16bit の `short` 型, Raw データで表現されています。この関数は `pxget sound recordstate()` 関数を使って、飛行制御システムによる音声処理が完了したことを確認 の上、実行してください。引数recordtimeは、本関数を実行するまえに実行した`pxset_sound_recordquery(float recordtime)`関数の引数recordtimeと同一か、それ以下の値を指定します。

実際の使用例として、チュートリアルの[画像、音声を取得する](../tut/build.md)を参照してください。

# デバッグ
### void pxset_led(int led, int state)
引数 led(0 あるいは 1) で指定した LED を点灯させます。引数 `state` に 1 を書き込むことで LED を 点灯させ、0 を書き込むことで LED を消灯させることができます。

### void pxset_buzzer(int state)
引数 state に 1 を書き込むことで、ブザーを鳴らし、に 0 を書き込むことで、ブザーを止めることが できます。なお、ブザーの周波数は 4kHz となります。

### void pxset_systemlog()
飛行制御システムによるログを `systemlog.txt` に書き出します。この関数はタイマ割り込み関数などを用いて周期的に呼び出すようにして下さい。
