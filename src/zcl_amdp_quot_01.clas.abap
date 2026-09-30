CLASS zcl_amdp_quot_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_quot_stats
      FOR TABLE FUNCTION ZDD_TF_QUOT_STATS_01.

ENDCLASS.

CLASS zcl_amdp_quot_01 IMPLEMENTATION.

  METHOD get_quot_stats
    BY DATABASE FUNCTION FOR HDB        " ← FUNCTION, no PROCEDURE
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING zdt_quot_01 zdt_client_01.

    RETURN SELECT
      q.mandt                  AS client,
      c.id_cliente             AS client_id,
      c.nombre                 AS client_name,
      COUNT(q.id_cotizacion)   AS total_quotations,
      SUM(q.total)             AS total_amount,
      AVG(q.total)             AS avg_amount,
      MAX(q.total)             AS max_amount,
      MIN(q.total)             AS min_amount
    FROM zdt_quot_01 AS q
    INNER JOIN zdt_client_01 AS c
      ON  q.mandt      = c.mandt
      AND q.id_cliente = c.id_cliente
    WHERE q.mandt = SESSION_CONTEXT('CLIENT')
      AND (:p_status = '' OR q.estado = :p_status)
    GROUP BY q.mandt, c.id_cliente, c.nombre
    ORDER BY total_amount DESC;

  ENDMETHOD.

ENDCLASS.
