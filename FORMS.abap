*&---------------------------------------------------------------------*
*&  Include           ZREPORT_FI_SELECT
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       Extraction des pièces comptables
*----------------------------------------------------------------------*
FORM get_data.

*----Récupèration des données comptables dans la table bkpf
  SELECT bukrs belnr blart tcode bktxt gjahr monat bldat usnam budat
                        INTO TABLE gt_compta
                        FROM bkpf
                        WHERE bukrs IN so_bukrs
                          AND gjahr =  p_gjahr
                          AND monat IN so_monat
                          AND bldat IN so_bldat
                          AND budat IN so_budat
                          AND blart IN so_blart
                          AND usnam IN so_usnam.

  IF sy-subrc IS NOT INITIAL.
    MESSAGE text-001 TYPE 'I' DISPLAY LIKE 'E'.
  ELSE.
    SORT gt_compta BY bukrs gjahr.
  ENDIF.

ENDFORM. "get_data

*&---------------------------------------------------------------------*
*&      Form  manage_data
*&---------------------------------------------------------------------*
*       Synthèse - Cumul des lignes par type de pièce comptable
*----------------------------------------------------------------------*

FORM manage_data_by_piece.

  CLEAR : gs_mark, gt_dpiece[], gt_bypiece[], gt_bypiece2[], gt_mark[].

* Récupération de la description des types de pièces comptable en t003t
  SELECT blart ltext  INTO TABLE gt_dpiece
                      FROM t003t
                      WHERE spras = sy-langu
                        AND blart IN so_blart.
  SORT gt_dpiece BY blart.
  DELETE ADJACENT DUPLICATES FROM gt_dpiece COMPARING blart.

*----Sélection pour le type de pièce demandé
  SORT gt_compta BY monat blart.
  LOOP AT gt_compta INTO gs_compta.
    CLEAR : gs_mark, gs_bypiece2.

    gs_bypiece2-blart = gs_compta-blart.
    CASE gs_compta-monat.
      WHEN '01'. gs_bypiece2-count1  = 1. gs_mark-monat = '1'.
      WHEN '02'. gs_bypiece2-count2  = 1. gs_mark-monat = '2'.
      WHEN '03'. gs_bypiece2-count3  = 1. gs_mark-monat = '3'.
      WHEN '04'. gs_bypiece2-count4  = 1. gs_mark-monat = '4'.
      WHEN '05'. gs_bypiece2-count5  = 1. gs_mark-monat = '5'.
      WHEN '06'. gs_bypiece2-count6  = 1. gs_mark-monat = '6'.
      WHEN '07'. gs_bypiece2-count7  = 1. gs_mark-monat = '7'.
      WHEN '08'. gs_bypiece2-count8  = 1. gs_mark-monat = '8'.
      WHEN '09'. gs_bypiece2-count9  = 1. gs_mark-monat = '9'.
      WHEN '10'. gs_bypiece2-count10 = 1. gs_mark-monat = '10'.
      WHEN '11'. gs_bypiece2-count11 = 1. gs_mark-monat = '11'.
      WHEN '12'. gs_bypiece2-count12 = 1. gs_mark-monat = '12'.
      WHEN OTHERS.
        gs_bypiece2-count12 = 1.  gs_mark-monat = '12'.
    ENDCASE.
    APPEND gs_mark TO gt_mark.

*   Ajout de la description du type de pièce comptable
    READ TABLE gt_dpiece INTO gs_dpiece WITH KEY blart = gs_bypiece2-blart BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      gs_bypiece2-ltext = gs_dpiece-ltext.
    ENDIF.
    COLLECT gs_bypiece2 INTO gt_bypiece2.
  ENDLOOP.

  SORT gt_mark.
  DELETE ADJACENT DUPLICATES FROM gt_mark.
  DELETE gt_mark WHERE monat IS INITIAL.

ENDFORM. "manage_data_by_piece

*&---------------------------------------------------------------------*
*&      Form  manage_date_by_user
*&---------------------------------------------------------------------*
*       Synthèse - Cumul des lignes par utilisateur
*----------------------------------------------------------------------*
FORM manage_data_by_user.

  CLEAR : gs_mark, gt_byuser2[], gt_mark[].


  SORT gt_compta BY usnam monat.
  LOOP AT gt_compta INTO gs_compta.
