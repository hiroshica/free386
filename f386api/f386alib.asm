;******************************************************************************
;Free386 API作成用ライブラリ
;		'ABK project' all right reserved. Copyright (C)nabe@abk
;******************************************************************************
;
;　　2001/03/05　製作開始
;
;[TAB=8]

%include	"nasm_abk.h"	;NASM用ヘッダ

extrn		func_table	;ファンクションテーブルオフセット
public		my_ds		;データセグメント

F386API_INT	equ	9dh	;Free386 API 用 int


code	segment para public 'CODE' use32
;******************************************************************************
;■コード
;******************************************************************************
;------------------------------------------------------------------------------
;●Free386 API 初期化
;------------------------------------------------------------------------------
;int f386api_init();
;
proc	f386api_init
	push	eax
	push	ebx
	push	ecx
	push	edi

	push	ds

	mov	ax ,2504h			;割り込みベクタ設定
	mov	cl ,F386API_INT			;割り込み番号
	mov	edx,offset f386api_function	;
	push	cs
	pop	ds
	int	21h				;DOS-Extender call

	pop	ds

	;内部変数設定
	mov	[my_ds],ds			;ds 記憶

	pop	edi
	pop	ecx
	pop	ebx
	pop	eax
	ret

;------------------------------------------------------------------------------
;●Free386 API ジャンプ処理ルーチン
;------------------------------------------------------------------------------
proc	f386api_function
	push	eax			;

	movzx	eax,ah				;機能番号
	mov	eax,[cs:func_table + eax*4]	;ジャンプテーブル参照

	xchg	[esp],eax		;eax復元 & ジャンプ先記録
	ret				;テーブルジャンプ



;------------------------------------------------------------------------------
;●Free386 API 初期化 (C言語用)
;------------------------------------------------------------------------------
;int f386api_init_c();
;
proc	f386api_init_c
	push	eax
	push	ebx
	push	ecx
	push	edi
	push	ds

	mov	ax ,2504h			;割り込みベクタ設定
	mov	cl ,F386API_INT			;割り込み番号
	mov	ebx,offset f386api_function_c	;
	push	cs
	pop	ds
	int	21h				;DOS-Extender call

	pop	ds

	;内部変数設定
	mov	[my_ds],ds			;ds 記憶

	pop	edi
	pop	ecx
	pop	ebx
	pop	eax
	ret



;------------------------------------------------------------------------------
;●Free386 API ジャンプ処理ルーチン
;------------------------------------------------------------------------------
proc	f386api_function_c
	push	eax		;ebx, esi, edi, es 以外は
	push	ecx		; C ルーチンは保存しないので。
	push	edx		;
	push	fs		;
	push	gs		;

	push	eax
	movzx	eax,ah				;機能番号
	mov	eax,[cs:func_table + eax*4]	;ジャンプテーブル参照
	xchg	[esp],eax			;eax復元 & ジャンプ先記録

	call	[esp]			;ルーチンコール

	pop	eax		;呼び出し先読み捨て
	pop	gs		;
	pop	fs		;
	pop	edx		;レジスタ復元
	pop	ecx		;
	pop	eax		;
	iretd


;------------------------------------------------------------------------------
;●未知のファンクション
;------------------------------------------------------------------------------
	align	4
unknown_func:		;未知のファンクション
	xor	eax,eax		;eax = 0
	not	eax		;eax = -1
	set_cy			;Cy =1
	iretd


;------------------------------------------------------------------------------
;●Free386 API の初期化処理終了
;------------------------------------------------------------------------------
;int f386api_return();
;
proc	f386api_return
	mov	ah,11h		;API初期化の終了
	int	9ch		;Free386 functio

	mov	ah,4ch		;実際にはここに戻らない
	mov	al,0ffh
	int	21h


;------------------------------------------------------------------------------
;------------------------------------------------------------------------------



data	segment public 'DATA' use32
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
my_ds		dd	0		;このプログラムの ds


;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
	end
