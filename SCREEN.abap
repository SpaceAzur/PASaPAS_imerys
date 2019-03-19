*&---------------------------------------------------------------------*
*&  Include           ZREPORT_FI_SCREEN
*&---------------------------------------------------------------------*


*& Ecran de sélection
SELECTION-SCREEN BEGIN OF BLOCK b1
                WITH FRAME TITLE text-t01.

PARAMETERS :        p_bukrs   LIKE  bkpf-bukrs  OBLIGATORY,
                    p_gjahr   LIKE  bkpf-gjahr  OBLIGATORY,
                    p_monat   LIKE  bkpf-monat  OBLIGATORY,
                    p_blart   LIKE  bkpf-blart,
                    p_usnam   LIKE  bkpf-usnam,
                    bypiece   RADIOBUTTON GROUP choi,
                    byusers   RADIOBUTTON GROUP choi.

select-options :    so_bldat  FOR   bkpf-bldat,
                    so_budat  FOR   bkpf-budat.

SELECTION-SCREEN END OF BLOCK b1.