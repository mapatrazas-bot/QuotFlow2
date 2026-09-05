CLASS zcl_main_03 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_main_03 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Prueba Fase III - Polimorfismo, Eventos, Clases Locales
* Paquete   : ZPORTFOLIO_01

* ─────────────────────────────────────────────────
* 1. POLIMORFISMO DINAMICO - MOTOR DE DESCUENTOS
* ─────────────────────────────────────────────────
    out->write( '=== 1. POLIMORFISMO - MOTOR DE DESCUENTOS ===' ).

    DATA(lo_sin_descuento) = NEW zcl_discount_engine_01( ).
    DATA(lo_fijo)          = NEW zcl_descuento_fijo_01( iv_porcentaje = '10' ).
    DATA(lo_vip_oro)       = NEW zcl_descuento_vip_01( iv_nivel_vip = 'ORO' ).
    DATA(lo_vip_platino)   = NEW zcl_descuento_vip_01( iv_nivel_vip = 'PLATINO' ).

    out->write( lo_sin_descuento->describir( ) ).
    out->write( lo_fijo->describir( ) ).
    out->write( lo_vip_oro->describir( ) ).
    out->write( lo_vip_platino->describir( ) ).

* ─────────────────────────────────────────────────
* 2. TABLA DE REFERENCIAS (binding dinamico)
* ─────────────────────────────────────────────────
    out->write( '=== 2. TABLA DE REFERENCIAS ===' ).

    DATA lt_motores TYPE TABLE OF REF TO zcl_discount_engine_01.
    APPEND lo_sin_descuento TO lt_motores.
    APPEND lo_fijo          TO lt_motores.
    APPEND lo_vip_oro       TO lt_motores.
    APPEND lo_vip_platino   TO lt_motores.

    DATA(lv_precio_base) = CONV decfloat16( '2000' ).

     LOOP AT lt_motores INTO DATA(lo_motor).
      lo_motor->obtener_resultado(
        EXPORTING
          iv_precio_base    = lv_precio_base
          iv_nombre_cliente = 'Cliente Demo'
        IMPORTING
          es_resultado      = DATA(ls_resultado)
      ).
      out->write( |{ ls_resultado-tipo_cliente } | &
                  |-> Base: { ls_resultado-precio_base } | &
                  |Final: { ls_resultado-precio_final } | &
                  |Ahorro: { ls_resultado-valor_descuento }| ).
    ENDLOOP.

* ─────────────────────────────────────────────────
* 3. COTIZACION CON MOTOR DE DESCUENTOS
* ─────────────────────────────────────────────────
    out->write( '=== 3. COTIZACION CON MOTOR ===' ).

    DATA(lo_producto) = NEW zcl_product_01(
      iv_product_id = 'PROD-001'
      iv_name       = 'Laptop Dell'
      iv_unit_price = '1500'
    ).

    DATA(lo_cotizacion) = NEW zcl_quotation_01(
      iv_quotation_id = 'QUOT-2025-003'
      iv_client_name  = 'Banco Nacional'
    ).

    lo_cotizacion->add_item(
      io_product  = lo_producto
      iv_quantity = '3'
    ).

    DATA(lv_total_base) = lo_cotizacion->calculate_total( ).

      lo_vip_oro->obtener_resultado(
      EXPORTING
        iv_precio_base    = lv_total_base
        iv_nombre_cliente = lo_cotizacion->get_client_name( )
      IMPORTING
        es_resultado      = DATA(ls_res_cotizacion)
    ).

    out->write( |Total base cotizacion:  { ls_res_cotizacion-precio_base }| ).
    out->write( |Total con descuento VIP ORO (20%): { ls_res_cotizacion-precio_final }| ).
    out->write( |Ahorro del cliente: { ls_res_cotizacion-valor_descuento }| ).

* ─────────────────────────────────────────────────
* 4. EVENTOS - RAISE EVENT / SET HANDLER
* ─────────────────────────────────────────────────
    out->write( '=== 4. EVENTOS ===' ).

    DATA(lo_manejador) = NEW lcl_manejador_eventos( ).

    SET HANDLER lo_manejador->manejar_aprobacion FOR lo_cotizacion.
    SET HANDLER lo_manejador->manejar_rechazo    FOR lo_cotizacion.

    out->write( |Estado antes: { lo_cotizacion->status }| ).
    lo_cotizacion->aprobar_cotizacion( ).
    out->write( |Estado despues: { lo_cotizacion->status }| ).

* ─────────────────────────────────────────────────
* 5. SEGUNDA COTIZACION - EVENTO RECHAZO
* ─────────────────────────────────────────────────
    out->write( '=== 5. EVENTO RECHAZO ===' ).

    DATA(lo_cotizacion2) = NEW zcl_quotation_01(
      iv_quotation_id = 'QUOT-2025-004'
      iv_client_name  = 'Empresa Rechazada S.A.'
    ).

    SET HANDLER lo_manejador->manejar_aprobacion FOR lo_cotizacion2.
    SET HANDLER lo_manejador->manejar_rechazo    FOR lo_cotizacion2.

    lo_cotizacion2->rechazar_cotizacion(
      iv_motivo = 'Presupuesto insuficiente'
    ).
    out->write( |Estado cotizacion 2: { lo_cotizacion2->status }| ).

* ─────────────────────────────────────────────────
* 6. LOG DE EVENTOS (clase local)
* ─────────────────────────────────────────────────
    out->write( '=== 6. LOG DE EVENTOS ===' ).
    out->write( lo_manejador->obtener_log( ) ).

  ENDMETHOD.

ENDCLASS.
