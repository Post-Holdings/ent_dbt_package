{%- macro lkp_uom(ITEM_GUID, FROM_UOM, TO_UOM, ALIAS) -%}
(select
item_guid,from_uom,to_uom,conversion_rate,inversion_rate,
row_number() over (partition by item_guid, from_uom, to_uom order by item_guid, from_uom, to_uom) as row_num
from ({{ ref("v_dim_uom") }})) {{ ALIAS }}
on {{ ALIAS }}.item_guid = case
when {{ FROM_UOM }}= {{ TO_UOM }}
        or ({{ FROM_UOM }}= 'LB' and {{ TO_UOM }} = 'KG')
        or ({{ FROM_UOM }}= 'KG' and {{ TO_UOM }} = 'LB')
        or ({{ FROM_UOM }}= 'CW' and {{ TO_UOM }} = 'LB')
        or ({{ FROM_UOM }}= 'LB' and {{ TO_UOM }} = 'CW')
then 'dummy' else {{ ITEM_GUID }} end
and {{ ALIAS }}.from_uom = {{ FROM_UOM }}
and {{ ALIAS }}.to_uom = {{ TO_UOM }}
and {{ ALIAS }}.row_num = 1
{%- endmacro -%}
