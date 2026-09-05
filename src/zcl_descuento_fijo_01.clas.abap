CLASS zcl_descuento_fijo_01 DEFINITION
  PUBLIC
  CREATE PUBLIC
  INHERITING FROM zcl_discount_engine_01.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING VALUE(iv_porcentaje) TYPE decfloat16 OPTIONAL.

    METHODS calcular REDEFINITION.
    METHODS describir REDEFINITION.

ENDCLASS.


CLASS zcl_descuento_fijo_01 IMPLEMENTATION.

  METHOD constructor.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Estrategia con porcentaje de descuento fijo configurable
* Paquete   : ZPORTFOLIO_01
    super->constructor(
      iv_nombre_estrategia = zcl_discount_engine_01=>cs_estrategia-descuento_fijo
    ).
    IF iv_porcentaje IS SUPPLIED.
      me->porcentaje_descuento = iv_porcentaje.
    ELSE.
      me->porcentaje_descuento = 10.
    ENDIF.
  ENDMETHOD.

  METHOD calcular.
* Aplica el porcentaje fijo configurado al precio base
    DATA(lv_valor) = iv_precio_base * me->porcentaje_descuento / 100.
    rv_precio_final = iv_precio_base - lv_valor.
  ENDMETHOD.

  METHOD describir.
* Descripcion especifica de la estrategia de descuento fijo
    rv_descripcion = |Descuento fijo del { me->porcentaje_descuento }% | &
                     |sobre el precio base|.
  ENDMETHOD.

ENDCLASS.
