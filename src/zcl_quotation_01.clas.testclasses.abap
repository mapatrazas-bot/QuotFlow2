CLASS lcl_pruebas_cotizacion DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA lo_cotizacion TYPE REF TO zcl_quotation_01.
    DATA lo_producto   TYPE REF TO zcl_product_01.

    METHODS configurar        FOR TESTING.
    METHODS prueba_crear_cotizacion_valida FOR TESTING.
    METHODS prueba_crear_sin_id           FOR TESTING.
    METHODS prueba_crear_sin_cliente      FOR TESTING.
    METHODS prueba_agregar_item_valido    FOR TESTING.
    METHODS prueba_cantidad_invalida      FOR TESTING.
    METHODS prueba_aprobar_cotizacion     FOR TESTING.
    METHODS prueba_aprobar_dos_veces      FOR TESTING.
    METHODS prueba_calcular_total         FOR TESTING.

ENDCLASS.

CLASS lcl_pruebas_cotizacion IMPLEMENTATION.

  METHOD configurar.
* Inicializa los objetos antes de cada prueba
    lo_cotizacion = NEW zcl_quotation_01(
      iv_quotation_id = 'TEST-001'
      iv_client_name  = 'Cliente Prueba'
    ).
    lo_producto = NEW zcl_product_01(
      iv_product_id = 'P-TEST'
      iv_name       = 'Producto Test'
      iv_unit_price = '100'
    ).
  ENDMETHOD.

  METHOD prueba_crear_cotizacion_valida.
* Verifica que una cotizacion valida se crea en estado DRAFT
    cl_abap_unit_assert=>assert_not_initial(
      act = lo_cotizacion
      msg = 'La cotizacion no debe ser nula'
    ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_cotizacion->status
      exp = zcl_quotation_01=>cs_status-draft
      msg = 'El estado inicial debe ser DRAFT'
    ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_cotizacion->quotation_id
      exp = 'TEST-001'
      msg = 'El ID debe ser TEST-001'
    ).
  ENDMETHOD.

  METHOD prueba_crear_sin_id.
* Verifica que crear cotizacion sin ID lanza excepcion
    DATA lo_error TYPE REF TO zcx_quotation_01.
    TRY.
        DATA(lo_cot_invalida) = NEW zcl_quotation_01(
          iv_quotation_id = ''
          iv_client_name  = 'Cliente'
        ).
        cl_abap_unit_assert=>fail(
          msg = 'Debia lanzar excepcion por ID vacio'
        ).
      CATCH zcx_quotation_01 INTO lo_error.
        cl_abap_unit_assert=>assert_equals(
          act = lo_error->codigo_error
          exp = zcx_quotation_01=>cs_codigo_error-cotizacion_vacia
          msg = 'El codigo de error debe ser COTIZACION_VACIA'
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD prueba_crear_sin_cliente.
* Verifica que crear cotizacion sin cliente lanza excepcion
    DATA lo_error TYPE REF TO zcx_quotation_01.
    TRY.
        DATA(lo_cot_invalida) = NEW zcl_quotation_01(
          iv_quotation_id = 'Q-001'
          iv_client_name  = ''
        ).
        cl_abap_unit_assert=>fail(
          msg = 'Debia lanzar excepcion por cliente vacio'
        ).
      CATCH zcx_quotation_01 INTO lo_error.
        cl_abap_unit_assert=>assert_equals(
          act = lo_error->codigo_error
          exp = zcx_quotation_01=>cs_codigo_error-cliente_vacio
          msg = 'El codigo de error debe ser CLIENTE_VACIO'
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD prueba_agregar_item_valido.
* Verifica que agregar un item valido incrementa el contador
    DATA(lv_id_item) = lo_cotizacion->add_item(
      io_product  = lo_producto
      iv_quantity = '2'
    ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_id_item
      exp = 1
      msg = 'El primer item debe tener ID 1'
    ).
  ENDMETHOD.

  METHOD prueba_cantidad_invalida.
* Verifica que cantidad negativa o cero lanza excepcion
    DATA lo_error TYPE REF TO zcx_quotation_01.
    TRY.
        lo_cotizacion->add_item(
          io_product  = lo_producto
          iv_quantity = '-1'
        ).
        cl_abap_unit_assert=>fail(
          msg = 'Debia lanzar excepcion por cantidad invalida'
        ).
      CATCH zcx_quotation_01 INTO lo_error.
        cl_abap_unit_assert=>assert_equals(
          act = lo_error->codigo_error
          exp = zcx_quotation_01=>cs_codigo_error-precio_invalido
          msg = 'El codigo debe ser PRECIO_INVALIDO'
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD prueba_aprobar_cotizacion.
* Verifica que aprobar cambia el estado a APPROVED
    lo_cotizacion->aprobar_cotizacion( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_cotizacion->status
      exp = zcl_quotation_01=>cs_status-approved
      msg = 'El estado debe ser APPROVED tras aprobar'
    ).
  ENDMETHOD.

  METHOD prueba_aprobar_dos_veces.
* Verifica que aprobar una cotizacion ya aprobada lanza excepcion
    DATA lo_error TYPE REF TO zcx_quotation_01.
    lo_cotizacion->aprobar_cotizacion( ).
    TRY.
        lo_cotizacion->aprobar_cotizacion( ).
        cl_abap_unit_assert=>fail(
          msg = 'Debia lanzar excepcion al aprobar dos veces'
        ).
      CATCH zcx_quotation_01 INTO lo_error.
        cl_abap_unit_assert=>assert_equals(
          act = lo_error->codigo_error
          exp = zcx_quotation_01=>cs_codigo_error-ya_procesada
          msg = 'El codigo debe ser YA_PROCESADA'
        ).
    ENDTRY.
  ENDMETHOD.

  METHOD prueba_calcular_total.
* Verifica que el total se calcula correctamente
    lo_cotizacion->add_item( io_product = lo_producto iv_quantity = '3' ).
    lo_cotizacion->add_item( io_product = lo_producto iv_quantity = '2' ).
    DATA(lv_total) = lo_cotizacion->calculate_total( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_total
      exp = CONV decfloat16( '500' )
      msg = 'El total debe ser 500 (3+2 unidades x 100)'
    ).
  ENDMETHOD.

ENDCLASS.
