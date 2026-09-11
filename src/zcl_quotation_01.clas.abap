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
        VALUE(iv_client_name)  TYPE string
      RAISING
        zcx_quotation_01.

    METHODS add_item
      IMPORTING
        VALUE(io_product)  TYPE REF TO zcl_product_01
        VALUE(iv_quantity) TYPE decfloat16
      RETURNING VALUE(rv_item_id) TYPE int4
      RAISING
        zcx_quotation_01.

    METHODS aprobar_cotizacion
      RAISING zcx_quotation_01.

    METHODS rechazar_cotizacion
      IMPORTING VALUE(iv_motivo) TYPE string OPTIONAL
      RAISING   zcx_quotation_01.

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


  PRIVATE SECTION.
    DATA client_name   TYPE string.
    DATA items         TYPE tt_items.

    DATA item_counter TYPE int4.

ENDCLASS.



CLASS ZCL_QUOTATION_01 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_QUOTATION_01->ADD_ITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_PRODUCT                     TYPE REF TO ZCL_PRODUCT_01
* | [--->] IV_QUANTITY                    TYPE        DECFLOAT16
* | [<-()] RV_ITEM_ID                     TYPE        INT4
* | [!CX!] Z_QUOTATION_01
* +--------------------------------------------------------------------------------------</SIGNATURE>
 METHOD add_item.
* Valida que la cantidad sea mayor a cero antes de agregar
    IF iv_quantity <= 0.
      RAISE EXCEPTION TYPE zcx_quotation_01
        EXPORTING
          iv_codigo_error = zcx_quotation_01=>cs_codigo_error-precio_invalido
          iv_detalle      = |La cantidad debe ser mayor a 0. Valor recibido: { iv_quantity }|.
    ENDIF.
    me->item_counter = me->item_counter + 1.
    DATA(ls_producto) = io_product->get_product_info( ).
    DATA(ls_item) = VALUE t_item(
      item_id    = me->item_counter
      product_id = ls_producto-product_id
      name       = ls_producto-name
      quantity   = iv_quantity
      unit_price = ls_producto-unit_price
      total      = iv_quantity * ls_producto-unit_price
    ).
    APPEND ls_item TO me->items.
    rv_item_id = me->item_counter.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_QUOTATION_01->APROBAR_COTIZACION
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] Z_QUOTATION_01
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD aprobar_cotizacion.
* Valida que la cotizacion no este ya procesada antes de aprobar
    IF me->status <> cs_status-draft.
      RAISE EXCEPTION TYPE zcx_quotation_01
        EXPORTING
          iv_codigo_error = zcx_quotation_01=>cs_codigo_error-ya_procesada
          iv_detalle      = |No se puede aprobar. Estado actual: { me->status }|.
    ENDIF.
    me->status = cs_status-approved.
    RAISE EVENT cotizacion_aprobada
      EXPORTING
        ev_id_cotizacion  = me->quotation_id
        ev_nombre_cliente = me->client_name
        ev_total          = me->calculate_total( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_QUOTATION_01->CALCULATE_TOTAL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_TOTAL                       TYPE        DECFLOAT16
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_total.
* Suma todos los totales de linea y retorna el gran total
    LOOP AT me->items INTO DATA(ls_item).
      rv_total = rv_total + ls_item-total.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_QUOTATION_01->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_QUOTATION_ID                TYPE        STRING
* | [--->] IV_CLIENT_NAME                 TYPE        STRING
* | [!CX!] Z_QUOTATION_01
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
* Valida que no se cree una cotizacion sin ID ni cliente
    IF iv_quotation_id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_quotation_01
        EXPORTING
          iv_codigo_error = zcx_quotation_01=>cs_codigo_error-cotizacion_vacia
          iv_detalle      = 'El ID de cotizacion no puede estar vacio'.
    ENDIF.
    IF iv_client_name IS INITIAL.
      RAISE EXCEPTION TYPE zcx_quotation_01
        EXPORTING
          iv_codigo_error = zcx_quotation_01=>cs_codigo_error-cliente_vacio
          iv_detalle      = 'El nombre del cliente no puede estar vacio'.
    ENDIF.
    me->quotation_id  = iv_quotation_id.
    me->client_name   = iv_client_name.
    me->status        = cs_status-draft.
    me->creation_date = sy-datum.
    me->item_counter  = 0.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_QUOTATION_01->GET_CLIENT_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_NAME                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_client_name.
* Retorna el nombre del cliente de la cotizacion
    rv_name = me->client_name.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_QUOTATION_01->GET_ITEMS
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_ITEMS                       TYPE        TT_ITEMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD get_items.
* Retorna todas las posiciones de la cotizacion
  et_items = me->items.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_QUOTATION_01->GET_SUMMARY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_SUMMARY                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_summary.
* Retorna un resumen completo de la cotizacion en texto
    rv_summary = |Cotizacion: { me->quotation_id } | &
                 |Cliente: { me->client_name } | &
                 |Estado: { me->status } | &
                 |Fecha: { me->creation_date } | &
                 |Total: { me->calculate_total( ) } { zcl_product_01=>company_currency }|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_QUOTATION_01->RECHAZAR_COTIZACION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MOTIVO                      TYPE        STRING(optional)
* | [!CX!] Z_QUOTATION_01
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD rechazar_cotizacion.
* Valida que la cotizacion no este ya procesada antes de rechazar
    IF me->status <> cs_status-draft.
      RAISE EXCEPTION TYPE zcx_quotation_01
        EXPORTING
          iv_codigo_error = zcx_quotation_01=>cs_codigo_error-ya_procesada
          iv_detalle      = |No se puede rechazar. Estado actual: { me->status }|.
    ENDIF.
    me->status = cs_status-rejected.
    DATA(lv_motivo) = CONV string( 'Sin motivo especificado' ).
    IF iv_motivo IS SUPPLIED.
      lv_motivo = iv_motivo.
    ENDIF.
    RAISE EVENT cotizacion_rechazada
      EXPORTING
        ev_id_cotizacion = me->quotation_id
        ev_motivo        = lv_motivo.
  ENDMETHOD.
ENDCLASS.
