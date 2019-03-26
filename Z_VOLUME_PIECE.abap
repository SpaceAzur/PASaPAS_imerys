*&---------------------------------------------------------------------*
*& Pool mod.         Z_VOLUME_PIECE
*&
*&---------------------------------------------------------------------*
*& PAP / AESC / Ticket 66054 / 19.03.2019
*&
*&---------------------------------------------------------------------*
* Program Description:                                                 *
* REPORT D'INDICATEURS COMPTABLES                                      *
*                                                                      *
*&---------------------------------------------------------------------*
* Version management                                                   *
* Vers    Date      Author        Signing up      Modification id      *
*&---------------------------------------------------------------------*
* 001   15/03/19   AESC           DE1K904579      Create               *
*&---------------------------------------------------------------------*
PROGRAM  z_volume_piece.


INCLUDE zreport_fi_top                          .    " global Data
INCLUDE zreport_fi_screen.
INCLUDE zreport_fi_forms.

*INITIALIZATION.

*PERFORM populate_username.

START-OF-SELECTION.

  PERFORM get_data.

  IF bypiece EQ 'X'.

    PERFORM manage_data_by_piece.
    PERFORM display_alv_by_piece.

  ELSE.

    PERFORM manage_data_by_user.
    PERFORM display_alv_by_user.

  ENDIF.

END-OF-SELECTION.