*&---------------------------------------------------------------------*
*& Pool mod.         Z_VOLUME_PIECE
*&
*&---------------------------------------------------------------------*
*& PAP / AESC / Ticket 66054 / OT DE1K904579 / 19.03.2019
*& REPORT D'INDICATEURS COMPTABLES
*&---------------------------------------------------------------------*
PROGRAM  z_volume_piece.


INCLUDE zreport_fi_top                          .    " global Data

INCLUDE zreport_fi_screen.

INCLUDE zreport_fi_forms.


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

* INCLUDE ZREPORT_FI_O01                          .  " PBO-Modules
* INCLUDE ZREPORT_FI_I01                          .  " PAI-Modules
* INCLUDE ZREPORT_FI_F01                          .  " FORM-Routines