@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dimension productos - QuotFlow'
@Analytics.dataCategory: #DIMENSION
//@Analytics.dataExtraction.enabled: true

define view entity ZDD_R_PROD_DIM_01
  as select from zdt_prod_01
{
  key id_producto    as IdProducto,
      nombre         as Nombre,
      categoria      as Categoria,
      precio_unitario as PrecioUnitario,
      moneda         as Moneda
}
