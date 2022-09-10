drop view if exists vw_clienPedido;
drop view if exists vw_clienPedItem;
drop view if exists vw_pedidDado;
drop view if exists vw_prodReajus;
 
 
# Que enxerguem os dados do cliente (código e nome) e pedidos (número do pedido, 
# data do pedido e data de entrega), onde a data do pedido seja superior a 
# 30/01/2014;
create view vw_clienPedido as
	select a.cod_cliente, a.nome_cliente, b.cod_pedido, b.data_pedido, b.data_entrega
		from tbl_cliente a, tbl_pedido b
			where a.cod_cliente = b.cod_cliente 
            and b.data_pedido > 2014-01-30
				group by a.cod_cliente;
   
select * from vw_clienPedido;   
   
   
# Que enxerguem os dados do cliente (código do cliente e nome), dados do pedido 
# (código do pedido, data do pedido e data da entrega), os dados do item do pedido 
# (quantidade e código do produto), onde a quantidade destes produtos sejam 
# maiores de 25;
create view vw_clienPedItem as 
	select a.cod_cliente, a.nome_cliente, b.cod_pedido, b.data_pedido, b.data_entrega, c.qtde, c.i_cod_produto
		from tbl_cliente a, tbl_pedido b, tbl_itempedido c
			where a.cod_cliente = b.cod_cliente
            and b.cod_pedido = c.i_cod_pedido
			and qtde >= 25;

select * from vw_clienPedItem;
	

# Que enxerguem os dados do pedido (código do pedido, código do cliente), os 
# dados do item do pedido (quantidade, código do produto e descrição do produto);
create view vw_pedidDado as 
	select a.cod_pedido, a.cod_cliente, b.qtde, b.i_cod_produto, b.i_valor
		from tbl_pedido a, tbl_itempedido b
			where a.cod_pedido = b.i_cod_produto;
                
select * from vw_clienPedItem;
    
    
# Que enxerguem os produtos reajustados em 11,2 %, onde deverá ser mostrado o 
# código e a descrição do produto, o valor atual e o valor reajustado
create view vw_prodReajus as
	select cod_produto, desc_produto, valor, valor * 1.112 reajuste
		from tbl_produto;
        
select * from vw_prodReajus;