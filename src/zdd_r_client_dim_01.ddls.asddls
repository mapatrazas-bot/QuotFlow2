@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dimension clientes - QuotFlow'
@Analytics.dataCategory: #DIMENSION
//@Analytics.dataExtraction.enabled: true

define view entity ZDD_R_CLIENT_DIM_01
  as select from zdt_client_01
{
  key id_cliente     as IdCliente,
      nombre         as Nombre,
      tipo           as Tipo,
      nivel_vip      as NivelVip,
      tasa_descuento as TasaDescuento
}
