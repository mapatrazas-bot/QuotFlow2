CLASS zcl_discount_engine_01 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_resultado_descuento,
        nombre_cliente  TYPE string,
        tipo_cliente    TYPE string,
        precio_base     TYPE decfloat16,
        precio_final    TYPE decfloat16,
        valor_descuento TYPE decfloat16,
        porcentaje      TYPE decfloat16,
      END OF t_resultado_descuento.

    CONSTANTS:
      BEGIN OF cs_estrategia,
        sin_descuento   TYPE string VALUE 'SIN_DESCUENTO',
        descuento_fijo  TYPE string VALUE 'DESCUENTO_FIJO',
        descuento_vip   TYPE string VALUE 'DESCUENTO_VIP',
      END OF cs_estrategia.

    DATA nombre_estrategia TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING VALUE(iv_nombre_estrategia) TYPE string OPTIONAL.

    METHODS calcular
      IMPORTING
        VALUE(iv_precio_base)  TYPE decfloat16
        VALUE(iv_nombre_cliente) TYPE string OPTIONAL
      RETURNING VALUE(rv_precio_final) TYPE decfloat16.

    METHODS obtener_resultado
      IMPORTING
        VALUE(iv_precio_base)    TYPE decfloat16
        VALUE(iv_nombre_cliente) TYPE string OPTIONAL
      EXPORTING
        VALUE(es_resultado) TYPE t_resultado_descuento.

    METHODS describir
      RETURNING VALUE(rv_descripcion) TYPE string.

  PROTECTED SECTION.
    DATA porcentaje_descuento TYPE decfloat16.

ENDCLASS.


CLASS zcl_discount_engine_01 IMPLEMENTATION.

  METHOD constructor.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Motor base sin descuento - estrategia por defecto
* Paquete   : ZPORTFOLIO_01
    IF iv_nombre_estrategia IS SUPPLIED.
      me->nombre_estrategia = iv_nombre_estrategia.
    ELSE.
      me->nombre_estrategia = cs_estrategia-sin_descuento.
    ENDIF.
    me->porcentaje_descuento = 0.
  ENDMETHOD.

  METHOD calcular.
* Estrategia base: sin descuento, retorna precio original
    rv_precio_final = iv_precio_base.
  ENDMETHOD.

  METHOD obtener_resultado.
* Construye el resultado completo del calculo de descuento
    DATA(lv_precio_final) = me->calcular(
      iv_precio_base     = iv_precio_base
      iv_nombre_cliente  = iv_nombre_cliente
    ).
    es_resultado-nombre_cliente  = iv_nombre_cliente.
    es_resultado-tipo_cliente    = me->nombre_estrategia.
    es_resultado-precio_base     = iv_precio_base.
    es_resultado-precio_final    = lv_precio_final.
    es_resultado-valor_descuento = iv_precio_base - lv_precio_final.
    es_resultado-porcentaje      = me->porcentaje_descuento.
  ENDMETHOD.

  METHOD describir.
* Retorna descripcion de la estrategia activa
    rv_descripcion = |Estrategia: { me->nombre_estrategia } | &
                     |Descuento: { me->porcentaje_descuento }%|.
  ENDMETHOD.

ENDCLASS.
