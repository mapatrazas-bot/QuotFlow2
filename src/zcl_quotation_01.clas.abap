CLASS zcl_quotation_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

  TYPES:
  BEGIN OF t_item,
    item_id    TYPE int4,
    product_id TYPE string,
    name       TYPE string,
    quantity   TYPE decfloat16,
    unit_price TYPE decfloat16,
    total      TYPE decfloat16,
  END OF t_item.

    TYPES tt_items TYPE TABLE OF t_item.

    CONSTANTS:
      BEGIN OF cs_status,
        draft    TYPE string VALUE 'DRAFT',
        approved TYPE string VALUE 'APPROVED',
        rejected TYPE string VALUE 'REJECTED',
      END OF cs_status.

    DATA quotation_id  TYPE string READ-ONLY.
    DATA status        TYPE string READ-ONLY.
    DATA creation_date TYPE sydate READ-ONLY.

    METHODS constructor
      IMPORTING
        VALUE(iv_quotation_id) TYPE string
        VALUE(iv_client_name)  TYPE string.

    METHODS add_item
      IMPORTING
        VALUE(io_product)  TYPE REF TO zcl_product_01
        VALUE(iv_quantity) TYPE decfloat16
      RETURNING VALUE(rv_item_id) TYPE int4.

    METHODS get_items
  EXPORTING VALUE(et_items) TYPE tt_items.

    METHODS calculate_total
      RETURNING VALUE(rv_total) TYPE decfloat16.

    METHODS get_client_name
      RETURNING VALUE(rv_name) TYPE string.

    METHODS get_summary
      RETURNING VALUE(rv_summary) TYPE string.

 EVENTS cotizacion_aprobada
      EXPORTING VALUE(ev_id_cotizacion) TYPE string
                VALUE(ev_nombre_cliente) TYPE string
                VALUE(ev_total) TYPE decfloat16.

    EVENTS cotizacion_rechazada
      EXPORTING VALUE(ev_id_cotizacion) TYPE string
                VALUE(ev_motivo) TYPE string.

    METHODS aprobar_cotizacion.

    METHODS rechazar_cotizacion
      IMPORTING VALUE(iv_motivo) TYPE string OPTIONAL.


  PRIVATE SECTION.
    DATA client_name   TYPE string.
    DATA items         TYPE tt_items.

    DATA item_counter TYPE int4.

ENDCLASS.


CLASS zcl_quotation_01 IMPLEMENTATION.

  METHOD constructor.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Crea la cotizacion en estado DRAFT con fecha de hoy
* Paquete   : ZPORTFOLIO_01
    me->quotation_id  = iv_quotation_id.
    me->client_name   = iv_client_name.
    me->status        = cs_status-draft.
    me->creation_date = sy-datum.
    me->item_counter  = 0.
  ENDMETHOD.

  METHOD add_item.
* Agrega un producto a la cotizacion y calcula el total de la linea
    me->item_counter = me->item_counter + 1.
    DATA(ls_product) = io_product->get_product_info( ).
    DATA(ls_item) = VALUE t_item(
      item_id    = me->item_counter
      product_id = ls_product-product_id
      name       = ls_product-name
      quantity   = iv_quantity
      unit_price = ls_product-unit_price
      total      = iv_quantity * ls_product-unit_price
    ).
    APPEND ls_item TO me->items.
    rv_item_id = me->item_counter.
  ENDMETHOD.

METHOD get_items.
* Retorna todas las posiciones de la cotizacion
  et_items = me->items.
ENDMETHOD.

  METHOD calculate_total.
* Suma todos los totales de linea y retorna el gran total
    LOOP AT me->items INTO DATA(ls_item).
      rv_total = rv_total + ls_item-total.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_client_name.
* Retorna el nombre del cliente de la cotizacion
    rv_name = me->client_name.
  ENDMETHOD.

  METHOD get_summary.
* Retorna un resumen completo de la cotizacion en texto
    rv_summary = |Cotizacion: { me->quotation_id } | &
                 |Cliente: { me->client_name } | &
                 |Estado: { me->status } | &
                 |Fecha: { me->creation_date } | &
                 |Total: { me->calculate_total( ) } { zcl_product_01=>company_currency }|.
  ENDMETHOD.

    METHOD aprobar_cotizacion.
* Cambia el estado a APROBADA y dispara el evento cotizacion_aprobada
    me->status = cs_status-approved.
    RAISE EVENT cotizacion_aprobada
      EXPORTING
        ev_id_cotizacion  = me->quotation_id
        ev_nombre_cliente = me->client_name
        ev_total          = me->calculate_total( ).
  ENDMETHOD.

  METHOD rechazar_cotizacion.
* Cambia el estado a RECHAZADA y dispara el evento cotizacion_rechazada
    me->status = cs_status-rejected.
    DATA(lv_motivo) = CONV string( '' ).
    IF iv_motivo IS SUPPLIED.
      lv_motivo = iv_motivo.
    ELSE.
      lv_motivo = 'Sin motivo especificado'.
    ENDIF.
    RAISE EVENT cotizacion_rechazada
      EXPORTING
        ev_id_cotizacion = me->quotation_id
        ev_motivo        = lv_motivo.
  ENDMETHOD.

ENDCLASS.
