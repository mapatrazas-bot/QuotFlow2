CLASS zcl_quot_factory_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS crear_cotizacion
      IMPORTING
        VALUE(iv_id)          TYPE string
        VALUE(iv_cliente)     TYPE string
      RETURNING VALUE(ro_cotizacion) TYPE REF TO zcl_quotation_01
      RAISING   zcx_quotation_01.

    CLASS-METHODS crear_motor_descuento
      IMPORTING VALUE(iv_tipo_cliente) TYPE string
      RETURNING VALUE(ro_motor) TYPE REF TO zcl_discount_engine_01.

    CLASS-METHODS crear_producto
      IMPORTING
        VALUE(iv_id)       TYPE string
        VALUE(iv_nombre)   TYPE string
        VALUE(iv_precio)   TYPE decfloat16
        VALUE(iv_categoria) TYPE string OPTIONAL
      RETURNING VALUE(ro_producto) TYPE REF TO zcl_product_01.

ENDCLASS.


CLASS zcl_quot_factory_01 IMPLEMENTATION.

  METHOD crear_cotizacion.
* Crea y retorna una nueva cotizacion validada
* Delega la validacion a ZCL_QUOTATION_01 que lanza ZCX si hay error
    ro_cotizacion = NEW zcl_quotation_01(
      iv_quotation_id = iv_id
      iv_client_name  = iv_cliente
    ).
  ENDMETHOD.

  METHOD crear_motor_descuento.
* Fabrica el motor de descuento correcto segun el tipo de cliente
    CASE iv_tipo_cliente.
      WHEN zcl_client_01=>cs_tipo-vip.
        ro_motor = NEW zcl_descuento_vip_01( iv_nivel_vip = 'ORO' ).
      WHEN 'VIP_PLATINO'.
        ro_motor = NEW zcl_descuento_vip_01( iv_nivel_vip = 'PLATINO' ).
      WHEN 'DESCUENTO_FIJO'.
        ro_motor = NEW zcl_descuento_fijo_01( iv_porcentaje = '10' ).
      WHEN OTHERS.
        ro_motor = NEW zcl_discount_engine_01( ).
    ENDCASE.
  ENDMETHOD.

  METHOD crear_producto.
* Crea y retorna un nuevo producto
    IF iv_categoria IS SUPPLIED.
      ro_producto = NEW zcl_product_01(
        iv_product_id = iv_id
        iv_name       = iv_nombre
        iv_unit_price = iv_precio
        iv_category   = iv_categoria
      ).
    ELSE.
      ro_producto = NEW zcl_product_01(
        iv_product_id = iv_id
        iv_name       = iv_nombre
        iv_unit_price = iv_precio
      ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
