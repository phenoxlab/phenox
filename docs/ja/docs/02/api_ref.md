ここで紹介する関数の使用例は、チュートリアルを参照してください。
# 基本関数、状態取得関数
## void pxinit chain()
飛行制御システム (CPU1) を起動し、パラメータの初期化を行います。

## int pxget cpu1ready()
`pxinit chain()` 実行後、飛行制御システム (CPU1) の準備ができた場合は 1 を返し、それ以外では 0 を返します。飛行制御システムの準備が完了してから 3 秒後にジャイロセンサのキャリブレーショ ンが実行されるため、キャリブレーションの終了までは機体を必ず静止させ、Phenox2 を手で掴ま ないで下さい。

## pxget motorstatus()
モーターが回転状態(上昇状態、ホバー状態、下降状態)のときは 1 を返し、それ以外では 0 を返し ます。

## void pxget pconfig(px_pconfig *param)
現在の機体のパラメータの一覧 (`px_pconfig`) をローカル変数 `param` に格納します。

## void pxset pconfig(px_pconfig *param)
ローカル変数 `param` に格納されたパラメータの一覧を、飛行制御システムに反映します。パラメーターの一部を書き換える場合は、一度 `pxget pconfig()` 関数を実行することで変数 `param` の一覧を取 得してから、目的の変数を変更し、`pxset_pconfig()` 関数で設定を反映して下さい。

## void pxget selfstate(px selfstate *state)
機体の状態の一覧 (`px selfstate` 構造体を参照) を取得します。

## void pxset keepalive()
機体制御システムに対して、Linux(CPU0) が phenox ライブラリを使用したアプリケーションを実行中であることを伝えます。この関数は、ユーザー自身がタイマー割り込み関数などを用いて定期的に呼び出すようにしてください。

## int pxget battery()
バッテリの残量状態を取得します。バッテリの残量が残り少ない状態では 1 を返し、それ以外では 0 を返します。この値が 1 になった場合は、飛行制御システムによって自動的に、ホバー状態 (PX HOVER) の Phenox は下降状態 (PX DOWN) に遷移し、px pconfig 構造体の downtime max で指定した時間 (秒)が経過した後、停止状態 (PX HALT) に遷移します。ユーザー側では、shutdown コマンドなどを用いて Linux システムをシャットダウンしてください。

# 基本関数、状態取得関数
## px flymode pxget operate mode()
飛行状態を取得します。px flymode 型は 4 種類の状態 (PX HALT,PX UP,PX HOVER,PX DOWN) があり、それぞれ停止状態、上昇状態、ホバー状態、下降状態を表します。

## void pxset operate mode(px flymode mode)
飛行状態を設定します。px flymode 構造体は 4 種類の状態 (PX HALT,PX UP,PX HOVER,PX DOWN) が定義されており、それぞれ停止状態、上昇状態、ホバー状態、下降状態を表します。
PX UP,PX DOWN に設定した場合は、px pconfig 構造体の uptime max,downtime max で 指定した時間 (秒)が経過すると、飛行制御システムによって自動的にそれぞれホバー状態、停止状 態に遷移します。また、PX HALT 状態から他の状態へ遷移する場合には、3 秒間の始動状態(プ ロペラの弱い回転運動状態)が飛行制御システムによって挿入されます。

## void pxset visioncontrol xy(float tx,float ty)
水平方向 (機体軸 X,Y) の目標自己位置を設定し、飛行状態の場合 (pxget operate mode() == PX HOVER) は Phenox2 を追従させます。引数 tx,ty には、現在の水平方向位置 (px selfstate 構造体の vision tx,vision ty) に、移動したい方向の小ベクトル (大きさ −120 ∼ 120 程 度) を足した量を指定することを強くお勧めします(チュートリアル参照)。飛行制御プ ログラム (CPU1) は、px pconfig 構造体の pgain vision tx,pgain vision ty(比例ゲイン) と dgain vision tx,dgain vision ty(微分ゲイン) で指定した強度に応じて、目標位置に追従しようと試 みます。なお、この制御に積分項は含まれておらず、多少のバイアスが残るため、必要に応じてユー ザー自身で積分項を入れるか、画像情報を元にバイアス (px pconfig 構造体の duty bias*変数) を補 正するなどの試みを行って下さい。また、座標系は画像座標系で表現されるため、移動量は地面か らの距離に反比例します。そのため、必要に応じて高度情報 (px selfstate 構造体の height 変数) を 加味したゲイン設定を行って下さい。

