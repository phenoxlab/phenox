# Phenox2 の方向と機体軸
Phenox を開発する際には、機体の軸を把握する必要があります。機体の軸は機体左方から右側に向けて x 軸、後方から前方に向けて y 軸、そして、下面から上面に向けてが z 軸です。以下に軸の方向を示します。

![写真 2 Phenox の機体軸と方向](/img/phenox/phenox_principle_axis.jpg)
<div align="center">写真 2 Phenox の機体軸と方向</div>
###### TODO: ↓わかりにくい
回転方向は 右ネジの向きとなります。

###### TODO: ↓ degx, degy, degz どれ？以上の定義は、Phenox ライブラリに登場する、front, back, left, right といったワード、degx, degy, degz といったワードに対応します。

# プロペラの回転方向
Phenox には４つのプロペラがついており、機体の前後左右についているものをそれぞれ Front Rotor, Back Rotor, Left Rotor, Right Rotor と呼びます。このうち、Front Rotor と Back Rotor は機体を上から見たときに時計回り、Left Rotor と Right Rotor は反時計周りに回転します。プロペラの交換は回転方向を確認の上で行って下さい。
###### TODO: 写真を入れる。
