# Crie no minimo 5 pedidos
# Para cada pedido pelo menos 3 itens cada
# INSERT na tabela de pedido e itempedido

use bd_vendas;

# Resetar dados inseridos
truncate tbl_itempedido;

#### DEPOIS TENTAR PEGAR O ID DO PEDIDO AUTOMATICAMENTE

############################ PEDIDO 1 ###############################
INSERT INTO tbl_pedido(data_pedido, data_entrega, cod_cliente) 
	values(
    (select NOW()),
	(select NOW() + interval 2 day),
    (select cod_cliente from tbl_cliente where nome_cliente = 'Marcos Costa de Souza')
);
INSERT INTO tbl_itempedido(qtde, i_cod_pedido, i_cod_produto, i_valor) values
	(3, 1,
    (select cod_produto from tbl_produto where nome_produto = 'Arroz'),
    (select valor * 3 from tbl_produto where nome_produto = 'Arroz')
), (2, 1,
    (select cod_produto from tbl_produto where nome_produto = 'feijão'),
    (select valor * 2 from tbl_produto where nome_produto = 'Feijão')
), (5, 1,
    (select cod_produto from tbl_produto where nome_produto = 'Leite'),
    (select valor * 5 from tbl_produto where nome_produto = 'Leite')
);


############################ PEDIDO 2 ###############################
INSERT INTO tbl_pedido(data_pedido, data_entrega, cod_cliente) 
	values(
    (select NOW()),
	(select NOW() + interval 1 day),
    (select cod_cliente from tbl_cliente where nome_cliente = 'Zizafânio Zizundo')
);
INSERT INTO tbl_itempedido(qtde, i_cod_pedido, i_cod_produto, i_valor) values
	(3, 2,
    (select cod_produto from tbl_produto where nome_produto = 'Óleo'),
    (select valor * 3 from tbl_produto where nome_produto = 'Óleo')
), (1, 2,
    (select cod_produto from tbl_produto where nome_produto = 'Vinagre'),
    (select valor * 1 from tbl_produto where nome_produto = 'Vinagre')
), (7, 2,
    (select cod_produto from tbl_produto where nome_produto = 'Macarrão'),
    (select valor * 7 from tbl_produto where nome_produto = 'Macarrão')
);



############################ PEDIDO 3 ###############################
INSERT INTO tbl_pedido(data_pedido, data_entrega, cod_cliente) 
	values(
    (select NOW()),
	(select NOW() + interval 1 day),
    (select cod_cliente from tbl_cliente where nome_cliente = 'Zizafânio Zizundo')
);
INSERT INTO tbl_itempedido(qtde, i_cod_pedido, i_cod_produto, i_valor) values
	(5, 3,
    (select cod_produto from tbl_produto where nome_produto = 'Café'),
    (select valor * 5 from tbl_produto where nome_produto = 'Café')
), (6, 3,
    (select cod_produto from tbl_produto where nome_produto = 'Tomate'),
    (select valor * 6 from tbl_produto where nome_produto = 'Tomate')
), (10, 3,
    (select cod_produto from tbl_produto where nome_produto = 'Batata'),
    (select valor * 10 from tbl_produto where nome_produto = 'Batata')
);



############################ PEDIDO 4 ###############################
INSERT INTO tbl_pedido(data_pedido, data_entrega, cod_cliente) 
	values(
    (select NOW()),
	(select NOW() + interval 7 day),
    (select cod_cliente from tbl_cliente where nome_cliente = 'Cosmólio Ferreira')
);
INSERT INTO tbl_itempedido(qtde, i_cod_pedido, i_cod_produto, i_valor) values
	(12, 4,
    (select cod_produto from tbl_produto where nome_produto = 'Macarrão'),
    (select valor * 12 from tbl_produto where nome_produto = 'Macarrão')
), (33, 4,
    (select cod_produto from tbl_produto where nome_produto = 'Tomate'),
    (select valor * 33 from tbl_produto where nome_produto = 'Tomate')
), (41, 4,
    (select cod_produto from tbl_produto where nome_produto = 'Cebola'),
    (select valor * 41 from tbl_produto where nome_produto = 'Cebola')
);



############################ PEDIDO 5 ###############################
INSERT INTO tbl_pedido(data_pedido, data_entrega, cod_cliente) 
	values(
    (select NOW()),
	(select NOW() + interval 10 day),
    (select cod_cliente from tbl_cliente where nome_cliente = 'Aninoado Zinzão')
);
INSERT INTO tbl_itempedido(qtde, i_cod_pedido, i_cod_produto, i_valor) values
	(120, 4,
    (select cod_produto from tbl_produto where nome_produto = 'Batata'),
    (select valor * 120 from tbl_produto where nome_produto = 'Batata')
), (50, 4,
    (select cod_produto from tbl_produto where nome_produto = 'Óleo'),
    (select valor * 50 from tbl_produto where nome_produto = 'Óleo')
), (42, 4,
    (select cod_produto from tbl_produto where nome_produto = 'Cebola'),
    (select valor * 42 from tbl_produto where nome_produto = 'Cebola')
);