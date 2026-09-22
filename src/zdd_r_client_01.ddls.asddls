@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista raiz clientes - QuotFlow'
@Metadata.allowExtensions: true

define root view entity ZDD_R_CLIENT_01
  as select from zdt_client_01
{
  key id_cliente        as IdCliente,
      nombre            as Nombre,
      correo            as Correo,
      tipo              as Tipo,
      nivel_vip         as NivelVip,
      tasa_descuento    as TasaDescuento,
      activo            as Activo,
      creado_por        as CreadoPor,
      @Semantics.systemDateTime.createdAt: true
      creado_en         as CreadoEn,
      @Semantics.systemDateTime.lastChangedAt: true
      modificado_en     as ModificadoEn
}
