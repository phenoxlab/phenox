# TODO: 機体構成のところに移す？

## Zynq
CPU0, CPU1, FPGA が 1 つのチップにまとまった Xilinx 社製の [SoC](https://ja.wikipedia.org/wiki/System-on-a-chip) で Phenox2 のメインチップとして使用しています。## CPU0
Linux が動いています。ユーザーが実際に使用することになる CPU リソース です。## CPU1
飛行制御システムが CPU0 とは独立に動いています。## FPGA 
画像、音声処理や、各種センサとの通信、アクチュエータの操作などを行っています。
