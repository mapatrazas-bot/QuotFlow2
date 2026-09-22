@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista raiz productos - QuotFlow'
@Metadata.allowExtensions: true

define root view entity ZDD_R_PROD_01
  as select from zdt_prod_01
{
  key id_producto       as IdProducto,
      nombre            as Nombre,
      categoria         as Categoria,
      precio_unitario   as PrecioUnitario,
      moneda            as Moneda,
      activo            as Activo,
      creado_por        as CreadoPor,
      @Semantics.systemDateTime.createdAt: true
      creado_en         as CreadoEn,
      @Semantics.systemDateTime.lastChangedAt: true
      modificado_en     as ModificadoEn
}
