CLASS lhc_cotizacion DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations
      FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
                FOR Cotizacion
      RESULT result.
ENDCLASS.

CLASS lhc_cotizacion IMPLEMENTATION.
  METHOD get_instance_authorizations.
* Autor      : CB9980004419
* Fecha      : 2025-01-01
* Descripcion: Autoriza operaciones CRUD sobre cotizaciones
* Paquete    : ZPORTFOLIO_01
    LOOP AT keys INTO DATA(ls_clave).
      APPEND VALUE #(
        %tky    = ls_clave-%tky
        %update = if_abap_behv=>auth-allowed
        %delete = if_abap_behv=>auth-allowed
      ) TO result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
