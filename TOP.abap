
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
TABLES : bkpf, usr02.
*&---------------------------------------------------------------------*
*& TYPES
*&---------------------------------------------------------------------*

*----type-pool pour affichage de l'ALV
TYPE-POOLS slis.

*----Type pour extraction des données de la table bkpf
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

*----type pour stocker les pièces comptables par type
TYPES : BEGIN OF ty_bypiece,
              blart TYPE bkpf-blart,
              ltext TYPE t003t-ltext,
              gjahr TYPE bkpf-gjahr,
              monat TYPE bkpf-monat,
              count TYPE i,
        END OF ty_bypiece,

        BEGIN OF ty_bypiece2,
              blart   TYPE bkpf-blart,
              ltext   TYPE t003t-ltext,
              count1  TYPE i,
              count2  TYPE i,
              count3  TYPE i,
              count4  TYPE i,
              count5  TYPE i,
              count6  TYPE i,
              count7  TYPE i,
              count8  TYPE i,
              count9  TYPE i,
              count10 TYPE i,
              count11 TYPE i,
              count12 TYPE i,
        END OF ty_bypiece2,

        BEGIN OF ty_mark,
              monat   TYPE char02,
        END OF ty_mark.

*----type pour stocker les pièces comptables par utilisateur
TYPES : BEGIN OF ty_byuser,
              usnam TYPE bkpf-usnam,
              gjahr TYPE bkpf-gjahr,
              monat TYPE bkpf-monat,
              count TYPE i,
        END OF ty_byuser,

        BEGIN OF ty_byuser2,
              usnam TYPE bkpf-usnam,
              count1  TYPE i,
              count2  TYPE i,
              count3  TYPE i,
              count4  TYPE i,
              count5  TYPE i,
              count6  TYPE i,
              count7  TYPE i,
              count8  TYPE i,
              count9  TYPE i,
              count10 TYPE i,
              count11 TYPE i,
              count12 TYPE i,
        END OF ty_byuser2.

*----type pour récupérer les descritpion de type de pièce
TYPES : BEGIN OF ty_dpiece,
              blart TYPE t003t-blart,
              ltext TYPE t003t-ltext,
        END OF ty_dpiece.

*----type pour afficher ALV
TYPES: BEGIN OF slis_print_alv.
        INCLUDE TYPE alv_s_prnt.
        INCLUDE TYPE slis_print_alv1.
TYPES: END OF slis_print_alv.

*&---------------------------------------------------------------------*
*& DATA
*&---------------------------------------------------------------------*

*----Structure & Variable pour affichage ALV
DATA :      gs_fieldcat TYPE slis_fieldcat_alv,
            ls_layout   TYPE slis_layout_alv,
            l_repid     LIKE sy-repid.

*----Structure et table interne pour l'extraction des données
DATA :      gt_compta   TYPE TABLE OF ty_compta,
            gs_compta   TYPE  ty_compta.

*----Structure et table interne par type de pièce
DATA :      gt_bypiece  TYPE TABLE OF ty_bypiece,
            gs_bypiece  TYPE ty_bypiece,
            gt_bypiece2 TYPE TABLE OF ty_bypiece2,
            gs_bypiece2 TYPE ty_bypiece2.

*----Structure et table interne par utilisateur
DATA:       gt_byuser   TYPE TABLE OF ty_byuser,
            gs_byuser   TYPE ty_byuser,
            gt_byuser2  TYPE TABLE OF ty_byuser2,
            gs_byuser2  TYPE ty_byuser2.

*----Structure et table interne pour la description des types de pièce
"+Variables pour affichage ALV
DATA:       gt_dpiece   TYPE TABLE OF ty_dpiece,
            gs_dpiece   TYPE ty_dpiece,
            gt_fieldcat TYPE slis_t_fieldcat_alv,
            gs_print    TYPE slis_print_alv,
            gs_mark     TYPE ty_mark,
            gt_mark     TYPE TABLE OF ty_mark.

FIELD-SYMBOLS:
            <fcat>      TYPE lvc_s_fcat.