@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista raiz cotizaciones - QuotFlow'
@Metadata.allowExtensions: true

define root view entity ZDD_R_QUOT_01
  as select from zdt_quot_01
 composition [0..*] of ZDD_R_ITEM_01 as _Posiciones
  association [0..1] to ZDD_R_CLIENT_01 as _Cliente
    on $projection.IdCliente = _Cliente.IdCliente
{
  key id_cotizacion     as IdCotizacion,
      id_cliente        as IdCliente,
      nombre_cliente    as NombreCliente,
      estado            as Estado,
      total             as Total,
      moneda            as Moneda,
      motivo_rechazo    as MotivoRechazo,
      fecha_creacion    as FechaCreacion,
      creado_por        as CreadoPor,
      @Semantics.systemDateTime.createdAt: true
      creado_en         as CreadoEn,
      @Semantics.systemDateTime.lastChangedAt: true
      modificado_en     as ModificadoEn,

      _Posiciones,
      _Cliente
}
