@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista proyeccion cotizaciones - QuotFlow'
@Metadata.allowExtensions: true

define root view entity ZDD_C_QUOT_01
  provider contract transactional_query
  as projection on ZDD_R_QUOT_01
{
  key IdCotizacion,
      IdCliente,
      NombreCliente,
      Estado,
      Total,
      Moneda,
      MotivoRechazo,
      FechaCreacion,
      CreadoPor,
      CreadoEn,
      ModificadoEn,

      _Posiciones : redirected to composition child ZDD_C_ITEM_01,
      _Cliente
}
