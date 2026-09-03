CLASS zcl_client_01 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_priceable_01.
    INTERFACES zif_printable_01.

    TYPES:
      BEGIN OF t_cliente,
        id_cliente  TYPE string,
        nombre      TYPE string,
        correo      TYPE string,
        tipo        TYPE string,
      END OF t_cliente.

    CONSTANTS:
      BEGIN OF cs_tipo,
        estandar TYPE string VALUE 'ESTANDAR',
        vip      TYPE string VALUE 'VIP',
      END OF cs_tipo.

    DATA id_cliente  TYPE string READ-ONLY.
    DATA nombre      TYPE string READ-ONLY.
    DATA correo      TYPE string READ-ONLY.
    DATA tipo        TYPE string READ-ONLY.

    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING
        VALUE(iv_id_cliente) TYPE string
        VALUE(iv_nombre)     TYPE string
        VALUE(iv_correo)     TYPE string OPTIONAL.

    METHODS obtener_datos_cliente
      EXPORTING VALUE(es_cliente) TYPE t_cliente.

  PROTECTED SECTION.
    DATA tasa_descuento TYPE decfloat16.

ENDCLASS.


CLASS zcl_client_01 IMPLEMENTATION.

  METHOD class_constructor.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Constructor estatico de la clase cliente
* Paquete   : ZPORTFOLIO_01
  ENDMETHOD.

  METHOD constructor.
* Inicializa el cliente estandar sin descuento
    me->id_cliente     = iv_id_cliente.
    me->nombre         = iv_nombre.
    me->tipo           = cs_tipo-estandar.
    me->tasa_descuento = 0.
    IF iv_correo IS SUPPLIED.
      me->correo = iv_correo.
    ENDIF.
  ENDMETHOD.

  METHOD zif_priceable_01~calcular_descuento.
* Cliente estandar: sin descuento, retorna el precio base sin cambios
    rv_precio_final = iv_precio_base.
  ENDMETHOD.

  METHOD zif_priceable_01~obtener_tasa_descuento.
* Retorna la tasa de descuento (0 para cliente estandar)
    rv_tasa = me->tasa_descuento.
  ENDMETHOD.

  METHOD zif_printable_01~obtener_info_completa.
* Retorna informacion detallada del cliente en una cadena de texto
    rv_info = |Cliente: { me->nombre } | &
              |[{ me->id_cliente }] | &
              |Tipo: { me->tipo } | &
              |Descuento: { me->tasa_descuento }%|.
  ENDMETHOD.

  METHOD zif_printable_01~obtener_info_corta.
* Retorna una descripcion corta del cliente
    rv_corta = |{ me->nombre } ({ me->tipo })|.
  ENDMETHOD.

  METHOD obtener_datos_cliente.
* Exporta todos los datos del cliente como estructura
    es_cliente-id_cliente = me->id_cliente.
    es_cliente-nombre     = me->nombre.
    es_cliente-correo     = me->correo.
    es_cliente-tipo       = me->tipo.
  ENDMETHOD.

ENDCLASS.
