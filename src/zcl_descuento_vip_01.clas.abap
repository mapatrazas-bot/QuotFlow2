CLASS zcl_descuento_vip_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  INHERITING FROM zcl_descuento_fijo_01.

  PUBLIC SECTION.

    DATA nivel_vip TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        VALUE(iv_nivel_vip)  TYPE string    OPTIONAL
        VALUE(iv_porcentaje) TYPE decfloat16 OPTIONAL.

    METHODS calcular  REDEFINITION.
    METHODS describir REDEFINITION.

ENDCLASS.


CLASS zcl_descuento_vip_01 IMPLEMENTATION.

  METHOD constructor.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Estrategia VIP con descuento escalonado por nivel
* Paquete   : ZPORTFOLIO_01

* Paso 1: calcular todo con variables locales (sin tocar me->)
    DATA(lv_nivel) = CONV string( 'ORO' ).
    IF iv_nivel_vip IS SUPPLIED.
      lv_nivel = iv_nivel_vip.
    ENDIF.

    DATA(lv_porcentaje_base) = CONV decfloat16( '0' ).
    CASE lv_nivel.
      WHEN 'BRONCE'.  lv_porcentaje_base = 10.
      WHEN 'PLATA'.   lv_porcentaje_base = 15.
      WHEN 'ORO'.     lv_porcentaje_base = 20.
      WHEN 'PLATINO'. lv_porcentaje_base = 25.
      WHEN OTHERS.    lv_porcentaje_base = 10.
    ENDCASE.

    DATA(lv_porcentaje_final) = lv_porcentaje_base.
    IF iv_porcentaje IS SUPPLIED.
      lv_porcentaje_final = iv_porcentaje.
    ENDIF.

* Paso 2: llamar al super->constructor (primera asignacion real)
    super->constructor( iv_porcentaje = lv_porcentaje_final ).

* Paso 3: ahora si podemos usar me->
    me->nivel_vip         = lv_nivel.
    me->nombre_estrategia = zcl_discount_engine_01=>cs_estrategia-descuento_vip.

  ENDMETHOD.

  METHOD calcular.
* VIP: aplica el porcentaje VIP configurado segun nivel
    DATA(lv_valor) = iv_precio_base * me->porcentaje_descuento / 100.
    rv_precio_final = iv_precio_base - lv_valor.
  ENDMETHOD.

  METHOD describir.
* Descripcion del descuento VIP con nivel y porcentaje aplicado
    rv_descripcion = |Descuento VIP nivel { me->nivel_vip } | &
                     |del { me->porcentaje_descuento }% | &
                     |sobre el precio base|.
  ENDMETHOD.

ENDCLASS.
