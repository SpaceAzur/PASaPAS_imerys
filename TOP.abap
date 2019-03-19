
*&---------------------------------------------------------------------*
*& Include ZREPORT_FI_TOP                                    Pool mod.        Z_VOLUME_PIECE
*&
*&  PASàPAS-KPF / AESC
*&  Ticket : 66054
*&  OT     : DE1K904579
*&  ALV Report spécifique Pièce Comptable
*&
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& TABLES
*&---------------------------------------------------------------------*
TABLES : bkpf, t003t, usr03.
*&---------------------------------------------------------------------*
*& TYPES
*&---------------------------------------------------------------------*

TYPE-POOLS slis.

TYPES  : BEGIN OF ty_compta,
            bukrs    TYPE bkpf-bukrs,
            belnr    TYPE bkpf-belnr,
            blart    TYPE bkpf-blart,
            tcode    TYPE bkpf-tcode,
            bktxt    TYPE bkpf-bktxt,
            gjahr    TYPE bkpf-gjahr,
            monat    TYPE bkpf-monat,
            bldat    TYPE bkpf-bldat,
            usnam    TYPE bkpf-usnam,
            budat    TYPE bkpf-budat,
        END OF ty_compta.

TYPES : BEGIN OF ty_bypiece,
              blart TYPE bkpf-blart,
              ltext TYPE t003t-ltext,
              count TYPE i,
        END OF ty_bypiece.

TYPES : BEGIN OF ty_byuser,
              usnam TYPE bkpf-usnam,
              count TYPE i,
        END OF ty_byuser.

TYPES : BEGIN OF ty_dpiece,
              blart TYPE t003t-blart,
              ltext TYPE t003t-ltext,
        END OF ty_dpiece.

TYPES : BEGIN OF ty_duser,
              usnam TYPE bkpf-usnam,
              bname TYPE usr03-bname,
        END OF ty_duser.

TYPES: BEGIN OF slis_print_alv.
        INCLUDE TYPE alv_s_prnt.
        INCLUDE TYPE slis_print_alv1.
TYPES: END OF slis_print_alv.

*&---------------------------------------------------------------------*
*& DATA
*&---------------------------------------------------------------------*

DATA :      lt_fieldcat TYPE slis_t_fieldcat_alv,
            gs_fieldcat TYPE slis_fieldcat_alv,
            ls_layout   TYPE slis_layout_alv,
            l_repid     LIKE sy-repid.

DATA :      gt_compta   TYPE TABLE OF ty_compta,
            gs_compta   TYPE  ty_compta.

DATA :      gt_bypiece  TYPE TABLE OF ty_bypiece,
            gs_bypiece  TYPE ty_bypiece.

DATA:       gt_byuser   TYPE TABLE OF ty_byuser,
            lt_byuser   TYPE TABLE OF ty_byuser,
            gs_byuser   TYPE ty_byuser.

DATA:       gt_dpiece   TYPE TABLE OF ty_dpiece,
            gs_dpiece   TYPE ty_dpiece.

DATA:       gt_duser    TYPE TABLE OF ty_duser,
            gs_user     TYPE ty_duser,
            gt_fieldcat TYPE slis_t_fieldcat_alv,
            ls_variant  TYPE disvariant,
            ls_print    TYPE slis_print_alv.