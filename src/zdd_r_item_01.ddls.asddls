@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista posiciones cotizacion - QuotFlow'
@Metadata.allowExtensions: true

define view entity ZDD_R_ITEM_01
  as select from zdt_item_01
  association to parent ZDD_R_QUOT_01 as _Cotizacion
    on $projection.IdCotizacion = _Cotizacion.IdCotizacion
  association [0..1] to ZDD_R_PROD_01 as _Producto
    on $projection.IdProducto = _Producto.IdProducto
{
  key id_cotizacion     as IdCotizacion,
  key id_posicion       as IdPosicion,
      id_producto       as IdProducto,
      nombre_producto   as NombreProducto,
      cantidad          as Cantidad,
      precio_unitario   as PrecioUnitario,
      total_linea       as TotalLinea,
      moneda            as Moneda,
      creado_por        as CreadoPor,
      @Semantics.systemDateTime.createdAt: true
      creado_en         as CreadoEn,
      @Semantics.systemDateTime.lastChangedAt: true
      modificado_en     as ModificadoEn,

      _Cotizacion,
      _Producto
}
