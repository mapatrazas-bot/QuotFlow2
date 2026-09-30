CLASS zcl_sadl_exit_quot_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit.
    INTERFACES if_sadl_exit_calc_element_read.

ENDCLASS.

CLASS zcl_sadl_exit_quot_01 IMPLEMENTATION.

METHOD if_sadl_exit_calc_element_read~get_calculation_info.
* Autor      : CB9980004419
* Fecha      : 2025-01-01
* Descripcion: SADL Exit - Informa elementos originales necesarios para calcular
* Paquete    : ZPORTFOLIO_01

* Declarar como string explicito para coincidir con tt_elements (SORTED TABLE OF string)
    DATA lv_elemento TYPE string.
    lv_elemento = 'ESTADO'.
    INSERT lv_elemento INTO TABLE et_requested_orig_elements.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.
* Calcular EstadoTexto basado en el valor de Estado
* Se trabaja con indice porque las tablas son genericas (TYPE STANDARD TABLE)
    DATA lv_indice TYPE i.

    LOOP AT it_original_data ASSIGNING FIELD-SYMBOL(<ls_original>).
      lv_indice = sy-tabix.

* Leer el campo Estado desde la fila original via asignacion dinamica
      ASSIGN COMPONENT 'ESTADO' OF STRUCTURE <ls_original> TO FIELD-SYMBOL(<lv_estado>).

      IF <lv_estado> IS ASSIGNED.
* Escribir EstadoTexto en la tabla de datos calculados
        ASSIGN ct_calculated_data[ lv_indice ] TO FIELD-SYMBOL(<ls_calculado>).
        IF <ls_calculado> IS ASSIGNED.
          ASSIGN COMPONENT 'ESTADOTEXTO' OF STRUCTURE <ls_calculado>
                 TO FIELD-SYMBOL(<lv_texto>).
          IF <lv_texto> IS ASSIGNED.
            CASE <lv_estado>.
              WHEN 'DRAFT'.     <lv_texto> = 'Borrador'.
              WHEN 'APPROVED'.  <lv_texto> = 'Aprobada'.
              WHEN 'REJECTED'.  <lv_texto> = 'Rechazada'.
              WHEN 'CANCELLED'. <lv_texto> = 'Cancelada'.
              WHEN OTHERS.      <lv_texto> = 'Desconocido'.
            ENDCASE.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
