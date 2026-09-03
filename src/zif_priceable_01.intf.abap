INTERFACE zif_priceable_01
  PUBLIC.

  METHODS calcular_descuento
    IMPORTING VALUE(iv_precio_base)  TYPE decfloat16
    RETURNING VALUE(rv_precio_final) TYPE decfloat16.

  METHODS obtener_tasa_descuento
    RETURNING VALUE(rv_tasa) TYPE decfloat16.

ENDINTERFACE.
