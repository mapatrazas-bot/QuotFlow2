@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista proyeccion posiciones - QuotFlow'
@Metadata.allowExtensions: true

define view entity ZDD_C_ITEM_01
  as projection on ZDD_R_ITEM_01
{
  key IdCotizacion,
  key IdPosicion,
      IdProducto,
      NombreProducto,
      Cantidad,
      PrecioUnitario,
      TotalLinea,
      Moneda,
      CreadoPor,
      CreadoEn,
      ModificadoEn,

      _Cotizacion : redirected to parent ZDD_C_QUOT_01,
      _Producto
}
