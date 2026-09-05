CLASS zcl_vip_client_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  INHERITING FROM zcl_client_01.

  PUBLIC SECTION.

    DATA nivel_vip       TYPE string    READ-ONLY.
    DATA descuento_maximo TYPE decfloat16 READ-ONLY.

    METHODS constructor
      IMPORTING
        VALUE(iv_id_cliente)      TYPE string
        VALUE(iv_nombre)          TYPE string
        VALUE(iv_correo)          TYPE string    OPTIONAL
        VALUE(iv_nivel_vip)       TYPE string    OPTIONAL
        VALUE(iv_descuento)       TYPE decfloat16 OPTIONAL.

    METHODS zif_priceable_01~calcular_descuento     REDEFINITION.
    METHODS zif_priceable_01~obtener_tasa_descuento REDEFINITION.
    METHODS zif_printable_01~obtener_info_completa  REDEFINITION.
    METHODS zif_printable_01~obtener_info_corta     REDEFINITION.


ENDCLASS.


CLASS zcl_vip_client_01 IMPLEMENTATION.

  METHOD constructor.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Constructor VIP - invoca al padre y agrega nivel y descuento
* Paquete   : ZPORTFOLIO_01
    super->constructor(
      iv_id_cliente = iv_id_cliente
      iv_nombre     = iv_nombre
      iv_correo     = iv_correo
    ).
    me->tipo = cs_tipo-vip.
    IF iv_nivel_vip IS SUPPLIED.
      me->nivel_vip = iv_nivel_vip.
    ELSE.
      me->nivel_vip = 'ORO'.
    ENDIF.
    IF iv_descuento IS SUPPLIED.
      me->tasa_descuento   = iv_descuento.
      me->descuento_maximo = iv_descuento.
    ELSE.
      me->tasa_descuento   = 15.
      me->descuento_maximo = 15.
    ENDIF.
  ENDMETHOD.

  METHOD zif_priceable_01~calcular_descuento.
* Aplica el descuento VIP al precio base segun la tasa configurada
    DATA(lv_valor_descuento) = iv_precio_base * me->tasa_descuento / 100.
    rv_precio_final = iv_precio_base - lv_valor_descuento.
  ENDMETHOD.

  METHOD zif_priceable_01~obtener_tasa_descuento.
* Retorna la tasa de descuento del cliente VIP
    rv_tasa = me->tasa_descuento.
  ENDMETHOD.

  METHOD zif_printable_01~obtener_info_completa.
* Informacion completa del cliente VIP con nivel y descuento maximo
    rv_info = |Cliente VIP: { me->nombre } | &
              |[{ me->id_cliente }] | &
              |Nivel: { me->nivel_vip } | &
              |Descuento: { me->tasa_descuento }% | &
              |Maximo: { me->descuento_maximo }%|.
  ENDMETHOD.

  METHOD zif_printable_01~obtener_info_corta.
* Descripcion corta del cliente VIP con su nivel
    rv_corta = |{ me->nombre } (VIP { me->nivel_vip })|.
  ENDMETHOD.

ENDCLASS.