## void pxset rangecontrol z(float tz)
高度方向 (機体軸 Z) の目標自己位置を設定し、飛行状態 (pxget operate mode() == PX HOVER) の場合は Phenox2 を追従させます。水平方向の移動量は下向きカメラを用いることに対して、高度 方向の制御は超音波センサを用いているため、機体軸 XY と Z との間で異なる関数となっています。 tz の単位はセンチメートルで、指定する値は 100 ∼ 180 の範囲をお勧めします。飛行制御プログ ラム (CPU1) は、px pconfig 構造体の pgain sonar tz,(比例ゲイン) と dgain sonar tz(微分ゲイン) で指定した強度に応じて、目標位置に追従しようと試みます。なお、この制御に積分項は含まれて おらず、積載重量とパラメータ (px pconfig 構造体の duty hover 変数) によっては大きなバイアス が残るため、必要に応じてユーザー自身で積分項を入れるか、高度情報を元にバイアス (px pconfig 構造体の duty hover 変数) を補正するなどの試みを行って下さい。

## void pxset dst degx(float val)
Phenox2 の degx(機体軸 X に対する右ネジ向きの回転角度) の目標値を 180 度数単位で設定し、飛 行状態 (pxget operate mode() == PX HOVER) の場合は Phenox2 を追従させます。この関数に は有効期間 (px pconfig 構造体の selxytime max) が秒単位で設定されており、本関数を最後に実行 してから設定時間以上が経過すると、飛行制御プログラムによって自動的に、下向きカメラの画像 特徴点を元に推定した自己制御制御 (pxset visioncontrol xy()) が行われ、現在の位置に留まろうと する制御が行われます。従って、常に指定した角度に Phenox2 を制御させたい場合はタイマ割り込 み関数などを用いて、周期的に本関数を呼び出す必要があります。大きな値を指定するほど急な移 動につながりますので、指定する値としては 0 ∼ 10.0 を目安としてください。

## void pxset dst degy(float val)
Phenox2 の degx(機体軸 Y に対する右ネジ向きの回転角度) の目標値を 180 度数単位で設定し、飛 行状態 (pxget operate mode() == PX HOVER) の場合は Phenox2 を追従させます。この関数に は有効期間 (px pconfig 構造体の selxytime max) が秒単位で設定されており、本関数を最後に実行 してから設定時間以上が経過すると、飛行制御プログラムによって自動的に、下向きカメラの画像 特徴点を元に推定した自己制御制御 (pxset visioncontrol xy()) が行われ、現在の位置に留まろうと する制御が行われます。従って、常に指定した角度に Phenox2 を制御させたい場合はタイマ割り込 み関数などを用いて、周期的に本関数を呼び出す必要があります。大きな値を指定するほど急な移 動につながりますので、指定する値としては 0 ∼ 10.0 を目安としてください。

## void pxset dst degy(float val)
Phenox2 の degx(機体軸 Z に対する右ネジ向きの回転角度) の目標値を 180 度数単位で設定し、飛 行状態 (pxget operate mode() == PX HOVER) の場合は Phenox2 を追従させます。引数は現在 の Z 角度に対する相対角度として与えられるため、現在 Phenox2 が向いている角度から、回転させ たい角度への変化量を指定してください (今の向きから半時計回りに 10.5 度回転させたい場合は,val = 10.5, 今の向きから時計回りに 10.5 度回転させたい場合は,val = -10.5)。本関数は、XY 軸の回転 角度制御関数 (pxset dst degx,pxset dst degy) とは異なり、時間の経過による影響を受けません。

## int pxset visualselfposition(float tx,float ty)
px selfstate 構造体の vision tx,vision ty を引数に指定した tx,ty の値に修正します。従って、本関 数の実行によって pxset visioncontrol xy 関数が影響を受けます (そのため、pxset visioncontrol xy 関数の引数 tx,ty には、px selfstate 構造体の vision tx,vision ty に、移動したい相対位置を足した 量を指定することをお勧めします)。この関数が使用されるケースとして、画像特徴点ベースの自己 位置推定値の積算誤差をリセットし、あるランドマークを原点とした画像座標系を再び定義したい 場合を想定しています。

# 画像、画像特徴点
## int pxget imgfullwcheck(px cameraid cam,IplImage **img)
引数 cam で指定したカメラから得られた画像を img に保存します。cam は px cameraid 型の構造 体 (PX FRONT CAM,PX BOTTOM CAM) で、正面カメラ、あるいは下面カメラを指定します。 img は OpenCV で定義された構造体である IplImage 型で、あらかじめ cvCreateImage 関数などで 初期化しておきます。画像サイズは QVGA(320x240) で固定で、1 秒間に 30 フレームの取得が可能 です。なお、この関数を使用する際には、pxset img seq() 関数をタイマ割り込み関数などを用いて 周期的に呼び出すようにして下さい。

