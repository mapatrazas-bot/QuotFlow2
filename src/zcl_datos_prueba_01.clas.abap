CLASS zcl_datos_prueba_01 DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_datos_prueba_01 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
* Autor      : CB9980004419
* Fecha      : 2025-01-01
* Descripcion: Inserta clientes de prueba en ZDT_CLIENT_01
* Paquete    : ZPORTFOLIO_01

    DATA lv_utc TYPE utclong.
    lv_utc = '2025-01-01 00:00:00.0000000'.  " valor fijo para datos de prueba

    DELETE FROM zdt_client_01 WHERE id_cliente <> ''.

    INSERT zdt_client_01 FROM TABLE @( VALUE #(
      ( id_cliente     = '1097162717'
        nombre         = 'Miguel_Angel'
        correo         = 'miguel@quotflow.com'
        tipo           = 'EMPRESA'
        nivel_vip      = 'GOLD'
        tasa_descuento = '10.00'
        activo         = 'X'
        creado_por     = sy-uname
        creado_en      = lv_utc
        modificado_en  = lv_utc )
      ( id_cliente     = '23366494'
        nombre         = 'Leonor_Mateus'
        correo         = 'leonor@quotflow.com'
        tipo           = 'PERSONA'
        nivel_vip      = 'SILVER'
        tasa_descuento = '5.00'
        activo         = 'X'
        creado_por     = sy-uname
        creado_en      = lv_utc
        modificado_en  = lv_utc )
    ) ).

    IF sy-subrc = 0.
      COMMIT WORK.
      out->write( '✅ Clientes insertados correctamente' ).
    ELSE.
      out->write( |❌ Error al insertar: { sy-subrc }| ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
