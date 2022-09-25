use bd_vendas;

drop trigger if exists trg_log;
drop trigger if exists trg_updtPedido;
drop trigger if exists trg_dltPedido;
drop trigger if exists trg_instCliente;

# Para visualizar triggers de uma tabela
# show triggers from bd_vendas;


# Exemplo de trigger
# link com a tabela tbl_log
/*
delimiter $
create trigger trg_log before delete 
	on tbl_cliente
	for each row
begin
	insert into tbl_log(usuario, dt_log, hora)
		value(user(), curdate(), curtime());
end $ 
*/

# Modifique a tabela tbl_log acrescentando um campo onde armazene o tipo de
# operação realizada, sendo: “INSERÇÃO”, “ATUALIZAÇÃO” ou “EXCLUSÃO” e
# outro campo que armazene a tabela que está sendo realizadas as ações.
alter table tbl_log
	add operacao varchar(45),
    add tbl varchar(45);


# De acordo com o exercício anterior crie uma trigger que ao atualizar e antes de qualquer
# ação na tabela de Pedidos
delimiter $
create trigger trg_updtPedido before update
	on tbl_pedido 
    for each row
begin
	insert into tbl_log(usuario, dt_log, hora, operacao, tbl)
		value (user(), curdate(), curtime(), 'UPDATE', 'tbl_pedido');
end $        


# De acordo com o exercício A crie uma trigger que ao excluir e antes de qualquer
# ação na tabela de Produtos;
delimiter $
create trigger trg_dltPedido before delete
	on tbl_pedido
    for each row
begin
	insert into tbl_log(usuario, dt_log, hora, operacao, tbl)
		value (user(), curdate(), curtime(), 'DELETE', 'tbl_pedido');
end $


# De acordo com o exercício A crie uma trigger que ao inserir e depois de qualquer
# ação na tabela de Clientes.
delimiter $
create trigger trg_instCliente before insert
	on tbl_pedido
    for each row
begin 
	insert into tbl_log(usuario, dt_log, hora, operacao, tbl)
		value(user(), curdate(), curtime(), 'INSERT', 'tbl_cliente');
end $

select * from tbl_log;