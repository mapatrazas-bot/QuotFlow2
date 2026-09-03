INTERFACE zif_printable_01
  PUBLIC.

  METHODS obtener_info_completa
    RETURNING VALUE(rv_info) TYPE string.

  METHODS obtener_info_corta
    RETURNING VALUE(rv_corta) TYPE string.

ENDINTERFACE.
