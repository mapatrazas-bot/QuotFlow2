CLASS zcl_quot_repository_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS obtener_instancia
      RETURNING VALUE(ro_instancia) TYPE REF TO zcl_quot_repository_01.

    METHODS registrar_cotizacion
      IMPORTING VALUE(io_cotizacion) TYPE REF TO zcl_quotation_01
      RAISING   zcx_quotation_01.

    METHODS buscar_cotizacion
      IMPORTING VALUE(iv_id) TYPE string
      RETURNING VALUE(ro_cotizacion) TYPE REF TO zcl_quotation_01.

    METHODS obtener_total_cotizaciones
      RETURNING VALUE(rv_total) TYPE int4.

    METHODS listar_ids
      EXPORTING VALUE(et_ids) TYPE string_table.

  PRIVATE SECTION.
    CLASS-DATA instancia_unica TYPE REF TO zcl_quot_repository_01.
    DATA cotizaciones TYPE HASHED TABLE OF REF TO zcl_quotation_01
                      WITH UNIQUE KEY table_line.

ENDCLASS.


CLASS zcl_quot_repository_01 IMPLEMENTATION.

  METHOD obtener_instancia.
* Patron Singleton: retorna siempre la misma instancia
* Si no existe, la crea una sola vez
    IF instancia_unica IS NOT BOUND.
      instancia_unica = NEW zcl_quot_repository_01( ).
    ENDIF.
    ro_instancia = instancia_unica.
  ENDMETHOD.

  METHOD registrar_cotizacion.
* Valida que no se registre una cotizacion nula
    IF io_cotizacion IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_quotation_01
        EXPORTING
          iv_codigo_error = zcx_quotation_01=>cs_codigo_error-cotizacion_vacia
          iv_detalle      = 'No se puede registrar una cotizacion nula'.
    ENDIF.
    INSERT io_cotizacion INTO TABLE me->cotizaciones.
  ENDMETHOD.

  METHOD buscar_cotizacion.
* Busca la cotizacion por ID iterando el repositorio
    LOOP AT me->cotizaciones INTO DATA(lo_cot).
      IF lo_cot->quotation_id = iv_id.
        ro_cotizacion = lo_cot.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD obtener_total_cotizaciones.
* Retorna la cantidad de cotizaciones registradas
    rv_total = lines( me->cotizaciones ).
  ENDMETHOD.

  METHOD listar_ids.
* Exporta la lista de IDs de todas las cotizaciones registradas
    LOOP AT me->cotizaciones INTO DATA(lo_cot).
      APPEND lo_cot->quotation_id TO et_ids.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