## void pxset img seq(px cameraid cam)
pxget imgfullwcheck() 関数で画像を取得するための、前処理を行います。この前処理は、FPGA に よって書き込まれた画像情報を読み出し、別のメモリ領域にコピーする処理となっており、この処 理を定期的に行うことによって、画像を読み出したいタイミングで常に最新の画像を取得すること ができます。この関数はタイマ割り込み関数などを用いて周期的に呼び出すようにして下さい。

## int pxset imgfeature query(px cameraid cam)
引数 cam で指定したカメラから得られた画像特徴点を、Linux から取得するための要求を、飛行制 御システムに発行します。この関数が成功すると、1 を返します。一度要求を発行すると、飛行制御 システム内で処理が終了するまで-1 を返します。

## int pxget imgfeature(px imgfeature *ft,int maxnum)
pxset imgfeature query() 関数によって発行された画像特徴点取得要求が、飛行制御システムによっ て処理され、完了されたかどうかを調べます。正常に終了した場合は、引数 ft に特徴点の座標情報 が書き込まれ、発見された特徴点の個数を返し、処理中がまだ完了していない場合は-1 を返します。 引数 maxnum には ft のサイズを指定します。

## int pxset blobmark query(px cameraid cam,float min y,float max y,float min u,float max u,float min v,float max v)
引数 cam で指定したカメラから得られた画像に対して、YUV 色空間内で指定された範囲の色のピ クセル総数と重心を求める処理の要求を飛行制御システムに発行します。Y の範囲は min y から max yの範囲、Uの範囲はmin uからmax uの範囲、Vの範囲はmin vからmax vの範囲で指定 します。この関数が成功すると、1 を返します。一度要求を発行すると、飛行制御システム内で処理 が終了するまで-1 を返します。

## int pxget blobmark(float *x,float *y, float *size)
pxset blobmark query() 関数によって発行された、YUV 色空間内で指定された範囲の色のピクセ ル総数と重心を求める要求が、飛行制御システムによって処理され、完了されたかどうかを調べま す。正常に終了した場合は、引数 x,y に重心位置、引数 size にピクセル総数が書き込まれ、1 を返し ます。処理中がまだ完了していない場合は-1 を返します。

# 音声
## int pxget whisle detect()
3kHz の音を検出します。3kHz の音が検出された場合は 1 を返し、それ以外では 0 を返しま す。px pconfig 構造体の whisleborder 変数を書き換えることで、感度を調整することができま す。なお、この関数はブザーの音にも反応しますので、ブザーを使用後は、検出状態を解除する pxset whisle detect reset() 関数を使用するようにしてください。

## void pxset whisle detect reset()
3kHz の音の検出する関数である pxget whisle detect() には、過去に検出された状態が残り続ける ため、本関数を使用することで、一度検出状態を解除することができます。

## void pxset sound recordquery()
マイクで録音された音声を取得するための要求を飛行制御システムに発行します。

## int pxget sound recordstate()
pxset sound recordquery() 関数によって発行された、音声を取得するための要求が飛行制御システ ムによって処理され、完了したかどうかを調べます。処理中の場合は-1 を返し、完了した場合は 1 を返します。

## int pxget sound record(short *buffer, int size)
引数 buffer に、引数 size で指定した長さの音声信号を書き込みます。音声信号は 10kHz のサンプリングレート,16bit の short 型,Raw データで表現されています。この関数は pxget sound recordstate() 関数を使って、飛行制御システムによる音声処理が完了したこと を確認の上、実行してください。

# デバッグ
## void pxset led(int led,int state)
引数 led(0 あるいは 1) で指定した LED を点灯させます。引数 state に 1 を書き込むことで LED を 点灯させ、0 を書き込むことで LED を消灯させることができます。

## void pxset buzzer(int state)
引数 state に 1 を書き込むことで、ブザーを鳴らし、に 0 を書き込むことで、ブザーを止めることが できます。なお、ブザーの音は 3kHz に近いため、自身の音で pxget whisle detect() 関数が反応し ます。ブザーを鳴らした後は、pxset whisle detect reset() 関数を使うようにするなどの対策が必要 となります。

## void pxset systemlog()
飛行制御システムによるログを systemlog.txt に書き出します。この関数はタイマ割り込み関数な どを用いて周期的に呼び出すようにして下さい。

# パラメーター一覧
## float duty hover
ホバー状態 (PX HOVER) での、基本推力を表します。この基本推力に対して、pgain sonar tz,dgain sonar tz で指定したゲインに応じて高度制御が行われます。積載重量に応じて、1200 から 1400 程度の値が 目安です。

## float duty hover max
ホバー状態 (PX HOVER) での、最大推力を表します。duty hover+150 から duty hover+250 程 度の値が目安です。

