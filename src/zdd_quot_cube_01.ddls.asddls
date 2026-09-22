@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cubo analitico cotizaciones - QuotFlow'
@Analytics.dataCategory: #CUBE
//@Analytics.dataExtraction.enabled: true

define view entity ZDD_QUOT_CUBE_01
  as select from zdt_quot_01
  association [0..1] to ZDD_R_CLIENT_DIM_01 as _Cliente
    on $projection.IdCliente = _Cliente.IdCliente
{
  key id_cotizacion          as IdCotizacion,
      id_cliente             as IdCliente,
      nombre_cliente         as NombreCliente,
      estado                 as Estado,

      @DefaultAggregation: #SUM
      total                  as Total,
      moneda                 as Moneda,

      fecha_creacion         as FechaCreacion,
      creado_por             as CreadoPor,

      @Semantics.systemDateTime.createdAt: true
      creado_en              as CreadoEn,
      @Semantics.systemDateTime.lastChangedAt: true
      modificado_en          as ModificadoEn,

      _Cliente
}
