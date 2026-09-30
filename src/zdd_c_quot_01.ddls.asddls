@EndUserText.label: 'Projection View - Cotizaciones QuotFlow'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true 
@Search.searchable: true

define root view entity ZDD_C_QUOT_01
  provider contract transactional_query
  as projection on ZDD_R_QUOT_01
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  key IdCotizacion,

  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7
  NombreCliente,

  @Search.defaultSearchElement: true
  Estado,

@Consumption.valueHelpDefinition: [{
  entity: {
    name:    'ZDD_VH_CLIENT_01',
    element: 'IdCliente'
  }
}]
IdCliente,

  Total,
  Moneda,
  FechaCreacion,
  MotivoRechazo,
  CreadoPor,
  CreadoEn,
  ModificadoEn,
  _Posiciones : redirected to composition child ZDD_C_ITEM_01,
  _Cliente
}
