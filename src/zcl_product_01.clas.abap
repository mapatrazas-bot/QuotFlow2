CLASS zcl_product_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_product,
        product_id TYPE string,
        name       TYPE string,
        unit_price TYPE decfloat16,
        currency   TYPE c LENGTH 3,
        category   TYPE string,
      END OF t_product.

    TYPES tt_products TYPE TABLE OF t_product.

    CONSTANTS:
      BEGIN OF cs_category,
        hardware TYPE string VALUE 'HARDWARE',
        software TYPE string VALUE 'SOFTWARE',
        service  TYPE string VALUE 'SERVICE',
      END OF cs_category.


    CLASS-DATA company_currency TYPE string VALUE 'USD' READ-ONLY.

    METHODS constructor
      IMPORTING
        VALUE(iv_product_id) TYPE string
        VALUE(iv_name)       TYPE string
        VALUE(iv_unit_price) TYPE decfloat16
        VALUE(iv_category)   TYPE string OPTIONAL.

    METHODS get_product_info
      RETURNING VALUE(rs_product) TYPE t_product.

    METHODS set_price
      IMPORTING VALUE(iv_price) TYPE decfloat16.

    METHODS get_price
      RETURNING VALUE(rv_price) TYPE decfloat16.

   CLASS-METHODS set_company_currency
  IMPORTING VALUE(iv_currency) TYPE string.

  PRIVATE SECTION.
    DATA product_id TYPE string.
    DATA name       TYPE string.
    DATA unit_price TYPE decfloat16.
    DATA category   TYPE string.

ENDCLASS.


CLASS zcl_product_01 IMPLEMENTATION.

  METHOD constructor.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Inicializa el producto con sus datos base
* Paquete   : ZPORTFOLIO_01
    me->product_id = iv_product_id.
    me->name       = iv_name.
    me->unit_price = iv_unit_price.
    IF iv_category IS SUPPLIED.
      me->category = iv_category.
    ELSE.
      me->category = cs_category-software.
    ENDIF.
  ENDMETHOD.

  METHOD get_product_info.
* Retorna la informacion completa del producto como estructura
    rs_product-product_id = me->product_id.
    rs_product-name       = me->name.
    rs_product-unit_price = me->unit_price.
    rs_product-currency   = company_currency.
    rs_product-category   = me->category.
  ENDMETHOD.

  METHOD set_price.
* Actualiza el precio unitario del producto
    me->unit_price = iv_price.
  ENDMETHOD.

  METHOD get_price.
* Retorna el precio actual del producto
    rv_price = me->unit_price.
  ENDMETHOD.

  METHOD set_company_currency.
* Cambia la moneda global para todos los productos
    company_currency = iv_currency.
  ENDMETHOD.

ENDCLASS.
