*----------------------------------------------------------------------*
* Clase local: manejador de eventos de cotizacion
* Escucha los eventos disparados por ZCL_QUOTATION_01
*----------------------------------------------------------------------*
CLASS lcl_manejador_eventos DEFINITION.
  PUBLIC SECTION.

    DATA registro_log TYPE string.

    METHODS manejar_aprobacion
      FOR EVENT cotizacion_aprobada OF zcl_quotation_01
        IMPORTING
          ev_id_cotizacion
          ev_nombre_cliente
          ev_total.

    METHODS manejar_rechazo
      FOR EVENT cotizacion_rechazada OF zcl_quotation_01
        IMPORTING
          ev_id_cotizacion
          ev_motivo.

    METHODS obtener_log
      RETURNING VALUE(rv_log) TYPE string.

ENDCLASS.

CLASS lcl_manejador_eventos IMPLEMENTATION.

  METHOD manejar_aprobacion.
* Recibe el evento de aprobacion y registra en el log interno
    me->registro_log = me->registro_log &&
      |[APROBADA] Cotizacion: { ev_id_cotizacion } | &
      |Cliente: { ev_nombre_cliente } | &
      |Total: { ev_total } | &
      ||.
  ENDMETHOD.

  METHOD manejar_rechazo.
* Recibe el evento de rechazo y registra en el log interno
    me->registro_log = me->registro_log &&
      |[RECHAZADA] Cotizacion: { ev_id_cotizacion } | &
      |Motivo: { ev_motivo } | &
      || .
  ENDMETHOD.

  METHOD obtener_log.
* Retorna el log acumulado de eventos
    rv_log = me->registro_log.
  ENDMETHOD.

ENDCLASS.
