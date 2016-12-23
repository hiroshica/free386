;******************************************************************************
;　Ｆｒｅｅ３８６　＜マクロ部＞
;******************************************************************************
;
;
%imacro	PRINT	1
	mov	edx,%1
	mov	ah,09h
	int	21h
%endmacro

%imacro	PRINT_	1
	push	edx
	mov	edx,%1
	mov	ah,09h
	int	21h
	pop	edx
%endmacro


;******************************************************************************
;★F386 専用マクロ
;******************************************************************************
;------------------------------------------------------------------------------
;・キャリークリア & キャリーセット
;------------------------------------------------------------------------------
%imacro	set_cy	0	;Carry set
	or	b [esp+8], 01h	;Carry セット
%endmacro

%imacro	clear_cy 0	;Carry reset
	and	b [esp+8],0feh	;Carry クリア
%endmacro

save_cy:	;
cy_save:	;誤植防止措置
cy_set:		;
cy_clear:	;

;------------------------------------------------------------------------------
;・キャリーの状態をセーブして iretd するマクロ
;------------------------------------------------------------------------------
%imacro	iretd_save_cy	0	;Cy をセーブし iretd する
	jc	.__set_cy
	clear_cy
	iretd

	align	4
.__set_cy
	set_cy
	iretd
%endmacro

