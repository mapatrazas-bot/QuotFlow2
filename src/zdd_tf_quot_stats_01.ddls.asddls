@EndUserText.label: 'TF Estadisticas cotizaciones'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE

define table function ZDD_TF_QUOT_STATS_01
  with parameters
    p_status : abap.char(20)
  returns {
    client           : abap.clnt;
    client_id        : abap.char(10);
    client_name      : abap.char(100);
    total_quotations : abap.int4;
    total_amount     : abap.dec(15,2);
    avg_amount       : abap.dec(15,2);
    max_amount       : abap.dec(15,2);
    min_amount       : abap.dec(15,2);
  }
  implemented by method ZCL_AMDP_QUOT_01=>GET_QUOT_STATS;