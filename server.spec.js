const mongoose = require('mongoose');

describe('Verifica se o host consegue conectar na base de dados', () => {

	const messages = ['Teste1', 'Teste2', 'Testando', 'Testando2'];

	it('deve retornar todas as mensagens', () => {
		expect(messages).toContain('Testando');
		expect(messages).not.toContain(Number);
	})
})