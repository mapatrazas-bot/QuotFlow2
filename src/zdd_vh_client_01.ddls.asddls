@EndUserText.label: 'Ayuda busqueda clientes'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory:   #S,
  dataClass:      #MASTER
}

define view entity ZDD_VH_CLIENT_01
  as select from zdt_client_01
{
  key id_cliente     as IdCliente,
      nombre         as Nombre,
      tipo           as Tipo,
      nivel_vip      as NivelVip,
      tasa_descuento as TasaDescuento,
      activo         as Activo
}
