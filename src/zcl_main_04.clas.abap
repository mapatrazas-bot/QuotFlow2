CLASS zcl_main_04 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_main_04 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Clase ejecutable - Prueba Fase IV QuotFlow
* Paquete   : ZPORTFOLIO_01

* ─────────────────────────────────────────────────
* 1. EXCEPCION PROPIA - CASO VALIDO
* ─────────────────────────────────────────────────
    out->write( '=== 1. EXCEPCION - CASO VALIDO ===' ).
    TRY.
        DATA(lo_cotizacion) = NEW zcl_quotation_01(
          iv_quotation_id = 'QUOT-F4-001'
          iv_client_name  = 'Banco de Pruebas'
        ).
        out->write( |Cotizacion creada: { lo_cotizacion->quotation_id }| ).
        out->write( |Estado: { lo_cotizacion->status }| ).
      CATCH zcx_quotation_01 INTO DATA(lo_error).
        out->write( lo_error->obtener_mensaje( ) ).
    ENDTRY.

* ─────────────────────────────────────────────────
* 2. EXCEPCION - ID VACIO
* ─────────────────────────────────────────────────
    out->write( '=== 2. EXCEPCION - ID VACIO ===' ).
    TRY.
        DATA(lo_cot_invalida) = NEW zcl_quotation_01(
          iv_quotation_id = ''
          iv_client_name  = 'Cliente'
        ).
      CATCH zcx_quotation_01 INTO lo_error.
        out->write( |Error capturado: { lo_error->obtener_mensaje( ) }| ).
    ENDTRY.

* ─────────────────────────────────────────────────
* 3. EXCEPCION - CANTIDAD INVALIDA
* ─────────────────────────────────────────────────
    out->write( '=== 3. EXCEPCION - CANTIDAD INVALIDA ===' ).
    TRY.
        DATA(lo_prod) = NEW zcl_product_01(
          iv_product_id = 'P-001'
          iv_name       = 'Laptop'
          iv_unit_price = '1500'
        ).
        lo_cotizacion->add_item(
          io_product  = lo_prod
          iv_quantity = '-5'
        ).
      CATCH zcx_quotation_01 INTO lo_error.
        out->write( |Error capturado: { lo_error->obtener_mensaje( ) }| ).
    ENDTRY.

* ─────────────────────────────────────────────────
* 4. EXCEPCION - APROBAR DOS VECES (CLEANUP)
* ─────────────────────────────────────────────────
    out->write( '=== 4. EXCEPCION - APROBAR DOS VECES ===' ).
    DATA lv_operacion TYPE string.
    TRY.
        lv_operacion = 'primera aprobacion'.
        lo_cotizacion->aprobar_cotizacion( ).
        out->write( |Primera aprobacion exitosa. Estado: { lo_cotizacion->status }| ).

        lv_operacion = 'segunda aprobacion'.
        lo_cotizacion->aprobar_cotizacion( ).
      CATCH zcx_quotation_01 INTO lo_error.
        out->write( |Error en { lv_operacion }: { lo_error->obtener_mensaje( ) }| ).
      CLEANUP.
        out->write( 'CLEANUP ejecutado: liberando recursos de la operacion' ).
    ENDTRY.

* ─────────────────────────────────────────────────
* 5. PATRON SINGLETON - REPOSITORIO
* ─────────────────────────────────────────────────
    out->write( '=== 5. PATRON SINGLETON ===' ).

    DATA(lo_repo1) = zcl_quot_repository_01=>obtener_instancia( ).
    DATA(lo_repo2) = zcl_quot_repository_01=>obtener_instancia( ).

    IF lo_repo1 = lo_repo2.
      out->write( 'SINGLETON: ambas referencias apuntan al mismo objeto' ).
    ENDIF.

    TRY.
        lo_repo1->registrar_cotizacion( lo_cotizacion ).
        out->write( |Cotizaciones en repositorio: { lo_repo1->obtener_total_cotizaciones( ) }| ).
        lo_repo1->listar_ids( IMPORTING et_ids = DATA(lt_ids) ).
        LOOP AT lt_ids INTO DATA(lv_id).
          out->write( |  ID registrado: { lv_id }| ).
        ENDLOOP.
      CATCH zcx_quotation_01 INTO lo_error.
        out->write( lo_error->obtener_mensaje( ) ).
    ENDTRY.

* ─────────────────────────────────────────────────
* 6. PATRON FACTORY - CREAR OBJETOS
* ─────────────────────────────────────────────────
    out->write( '=== 6. PATRON FACTORY ===' ).
    TRY.
        DATA(lo_cot_factory) = zcl_quot_factory_01=>crear_cotizacion(
          iv_id      = 'QUOT-F4-002'
          iv_cliente = 'Empresa Factory S.A.'
        ).
        out->write( |Cotizacion creada por Factory: { lo_cot_factory->quotation_id }| ).
        out->write( |Cliente: { lo_cot_factory->get_client_name( ) }| ).
      CATCH zcx_quotation_01 INTO lo_error.
        out->write( lo_error->obtener_mensaje( ) ).
    ENDTRY.

* ─────────────────────────────────────────────────
* 7. PATRON STRATEGY - MOTOR SEGUN TIPO DE CLIENTE
* ─────────────────────────────────────────────────
    out->write( '=== 7. PATRON STRATEGY ===' ).

    DATA lt_tipos TYPE TABLE OF string.
    APPEND zcl_client_01=>cs_tipo-estandar TO lt_tipos.
    APPEND zcl_client_01=>cs_tipo-vip      TO lt_tipos.
    APPEND 'VIP_PLATINO'                   TO lt_tipos.
    APPEND 'DESCUENTO_FIJO'                TO lt_tipos.

    DATA(lv_precio_prueba) = CONV decfloat16( '5000' ).

    LOOP AT lt_tipos INTO DATA(lv_tipo).
      DATA(lo_motor) = zcl_quot_factory_01=>crear_motor_descuento(
        iv_tipo_cliente = lv_tipo
      ).
      lo_motor->obtener_resultado(
        EXPORTING
          iv_precio_base    = lv_precio_prueba
          iv_nombre_cliente = lv_tipo
        IMPORTING
          es_resultado = DATA(ls_resultado)
      ).
      out->write( |{ lv_tipo }: { lo_motor->describir( ) } | &
                  |-> Final: { ls_resultado-precio_final }| ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
