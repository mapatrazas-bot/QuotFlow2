CLASS zcl_company_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_address,
        country     TYPE string,
        city        TYPE string,
        street      TYPE string,
        postal_code TYPE string,
      END OF t_address.

    CONSTANTS:
      BEGIN OF cs_type,
        local    TYPE string VALUE 'LOCAL',
        national TYPE string VALUE 'NATIONAL',
        global   TYPE string VALUE 'GLOBAL',
      END OF cs_type.

    DATA company_code TYPE string READ-ONLY.
    DATA company_name TYPE string     READ-ONLY.

    METHODS constructor
      IMPORTING
        VALUE(iv_company_code) TYPE string
        VALUE(iv_company_name) TYPE string
        VALUE(iv_type)         TYPE string OPTIONAL.

    METHODS set_address
      IMPORTING VALUE(is_address) TYPE t_address.

    METHODS get_address
      RETURNING VALUE(rs_address) TYPE t_address.

    METHODS get_company_type
      RETURNING VALUE(rv_type) TYPE string.

    METHODS get_full_info
      RETURNING VALUE(rv_info) TYPE string.

  PRIVATE SECTION.
    DATA address      TYPE t_address.
    DATA company_type TYPE string.

ENDCLASS.


CLASS zcl_company_01 IMPLEMENTATION.

  METHOD constructor.
* Autor     : CB9980004419
* Fecha     : 2025
* Descripcion: Registra codigo, nombre y tipo de empresa
* Paquete   : ZPORTFOLIO_01
    me->company_code = iv_company_code.
    me->company_name = iv_company_name.
    IF iv_type IS SUPPLIED.
      me->company_type = iv_type.
    ELSE.
      me->company_type = cs_type-local.
    ENDIF.
  ENDMETHOD.

  METHOD set_address.
* Establece la direccion fisica de la empresa
    me->address = is_address.
  ENDMETHOD.

  METHOD get_address.
* Retorna la direccion registrada de la empresa
    rs_address = me->address.
  ENDMETHOD.

  METHOD get_company_type.
* Retorna el tipo de empresa (LOCAL, NATIONAL, GLOBAL)
    rv_type = me->company_type.
  ENDMETHOD.

  METHOD get_full_info.
* Retorna un resumen en texto de la empresa (metodo funcional)
    rv_info = |Empresa: { me->company_name } | &
              |[{ me->company_code }] - | &
              |Tipo: { me->company_type } - | &
              |Ciudad: { me->address-city }|.
  ENDMETHOD.

ENDCLASS.
