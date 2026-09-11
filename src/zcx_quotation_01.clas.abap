CLASS zcx_quotation_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  INHERITING FROM cx_static_check.

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF cs_codigo_error,
        estado_invalido   TYPE string VALUE 'ESTADO_INVALIDO',
        cliente_vacio     TYPE string VALUE 'CLIENTE_VACIO',
        precio_invalido   TYPE string VALUE 'PRECIO_INVALIDO',
        cotizacion_vacia  TYPE string VALUE 'COTIZACION_VACIA',
        ya_procesada      TYPE string VALUE 'YA_PROCESADA',
      END OF cs_codigo_error.

    DATA codigo_error TYPE string READ-ONLY.
    DATA detalle      TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        VALUE(iv_codigo_error) TYPE string OPTIONAL
        VALUE(iv_detalle)      TYPE string OPTIONAL
        VALUE(iv_previous)     TYPE REF TO cx_root OPTIONAL.

    METHODS obtener_mensaje
      RETURNING VALUE(rv_mensaje) TYPE string.

ENDCLASS.


CLASS zcx_quotation_01 IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Inicializa la excepcion con codigo y detalle del error
* Paquete   : ZPORTFOLIO_01
    super->constructor(
      previous = iv_previous
    ).
    IF iv_codigo_error IS SUPPLIED.
      me->codigo_error = iv_codigo_error.
    ELSE.
      me->codigo_error = 'ERROR_GENERAL'.
    ENDIF.
    IF iv_detalle IS SUPPLIED.
      me->detalle = iv_detalle.
    ENDIF.
  ENDMETHOD.

  METHOD obtener_mensaje.
* Retorna el mensaje completo de error formateado
    rv_mensaje = |[{ me->codigo_error }] { me->detalle }|.
  ENDMETHOD.

ENDCLASS.