*    gs_byuser-usnam = gs_compta-usnam.
*    gs_byuser-gjahr = gs_compta-gjahr.
*    gs_byuser-monat = gs_compta-monat.
*    gs_byuser-count = 1.
*    COLLECT gs_byuser INTO gt_byuser.
*    CLEAR gs_byuser.
    CLEAR : gs_mark, gs_byuser2.

    gs_byuser2-usnam = gs_compta-usnam.
    CASE gs_compta-monat.
      WHEN '01'. gs_byuser2-count1  = 1. gs_mark-monat = '1'.
      WHEN '02'. gs_byuser2-count2  = 1. gs_mark-monat = '2'.
      WHEN '03'. gs_byuser2-count3  = 1. gs_mark-monat = '3'.
      WHEN '04'. gs_byuser2-count4  = 1. gs_mark-monat = '4'.
      WHEN '05'. gs_byuser2-count5  = 1. gs_mark-monat = '5'.
      WHEN '06'. gs_byuser2-count6  = 1. gs_mark-monat = '6'.
      WHEN '07'. gs_byuser2-count7  = 1. gs_mark-monat = '7'.
      WHEN '08'. gs_byuser2-count8  = 1. gs_mark-monat = '8'.
      WHEN '09'. gs_byuser2-count9  = 1. gs_mark-monat = '9'.
      WHEN '10'. gs_byuser2-count10 = 1. gs_mark-monat = '10'.
      WHEN '11'. gs_byuser2-count11 = 1. gs_mark-monat = '11'.
      WHEN '12'. gs_byuser2-count12 = 1. gs_mark-monat = '12'.
      WHEN OTHERS.
        gs_byuser2-count12 = 1.  gs_mark-monat = '12'.
    ENDCASE.
    APPEND gs_mark TO gt_mark.

    COLLECT gs_byuser2 INTO gt_byuser2.
  ENDLOOP.

  IF sy-subrc IS NOT INITIAL.
    MESSAGE text-005 TYPE 'E'.
  ENDIF.

ENDFORM.                    "manage_data_by_user

*&---------------------------------------------------------------------*
*&      Form  set_field
*&---------------------------------------------------------------------*
* Mise en form du FIELDCATALOG
*----------------------------------------------------------------------*
FORM set_field.
  DATA : l_string TYPE string.

  CONCATENATE p_gjahr <fcat>-fieldname+5 INTO l_string SEPARATED BY '-'.
  <fcat>-scrtext_s = <fcat>-scrtext_m = <fcat>-scrtext_l = <fcat>-coltext = l_string.
  <fcat>-do_sum = 'X'.

ENDFORM.                    "set_field

*&---------------------------------------------------------------------*
*&      Form  display_alv
*&---------------------------------------------------------------------*
* Affichage de l'ALV pour les 2 modes
*----------------------------------------------------------------------*
FORM display_alv.

  DATA  :   lo_alv                  TYPE REF TO cl_salv_table,
            lo_columns              TYPE REF TO cl_salv_columns_table,
            lo_column               TYPE REF TO cl_salv_column_table,
            lo_functional_settings  TYPE REF TO cl_salv_functional_settings,
            lo_tooltips             TYPE REF TO cl_salv_tooltips,
            lo_functions            TYPE REF TO cl_salv_functions_list,
            lv_status               TYPE lvc_value,
            lo_layout               TYPE REF TO cl_salv_layout,
            lo_key                  TYPE salv_s_layout_key,
            lo_aggregations         TYPE REF TO cl_salv_aggregations,
            lt_fieldcat             TYPE lvc_t_fcat,
            l_num                   TYPE char02 VALUE '1',
            l_col                   TYPE lvc_fname.

  IF bypiece EQ 'X'.                         "Affichage par type de pièce
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table    = lo_alv
          CHANGING
            t_table         = gt_bypiece2 ).
      CATCH cx_salv_msg.                                "#EC NO_HANDLER
    ENDTRY.
  ELSE.                                       "Affichage par USER
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table    = lo_alv
          CHANGING
            t_table         = gt_byuser2 ).
      CATCH cx_salv_msg.                                "#EC NO_HANDLER
    ENDTRY.
  ENDIF.
* Set functions
  lo_functions = lo_alv->get_functions( ).
  lo_functions->set_all( abap_true ).

* Set the columns
  lo_columns = lo_alv->get_columns( ).
  lo_columns->set_optimize( abap_true ).

  WHILE l_num < 13.
    READ TABLE gt_mark INTO gs_mark WITH KEY monat = l_num.
    IF sy-subrc IS NOT INITIAL.
      CONCATENATE 'COUNT' l_num INTO l_col.
      lo_column ?= lo_columns->get_column( columnname = l_col ).
      lo_column->set_visible( if_salv_c_bool_sap=>false ).
    ENDIF.
    ADD 1 TO l_num.
  ENDWHILE.

  lo_aggregations = lo_alv->get_aggregations( ).
  lt_fieldcat[] = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                                                    r_columns      = lo_columns
                                                    r_aggregations = lo_aggregations ).

  LOOP AT lt_fieldcat ASSIGNING <fcat>.
    IF <fcat>-fieldname(5) = 'COUNT'.
      PERFORM set_field.
    ENDIF.
  ENDLOOP.

  cl_salv_controller_metadata=>set_lvc_fieldcatalog( t_fieldcatalog = lt_fieldcat[]
                                                     r_columns      = lo_columns
                                                     r_aggregations = lo_aggregations ).

* Set Status Tooltips
  lo_functional_settings = lo_alv->get_functional_settings( ).
  lo_tooltips = lo_functional_settings->get_tooltips( ).

* Display report
  lo_alv->display( ).

ENDFORM.                    "display_alv