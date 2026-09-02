CLASS zcl_main_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_main_01 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Clase ejecutable de prueba - Fase I QuotFlow
* Paquete   : ZPORTFOLIO_01

* 1. Configurar moneda global (metodo estatico con =>)
    zcl_product_01=>set_company_currency( 'USD' ).
    out->write( |Moneda global: { zcl_product_01=>company_currency }| ).

* 2. Crear productos (constructor con parametros obligatorios y opcionales)
    DATA(lo_prod1) = NEW zcl_product_01(
      iv_product_id = 'PROD-001'
      iv_name       = 'Laptop Dell XPS'
      iv_unit_price = '1500.00'
      iv_category   = zcl_product_01=>cs_category-hardware
    ).

    DATA(lo_prod2) = NEW zcl_product_01(
      iv_product_id = 'PROD-002'
      iv_name       = 'Licencia SAP BTP'
      iv_unit_price = '800.00'
    ).

    DATA(lo_prod3) = NEW zcl_product_01(
      iv_product_id = 'PROD-003'
      iv_name       = 'Consultoria ABAP'
      iv_unit_price = '200.00'
      iv_category   = zcl_product_01=>cs_category-service
    ).

* Verificar que el objeto existe antes de usarlo (IS BOUND)
    IF lo_prod1 IS BOUND.
      DATA(ls_info) = lo_prod1->get_product_info( ).
      out->write( |Producto 1: { ls_info-name } - { ls_info-category } - { ls_info-unit_price } { ls_info-currency }| ).
    ENDIF.

    out->write( |Producto 2: { lo_prod2->get_product_info( )-name } - Categoria: { lo_prod2->get_product_info( )-category }| ).
    out->write( |Producto 3: { lo_prod3->get_product_info( )-name } - Precio: { lo_prod3->get_price( ) }| ).

* 3. Crear empresa (READ-ONLY y tipos estructurados)
    DATA(lo_company) = NEW zcl_company_01(
      iv_company_code = 'CO01'
      iv_company_name = 'TechSolutions S.A.'
      iv_type         = zcl_company_01=>cs_type-national
    ).

    lo_company->set_address( VALUE zcl_company_01=>t_address(
      country     = 'Colombia'
      city        = 'Bogota'
      street      = 'Av. El Dorado 92'
      postal_code = '110111'
    ) ).

    out->write( lo_company->get_full_info( ) ).

* 4. Crear cotizacion y agregar productos
    DATA(lo_quotation) = NEW zcl_quotation_01(
      iv_quotation_id = 'QUOT-2025-001'
      iv_client_name  = 'Banco Nacional de Colombia'
    ).

    lo_quotation->add_item( io_product = lo_prod1  iv_quantity = '3' ).
    lo_quotation->add_item( io_product = lo_prod2  iv_quantity = '10' ).
    lo_quotation->add_item( io_product = lo_prod3  iv_quantity = '5' ).

* 5. Mostrar detalle de posiciones
    out->write( '--- DETALLE DE POSICIONES ---' ).
    lo_quotation->get_items( IMPORTING et_items = DATA(lt_items) ).
LOOP AT lt_items INTO DATA(ls_item).
      out->write( |  [{ ls_item-item_id }] { ls_item-name } x{ ls_item-quantity } = { ls_item-total } { zcl_product_01=>company_currency }| ).
    ENDLOOP.

* 6. Mostrar resumen final de la cotizacion
    out->write( '--- RESUMEN ---' ).
    out->write( lo_quotation->get_summary( ) ).

  ENDMETHOD.

ENDCLASS.
