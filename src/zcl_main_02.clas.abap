CLASS zcl_main_02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_main_02 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Clase ejecutable de prueba - Fase II QuotFlow
* Paquete   : ZPORTFOLIO_01

* ─────────────────────────────────────────────────
* 1. CONSTRUCTORES DE INSTANCIA Y ESTATICO
* ─────────────────────────────────────────────────
    out->write( '=== 1. CONSTRUCTORES ===' ).

    DATA(lo_estandar) = NEW zcl_client_01(
      iv_id_cliente = 'CLI-001'
      iv_nombre     = 'Empresa Estandar S.A.'
      iv_correo     = 'contacto@estandar.com'
    ).

    DATA(lo_vip) = NEW zcl_vip_client_01(
      iv_id_cliente = 'CLI-002'
      iv_nombre     = 'Banco Nacional'
      iv_correo     = 'gerencia@banco.com'
      iv_nivel_vip  = 'PLATINO'
      iv_descuento  = '20'
    ).

    out->write( lo_estandar->zif_printable_01~obtener_info_completa( ) ).
    out->write( lo_vip->zif_printable_01~obtener_info_completa( ) ).

* ─────────────────────────────────────────────────
* 2. HERENCIA - EL HIJO USA METODOS DEL PADRE
* ─────────────────────────────────────────────────
    out->write( '=== 2. HERENCIA ===' ).

    lo_vip->obtener_datos_cliente(
      IMPORTING es_cliente = DATA(ls_datos) ).

    out->write( |ID heredado del padre: { ls_datos-id_cliente }| ).
    out->write( |Nombre heredado: { ls_datos-nombre }| ).
    out->write( |Tipo sobreescrito por hijo: { ls_datos-tipo }| ).

* ─────────────────────────────────────────────────
* 3. INTERFACES - CONTRATO FORMAL
* ─────────────────────────────────────────────────
    out->write( '=== 3. INTERFACES ===' ).

    DATA(lv_precio_base) = CONV decfloat16( '1000' ).

    DATA(lv_precio_estandar) = lo_estandar->zif_priceable_01~calcular_descuento(
      iv_precio_base = lv_precio_base ).
    DATA(lv_precio_vip) = lo_vip->zif_priceable_01~calcular_descuento(
      iv_precio_base = lv_precio_base ).

    out->write( |Precio base:              { lv_precio_base }| ).
    out->write( |Precio estandar (0% dto): { lv_precio_estandar }| ).
    out->write( |Precio VIP (20% dto):     { lv_precio_vip }| ).

* ─────────────────────────────────────────────────
* 4. NARROWING CAST - UPCASTING
* ─────────────────────────────────────────────────
    out->write( '=== 4. NARROWING CAST (UPCASTING) ===' ).

    DATA lo_ref_padre TYPE REF TO zcl_client_01.

    lo_ref_padre = lo_estandar.
    out->write( |Padre apunta a ESTANDAR: { lo_ref_padre->zif_printable_01~obtener_info_corta( ) }| ).

    lo_ref_padre = lo_vip.
    out->write( |Padre apunta a VIP: { lo_ref_padre->zif_printable_01~obtener_info_corta( ) }| ).

    DATA(lv_precio_cast) = lo_ref_padre->zif_priceable_01~calcular_descuento(
      iv_precio_base = lv_precio_base ).
    out->write( |Precio via referencia padre (VIP activo): { lv_precio_cast }| ).

* ─────────────────────────────────────────────────
* 5. WIDENING CAST - DOWNCASTING
* ─────────────────────────────────────────────────
    out->write( '=== 5. WIDENING CAST (DOWNCASTING) ===' ).

    DATA lo_ref_vip TYPE REF TO zcl_vip_client_01.

    TRY.
        lo_ref_vip ?= lo_ref_padre.
        out->write( |Downcast exitoso - Nivel VIP: { lo_ref_vip->nivel_vip }| ).
        out->write( |Descuento maximo: { lo_ref_vip->descuento_maximo }%| ).
      CATCH cx_sy_move_cast_error.
        out->write( 'Error de cast: el objeto no es de tipo VIP' ).
    ENDTRY.

* ─────────────────────────────────────────────────
* 6. REFERENCIA A INTERFAZ (POLIMORFISMO POR INTERFAZ)
* ─────────────────────────────────────────────────
    out->write( '=== 6. REFERENCIA A INTERFAZ ===' ).

    DATA lo_ref_precio TYPE REF TO zif_priceable_01.

    lo_ref_precio = lo_estandar.
    out->write( |ESTANDAR via interfaz: { lo_ref_precio->calcular_descuento( iv_precio_base = lv_precio_base ) }| ).

    lo_ref_precio = lo_vip.
    out->write( |VIP via interfaz: { lo_ref_precio->calcular_descuento( iv_precio_base = lv_precio_base ) }| ).

* ─────────────────────────────────────────────────
* 7. TABLA DE REFERENCIAS (LOOP POLIMORFICO)
* ─────────────────────────────────────────────────
    out->write( '=== 7. TABLA DE REFERENCIAS ===' ).

    DATA lt_clientes TYPE TABLE OF REF TO zif_priceable_01.
    APPEND lo_estandar TO lt_clientes.
    APPEND lo_vip      TO lt_clientes.

    LOOP AT lt_clientes INTO DATA(lo_cliente).
      DATA(lv_resultado) = lo_cliente->calcular_descuento(
        iv_precio_base = lv_precio_base ).
      out->write( |Precio calculado: { lv_resultado }| ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
